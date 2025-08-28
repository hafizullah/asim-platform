#!/bin/bash

echo "=== GitHub Actions iOS Signing Fix ==="

# This script configures the Xcode project for GitHub Actions deployment
# It uses the certificates and provisioning profiles downloaded by the action

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

echo "Using Team ID: $TEAM_ID"

# List available certificates
echo "Available certificates:"
security find-identity -v -p codesigning

# For GitHub Actions, we need to use automatic signing with the correct team ID
# The certificates and profiles are installed in the keychain, so Xcode should find them automatically

# Backup the project file
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup.$(date +%s)

echo "Configuring Xcode project for automatic signing with GitHub Actions certificates..."

# Create Python script to configure automatic signing
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
            # Set automatic signing (GitHub Actions works better with automatic)
            if 'CODE_SIGN_STYLE = Manual;' in line:
                line = line.replace('CODE_SIGN_STYLE = Manual;', 'CODE_SIGN_STYLE = Automatic;')
                print(f"✓ Set automatic signing for {current_config}")
            elif 'CODE_SIGN_STYLE' not in line and 'DEVELOPMENT_TEAM = ' in line:
                # Add automatic signing if not present
                result_lines.append(line)
                result_lines.append('\t\t\t\tCODE_SIGN_STYLE = Automatic;')
                print(f"✓ Added automatic signing for {current_config}")
                i += 1
                continue
            
            # Set team ID (handle both empty and existing team IDs)
            if 'DEVELOPMENT_TEAM = ' in line:
                if '""' in line or TEAM_ID not in line:
                    line = re.sub(r'DEVELOPMENT_TEAM = "[^"]*";', f'DEVELOPMENT_TEAM = "{TEAM_ID}";', line)
                    print(f"✓ Set team ID for {current_config}")
            
            # Remove manual provisioning profile specifiers for automatic signing
            if 'PROVISIONING_PROFILE_SPECIFIER = ' in line:
                print(f"✓ Removing manual provisioning profile for {current_config} (using automatic)")
                i += 1
                continue  # Skip this line
        
        result_lines.append(line)
        i += 1
    
    # Write the result back
    with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
        f.write('\n'.join(result_lines))
    
    print("✅ Xcode project configuration updated for GitHub Actions")

# Get team ID from environment
TEAM_ID = os.environ.get('TEAM_ID', '')

if TEAM_ID:
    update_xcode_project()
else:
    print("❌ TEAM_ID environment variable not set")
    exit(1)
EOF

echo ""
echo "=== Verification ==="
echo "Automatic signing configurations:"
grep -c "CODE_SIGN_STYLE = Automatic;" Runner.xcodeproj/project.pbxproj

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" Runner.xcodeproj/project.pbxproj

echo "Manual provisioning profile configurations (should be 0):"
grep -c "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj || echo "0"

echo ""
echo "✅ GitHub Actions iOS signing configuration completed!"
echo "The project is now configured for automatic signing with team ID: $TEAM_ID"
