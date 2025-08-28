#!/bin/bash

echo "Configuring iOS project for manual code signing..."

# Check if we have IOS_TEAM_ID environment variable set
if [ -n "$IOS_TEAM_ID" ]; then
    echo "Using Team ID from environment variable: $IOS_TEAM_ID"
    TEAM_ID="$IOS_TEAM_ID"
elif [ -n "$GITHUB_ACTIONS" ]; then
    echo "Error: Running in GitHub Actions but IOS_TEAM_ID environment variable not set"
    exit 1
else
    echo "Running in local environment - trying to extract team ID from provisioning profiles"
    
    # Get team identifier from provisioning profiles (local development)
    PROFILE_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"
    
    # List available provisioning profiles
    echo "Available provisioning profiles:"
    ls -la "$PROFILE_DIR/" || echo "Provisioning profiles directory not found"
    
    # Extract team identifier from the production profile
    TEAM_ID=""
    
    for profile in "$PROFILE_DIR"/*.mobileprovision; do
        if [ -f "$profile" ]; then
            profile_name=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract Name raw - 2>/dev/null)
            team_id=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract TeamIdentifier.0 raw - 2>/dev/null)
            
            if [ -n "$profile_name" ]; then
                echo "Found provisioning profile: $profile_name"
                
                if [ "$profile_name" = "asim-prod" ] || [ "$profile_name" = "asim" ]; then
                    TEAM_ID="$team_id"
                    echo "Using Team ID from profile '$profile_name': $TEAM_ID"
                    break
                fi
            fi
        fi
    done
    
    if [ -z "$TEAM_ID" ]; then
        echo "Error: Could not determine team ID from provisioning profiles"
        echo "Make sure you have valid provisioning profiles installed or set IOS_TEAM_ID environment variable"
        exit 1
    fi
fi

echo "Configuring Xcode project with Team ID: $TEAM_ID"

# Find the provisioning profile UUIDs
PROFILE_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"
DEVELOPMENT_PROFILE_UUID=""
DISTRIBUTION_PROFILE_UUID=""

echo "Searching for provisioning profile UUIDs..."

for profile in "$PROFILE_DIR"/*.mobileprovision; do
    if [ -f "$profile" ]; then
        profile_name=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract Name raw - 2>/dev/null)
        profile_uuid=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract UUID raw - 2>/dev/null)
        
        if [ "$profile_name" = "asim" ]; then
            DEVELOPMENT_PROFILE_UUID="$profile_uuid"
            echo "Development profile UUID: $DEVELOPMENT_PROFILE_UUID"
        elif [ "$profile_name" = "asim-prod" ]; then
            DISTRIBUTION_PROFILE_UUID="$profile_uuid"
            echo "Distribution profile UUID: $DISTRIBUTION_PROFILE_UUID"
        fi
    fi
done

# Configure Xcode project for manual signing
echo "Setting up manual code signing..."

# Create a backup
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup

# Use a more robust Python script that handles all configurations
cat > /tmp/fix_provisioning.py << 'EOF'
#!/usr/bin/env python3
import re
import sys
import os

team_id = os.environ.get('TEAM_ID', '')
dev_uuid = os.environ.get('DEVELOPMENT_PROFILE_UUID', '')
dist_uuid = os.environ.get('DISTRIBUTION_PROFILE_UUID', '')

if not team_id:
    print("Error: TEAM_ID not provided")
    sys.exit(1)

with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# 1. Change all CODE_SIGN_STYLE from Automatic to Manual
content = re.sub(r'CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;', content)

# 2. Set DEVELOPMENT_TEAM everywhere it's empty
content = re.sub(r'DEVELOPMENT_TEAM = "";', f'DEVELOPMENT_TEAM = "{team_id}";', content)

# 3. Remove any existing PROVISIONING_PROFILE_SPECIFIER lines
content = re.sub(r'\s*PROVISIONING_PROFILE_SPECIFIER = [^;]*;\n', '', content)

# 4. Add provisioning profile specifiers after DEVELOPMENT_TEAM lines
# We need to be careful to add them in the right build configurations

lines = content.split('\n')
result_lines = []
i = 0

while i < len(lines):
    line = lines[i]
    result_lines.append(line)
    
    # If this line contains DEVELOPMENT_TEAM with our team ID, add provisioning profile
    if f'DEVELOPMENT_TEAM = "{team_id}";' in line:
        # Look backward and forward to determine configuration type
        config_name = None
        
        # Look backward for configuration reference
        for j in range(i-1, max(0, i-30), -1):
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
        
        # Add appropriate provisioning profile UUID
        if config_name == 'Debug' and dev_uuid:
            result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{dev_uuid}";')
        elif config_name in ['Release', 'Profile'] and dist_uuid:
            result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{dist_uuid}";')
        
        print(f"Added provisioning profile for {config_name} configuration")
    
    i += 1

# Write the result
with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
    f.write('\n'.join(result_lines))

print("✅ Xcode project configuration completed")
EOF

# Set environment variables for the Python script
export TEAM_ID="$TEAM_ID"
export DEVELOPMENT_PROFILE_UUID="$DEVELOPMENT_PROFILE_UUID"
export DISTRIBUTION_PROFILE_UUID="$DISTRIBUTION_PROFILE_UUID"

# Run the Python script
python3 /tmp/fix_provisioning.py

# Clean up
rm /tmp/fix_provisioning.py

echo "✅ iOS project configuration completed."

# Verify the configuration
echo "Verifying configuration..."
echo "=== Manual signing entries ==="
grep -n "CODE_SIGN_STYLE.*Manual" Runner.xcodeproj/project.pbxproj || echo "⚠️  Manual signing not found"

echo "=== Development team entries ==="
grep -n "DEVELOPMENT_TEAM.*$TEAM_ID" Runner.xcodeproj/project.pbxproj || echo "⚠️  Team ID not found"

echo "=== Provisioning profile entries ==="
grep -n "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj || echo "⚠️  Provisioning profiles not found"

echo "Configuration verification completed."
