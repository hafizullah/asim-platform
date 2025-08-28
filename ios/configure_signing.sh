#!/bin/bash

echo "=== iOS Code Signing Configuration Script ==="

# This script configures the Xcode project for manual code signing
# It works with the provisioning profiles downloaded by GitHub Actions

# Change to ios directory if not already there
if [ "$(basename "$PWD")" != "ios" ]; then
    cd ios || { echo "❌ Could not find ios directory"; exit 1; }
fi

# Function to extract provisioning profile info
extract_profile_info() {
    local profile_path="$1"
    if [ -f "$profile_path" ]; then
        echo "Extracting info from: $(basename "$profile_path")"
        
        # Extract using security command (works on macOS)
        local name=$(security cms -D -i "$profile_path" 2>/dev/null | plutil -extract Name raw - 2>/dev/null)
        local uuid=$(security cms -D -i "$profile_path" 2>/dev/null | plutil -extract UUID raw - 2>/dev/null)
        local team_id=$(security cms -D -i "$profile_path" 2>/dev/null | plutil -extract TeamIdentifier.0 raw - 2>/dev/null)
        
        echo "  Name: $name"
        echo "  UUID: $uuid"
        echo "  Team: $team_id"
        
        # Set global variables based on profile name
        if [ "$name" = "asim" ]; then
            DEVELOPMENT_PROFILE_UUID="$uuid"
            TEAM_ID="$team_id"
        elif [ "$name" = "asim-prod" ]; then
            DISTRIBUTION_PROFILE_UUID="$uuid"
            TEAM_ID="$team_id"
        fi
    fi
}

# Find provisioning profiles
PROFILE_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"
DEVELOPMENT_PROFILE_UUID=""
DISTRIBUTION_PROFILE_UUID=""
TEAM_ID=""

echo "Searching for provisioning profiles in: $PROFILE_DIR"

if [ -d "$PROFILE_DIR" ]; then
    for profile in "$PROFILE_DIR"/*.mobileprovision; do
        extract_profile_info "$profile"
    done
else
    echo "❌ Provisioning profiles directory not found: $PROFILE_DIR"
    exit 1
fi

# Check if we found the required profiles
if [ -z "$TEAM_ID" ]; then
    echo "❌ Could not determine team ID from provisioning profiles"
    exit 1
fi

if [ -z "$DEVELOPMENT_PROFILE_UUID" ]; then
    echo "⚠️  Development profile (asim) not found"
fi

if [ -z "$DISTRIBUTION_PROFILE_UUID" ]; then
    echo "⚠️  Distribution profile (asim-prod) not found"
fi

echo "Using Team ID: $TEAM_ID"
echo "Development Profile UUID: $DEVELOPMENT_PROFILE_UUID"
echo "Distribution Profile UUID: $DISTRIBUTION_PROFILE_UUID"

# Backup the project file
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup.$(date +%s)

# Configure the Xcode project
echo "Configuring Xcode project..."

# Use Python for precise modifications
python3 << EOF
import re

# Read the project file
with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# 1. Change CODE_SIGN_STYLE from Automatic to Manual
content = re.sub(r'CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;', content)
print("✓ Set CODE_SIGN_STYLE to Manual")

# 2. Set DEVELOPMENT_TEAM
content = re.sub(r'DEVELOPMENT_TEAM = "";', 'DEVELOPMENT_TEAM = "$TEAM_ID";', content)
print("✓ Set DEVELOPMENT_TEAM to $TEAM_ID")

# 3. Remove existing PROVISIONING_PROFILE_SPECIFIER lines
content = re.sub(r'\s*PROVISIONING_PROFILE_SPECIFIER = [^;]*;\n', '', content)
print("✓ Removed existing provisioning profile specifiers")

# 4. Add provisioning profile specifiers
lines = content.split('\n')
result_lines = []

for i, line in enumerate(lines):
    result_lines.append(line)
    
    # Look for DEVELOPMENT_TEAM lines with our team ID
    if 'DEVELOPMENT_TEAM = "$TEAM_ID";' in line:
        # Determine configuration by looking backward
        config_name = None
        for j in range(i-1, max(0, i-50), -1):
            prev_line = lines[j]
            if 'name = Debug;' in prev_line:
                config_name = 'Debug'
                break
            elif 'name = Release;' in prev_line:
                config_name = 'Release'
                break
            elif 'name = Profile;' in prev_line:
                config_name = 'Profile'
                break
        
        # Add appropriate provisioning profile
        indent = '\t\t\t\t'
        if config_name == 'Debug' and '$DEVELOPMENT_PROFILE_UUID':
            result_lines.append(f'{indent}PROVISIONING_PROFILE_SPECIFIER = "$DEVELOPMENT_PROFILE_UUID";')
            print(f"✓ Added development provisioning profile for {config_name}")
        elif config_name in ['Release', 'Profile'] and '$DISTRIBUTION_PROFILE_UUID':
            result_lines.append(f'{indent}PROVISIONING_PROFILE_SPECIFIER = "$DISTRIBUTION_PROFILE_UUID";')
            print(f"✓ Added distribution provisioning profile for {config_name}")

# Write the updated content
with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
    f.write('\n'.join(result_lines))

print("✅ Xcode project configuration completed")
EOF

# Replace variables in the file
sed -i '' "s/\$TEAM_ID/$TEAM_ID/g" Runner.xcodeproj/project.pbxproj
sed -i '' "s/\$DEVELOPMENT_PROFILE_UUID/$DEVELOPMENT_PROFILE_UUID/g" Runner.xcodeproj/project.pbxproj
sed -i '' "s/\$DISTRIBUTION_PROFILE_UUID/$DISTRIBUTION_PROFILE_UUID/g" Runner.xcodeproj/project.pbxproj

echo "✅ Variable substitution completed"

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
echo "Detailed provisioning profile assignments:"
grep -n "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj || echo "No provisioning profiles found"

echo ""
echo "✅ iOS code signing configuration completed!"
