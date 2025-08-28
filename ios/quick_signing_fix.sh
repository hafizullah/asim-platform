#!/bin/bash

echo "=== Quick iOS Signing Fix for GitHub Actions ==="

# This script directly fixes the Xcode project configuration
# for the specific provisioning profiles that GitHub Actions downloads

cd ios

# Get the provisioning profile UUIDs from the GitHub Actions output
# Based on your logs:
# - Development profile "asim": de5c7240-7cc2-4453-86f0-8aeb731909db  
# - Distribution profile "asim-prod": d1677fe0-db29-4970-937c-d44ec7067064

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

# Backup the project file
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup

echo "Configuring Xcode project for manual signing..."

# Use a simple approach with sed to make the necessary changes
# 1. Change CODE_SIGN_STYLE from Automatic to Manual
sed -i '' 's/CODE_SIGN_STYLE = Automatic;/CODE_SIGN_STYLE = Manual;/g' Runner.xcodeproj/project.pbxproj

# 2. Set DEVELOPMENT_TEAM
sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" Runner.xcodeproj/project.pbxproj

# 3. Remove any existing PROVISIONING_PROFILE_SPECIFIER lines
sed -i '' '/PROVISIONING_PROFILE_SPECIFIER/d' Runner.xcodeproj/project.pbxproj

# 4. Add provisioning profile specifiers using a more targeted approach
# We'll use a Python script that can precisely identify the configuration sections

python3 << 'EOF'
import re

# Read the project file
with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

lines = content.split('\n')
result_lines = []
in_debug_config = False
in_release_config = False
in_profile_config = False

i = 0
while i < len(lines):
    line = lines[i]
    result_lines.append(line)
    
    # Track which configuration section we're in
    if 'name = Debug;' in line:
        in_debug_config = True
        in_release_config = False
        in_profile_config = False
    elif 'name = Release;' in line:
        in_debug_config = False
        in_release_config = True
        in_profile_config = False
    elif 'name = Profile;' in line:
        in_debug_config = False
        in_release_config = False
        in_profile_config = True
    elif line.strip() == '};' and (in_debug_config or in_release_config or in_profile_config):
        # End of configuration section
        in_debug_config = False
        in_release_config = False
        in_profile_config = False
    
    # If we find DEVELOPMENT_TEAM line, add provisioning profile after it
    if 'DEVELOPMENT_TEAM = ' in line and '""' not in line:
        if in_debug_config:
            result_lines.append('\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "de5c7240-7cc2-4453-86f0-8aeb731909db";')
            print("✓ Added development provisioning profile for Debug configuration")
        elif in_release_config or in_profile_config:
            result_lines.append('\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "d1677fe0-db29-4970-937c-d44ec7067064";')
            config_type = "Release" if in_release_config else "Profile"
            print(f"✓ Added distribution provisioning profile for {config_type} configuration")
    
    i += 1

# Write the result
with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
    f.write('\n'.join(result_lines))

print("✅ Provisioning profiles configured")
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
