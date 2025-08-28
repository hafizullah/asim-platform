#!/bin/bash

echo "=== Quick iOS Signing Fix for GitHub Actions ==="

# This script directly fixes the Xcode project configuration
# for the specific provisioning profiles that GitHub Actions downloads

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

# Fixed provisioning profile UUIDs based on GitHub Actions output:
# - Development profile "asim": de5c7240-7cc2-4453-86f0-8aeb731909db  
# - Distribution profile "asim-prod": d1677fe0-db29-4970-937c-d44ec7067064
DEV_PROFILE_UUID="de5c7240-7cc2-4453-86f0-8aeb731909db"
DIST_PROFILE_UUID="d1677fe0-db29-4970-937c-d44ec7067064"

# Extract team ID from any available provisioning profile
TEAM_ID=""
PROFILE_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"

if [ -d "$PROFILE_DIR" ]; then
    for profile in "$PROFILE_DIR"/*.mobileprovision; do
        if [ -f "$profile" ]; then
            TEAM_ID=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract TeamIdentifier.0 raw - 2>/dev/null)
            if [ -n "$TEAM_ID" ]; then
                echo "Found Team ID: $TEAM_ID"
                break
            fi
        fi
    done
fi

if [ -z "$TEAM_ID" ]; then
    echo "❌ Could not find team ID from provisioning profiles"
    exit 1
fi

# Check what certificates are available in the keychain
echo "Available certificates in keychain:"
security find-identity -v -p codesigning

# Export environment variables for Python script
export TEAM_ID
export DEV_PROFILE_UUID
export DIST_PROFILE_UUID

# Backup the project file
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup

echo "Configuring Xcode project for manual signing..."

# Create a more robust Python script to handle the configuration
python3 << 'EOF'
import re

def update_xcode_project():
    # Read the project file
    with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    result_lines = []
    in_runner_debug = False
    in_runner_release = False
    in_runner_profile = False
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Track which configuration we're in - only for Runner target, not tests
        if re.search(r'[A-F0-9]{24} /\* Debug \*/ = {', line):
            # Check if this is a Runner configuration by looking ahead
            debug_section = '\n'.join(lines[i:min(i+50, len(lines))])
            if 'PRODUCT_BUNDLE_IDENTIFIER = ' in debug_section and 'Runner' in debug_section:
                in_runner_debug = True
                in_runner_release = False
                in_runner_profile = False
        elif re.search(r'[A-F0-9]{24} /\* Release \*/ = {', line):
            # Check if this is a Runner configuration
            release_section = '\n'.join(lines[i:min(i+50, len(lines))])
            if 'PRODUCT_BUNDLE_IDENTIFIER = ' in release_section and 'Runner' in release_section:
                in_runner_debug = False
                in_runner_release = True
                in_runner_profile = False
        elif re.search(r'[A-F0-9]{24} /\* Profile \*/ = {', line):
            # Check if this is a Runner configuration
            profile_section = '\n'.join(lines[i:min(i+50, len(lines))])
            if 'PRODUCT_BUNDLE_IDENTIFIER = ' in profile_section and 'Runner' in profile_section:
                in_runner_debug = False
                in_runner_release = False
                in_runner_profile = True
        elif line.strip() == '};' and (in_runner_debug or in_runner_release or in_runner_profile):
            # End of configuration section
            in_runner_debug = False
            in_runner_release = False
            in_runner_profile = False
        
        # Update CODE_SIGN_STYLE to Manual for Runner configurations
        if 'CODE_SIGN_STYLE = Automatic;' in line and (in_runner_debug or in_runner_release or in_runner_profile):
            line = line.replace('CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;')
            print(f"✓ Set manual signing for {'Debug' if in_runner_debug else 'Release' if in_runner_release else 'Profile'}")
        
        # Update DEVELOPMENT_TEAM for Runner configurations
        if 'DEVELOPMENT_TEAM = "";' in line and (in_runner_debug or in_runner_release or in_runner_profile):
            line = line.replace('DEVELOPMENT_TEAM = "";', f'DEVELOPMENT_TEAM = "{TEAM_ID}";')
            print(f"✓ Set team ID for {'Debug' if in_runner_debug else 'Release' if in_runner_release else 'Profile'}")
        
        result_lines.append(line)
        
        # Add provisioning profile after DEVELOPMENT_TEAM line
        if 'DEVELOPMENT_TEAM = ' in line and '""' not in line and (in_runner_debug or in_runner_release or in_runner_profile):
            if in_runner_debug:
                result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{DEV_PROFILE_UUID}";')
                print("✓ Added development provisioning profile for Debug")
            elif in_runner_release or in_runner_profile:
                result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{DIST_PROFILE_UUID}";')
                config_type = "Release" if in_runner_release else "Profile"
                print(f"✓ Added distribution provisioning profile for {config_type}")
        
        i += 1
    
    # Write the result back
    with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
        f.write('\n'.join(result_lines))
    
    print("✅ Xcode project configuration updated")

# Run the update with the variables from shell
import os
TEAM_ID = os.environ.get('TEAM_ID', '')
DEV_PROFILE_UUID = os.environ.get('DEV_PROFILE_UUID', '')
DIST_PROFILE_UUID = os.environ.get('DIST_PROFILE_UUID', '')

if TEAM_ID and DEV_PROFILE_UUID and DIST_PROFILE_UUID:
    update_xcode_project()
else:
    print("❌ Missing required environment variables")
    exit(1)
EOF

echo "✅ Configuration completed"

# Verify the changes
echo ""
echo "=== Verification ==="
echo "Manual signing configurations:"
grep -c "CODE_SIGN_STYLE = Manual;" Runner.xcodeproj/project.pbxproj

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" Runner.xcodeproj/project.pbxproj

echo "Provisioning profile configurations:"
grep -c "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj

echo ""
echo "Provisioning profile details:"
grep -n "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj

echo ""
echo "✅ iOS signing configuration completed!"
echo "The project should now build successfully with the downloaded provisioning profiles."
