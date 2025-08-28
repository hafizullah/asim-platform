#!/bin/bash

echo "=== GitHub Actions iOS Manual Signing Fix ==="

# This script configures the Xcode project for GitHub Actions deployment with manual signing
# It uses specific provisioning profile names provided as environment variables

# Check if we're already in the ios directory or need to navigate to it
if [ ! -f "Runner.xcodeproj/project.pbxproj" ]; then
    if [ -d "ios" ]; then
        echo "Navigating to ios directory..."
        cd ios
    else
        echo "❌ Cannot find iOS project. Make sure you're running this from the project root or ios directory."
        exit 1
    fi
else
    echo "Already in ios directory or project root with direct access to Xcode project."
fi

# GitHub Actions should set these as environment variables
if [ -z "$TEAM_ID" ]; then
    echo "❌ TEAM_ID environment variable not set"
    exit 1
fi

if [ -z "$PROVISIONING_PROFILE_NAME" ]; then
    echo "❌ PROVISIONING_PROFILE_NAME environment variable not set"
    exit 1
fi

echo "Using Team ID: $TEAM_ID"
echo "Using Provisioning Profile: $PROVISIONING_PROFILE_NAME"

# List available certificates
echo "Available certificates:"
security find-identity -v -p codesigning

# List available provisioning profiles
echo "Available provisioning profiles:"
if [ -d ~/Library/MobileDevice/Provisioning\ Profiles/ ]; then
    for profile in ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision; do
        if [ -f "$profile" ]; then
            PROFILE_CONTENT=$(security cms -D -i "$profile" 2>/dev/null)
            if [ $? -eq 0 ]; then
                NAME=$(echo "$PROFILE_CONTENT" | plutil -extract Name xml1 -o - - 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<[^>]*>//g')
                echo "  - $NAME"
            fi
        fi
    done
fi

# Backup the project file
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup.$(date +%s)

echo "Configuring Xcode project for manual signing with specific provisioning profile..."

# Create Python script to configure manual signing
python3 << EOF
import re
import os

def update_xcode_project():
    # Read the project file
    with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    result_lines = []
    in_runner_config = False
    current_config = ""
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Detect Runner target configurations (not RunnerTests)
        if re.search(r'([A-F0-9]{24}) /\* (Debug|Release|Profile) \*/ = {', line):
            match = re.search(r'([A-F0-9]{24}) /\* (Debug|Release|Profile) \*/ = {', line)
            config_type = match.group(2)
            
            # Look ahead to see if this is for Runner target (not tests)
            lookahead = '\n'.join(lines[i:min(i+50, len(lines))])
            if 'PRODUCT_BUNDLE_IDENTIFIER = com.asim.asimPlatform' in lookahead or 'PRODUCT_NAME = Runner' in lookahead:
                in_runner_config = True
                current_config = config_type
                print(f"Found Runner {config_type} configuration")
            else:
                in_runner_config = False
                current_config = ""
        elif line.strip() == '};' and in_runner_config:
            in_runner_config = False
            current_config = ""
        
        # Update settings for Runner configurations only
        if in_runner_config:
            # Set manual signing
            if 'CODE_SIGN_STYLE = Automatic;' in line:
                line = line.replace('CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;')
                print(f"✓ Set manual signing for {current_config}")
            elif 'CODE_SIGN_STYLE' not in line and 'DEVELOPMENT_TEAM = ' in line:
                # Add manual signing if not present
                result_lines.append(line)
                result_lines.append('\t\t\t\tCODE_SIGN_STYLE = Manual;')
                print(f"✓ Added manual signing for {current_config}")
                i += 1
                continue
            
            # Set team ID
            if 'DEVELOPMENT_TEAM = ' in line:
                if '""' in line or TEAM_ID not in line:
                    line = re.sub(r'DEVELOPMENT_TEAM = "[^"]*";', f'DEVELOPMENT_TEAM = "{TEAM_ID}";', line)
                    print(f"✓ Set team ID for {current_config}")
            
            # Set or update provisioning profile specifier
            if 'PROVISIONING_PROFILE_SPECIFIER = ' in line:
                line = re.sub(r'PROVISIONING_PROFILE_SPECIFIER = "[^"]*";', f'PROVISIONING_PROFILE_SPECIFIER = "{PROVISIONING_PROFILE_NAME}";', line)
                print(f"✓ Set provisioning profile for {current_config}")
            elif 'PROVISIONING_PROFILE_SPECIFIER' not in line and 'DEVELOPMENT_TEAM = ' in line:
                # Add provisioning profile specifier if not present
                result_lines.append(line)
                result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{PROVISIONING_PROFILE_NAME}";')
                print(f"✓ Added provisioning profile for {current_config}")
                i += 1
                continue
        
        result_lines.append(line)
        i += 1
    
    # Write the result back
    with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
        f.write('\n'.join(result_lines))
    
    print("✅ Xcode project configuration updated for manual signing")

# Get environment variables
TEAM_ID = os.environ.get('TEAM_ID', '')
PROVISIONING_PROFILE_NAME = os.environ.get('PROVISIONING_PROFILE_NAME', '')

if TEAM_ID and PROVISIONING_PROFILE_NAME:
    update_xcode_project()
else:
    print("❌ Required environment variables not set")
    exit(1)
EOF

echo ""
echo "=== Verification ==="
echo "Manual signing configurations:"
grep -c "CODE_SIGN_STYLE = Manual;" Runner.xcodeproj/project.pbxproj

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" Runner.xcodeproj/project.pbxproj

echo "Provisioning profile configurations:"
grep -c "PROVISIONING_PROFILE_SPECIFIER = \"$PROVISIONING_PROFILE_NAME\";" Runner.xcodeproj/project.pbxproj

echo ""
echo "✅ GitHub Actions iOS manual signing configuration completed!"
echo "The project is now configured for manual signing with:"
echo "  Team ID: $TEAM_ID"
echo "  Provisioning Profile: $PROVISIONING_PROFILE_NAME"
