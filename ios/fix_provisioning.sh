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

# Configure Xcode project for manual signing
echo "Setting up manual code signing..."

# 1. Change CODE_SIGN_STYLE from Automatic to Manual
sed -i '' 's/CODE_SIGN_STYLE = Automatic;/CODE_SIGN_STYLE = Manual;/g' Runner.xcodeproj/project.pbxproj

# 2. Set DEVELOPMENT_TEAM
sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" Runner.xcodeproj/project.pbxproj

# 3. Remove any existing provisioning profile specifiers
sed -i '' '/PROVISIONING_PROFILE_SPECIFIER/d' Runner.xcodeproj/project.pbxproj

# 4. Add provisioning profile specifiers
# We'll add them after the DEVELOPMENT_TEAM line in each configuration section
# But we need to be very specific about which line to target

# Create a backup
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup

# Use a Python script for precise control
cat > /tmp/fix_provisioning.py << 'EOF'
#!/usr/bin/env python3

with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
    lines = f.readlines()

# Find lines with DEVELOPMENT_TEAM and add provisioning profile after them
# We need to track which configuration we're in
result_lines = []
i = 0

while i < len(lines):
    line = lines[i]
    result_lines.append(line)
    
    # If this line contains DEVELOPMENT_TEAM, we need to add provisioning profile
    if 'DEVELOPMENT_TEAM = ' in line and '""' not in line:  # Only process lines that have the team ID set
        # Look backwards to find which configuration this is
        config_type = None
        for j in range(i-1, max(0, i-20), -1):  # Look back up to 20 lines
            prev_line = lines[j]
            if 'Debug.xcconfig' in prev_line:
                config_type = 'Debug'
                break
            elif 'Release.xcconfig' in prev_line:
                # Need to check if this is Profile or Release
                # Look for the name line after this config
                for k in range(j, min(len(lines), j+20)):
                    name_line = lines[k]
                    if 'name = Profile;' in name_line:
                        config_type = 'Profile'
                        break
                    elif 'name = Release;' in name_line:
                        config_type = 'Release'
                        break
                break
        
        # Add the appropriate provisioning profile
        if config_type == 'Debug':
            result_lines.append('\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "asim";\n')
        elif config_type in ['Release', 'Profile']:
            result_lines.append('\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "asim-prod";\n')
    
    i += 1

# Write the result
with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
    f.writelines(result_lines)

print("Provisioning profiles added successfully")
EOF

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
