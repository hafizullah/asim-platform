#!/bin/bash

echo "=== Testing Local iOS Signing ==="

# Navigate to ios directory if needed
if [ ! -f "Runner.xcodeproj/project.pbxproj" ]; then
    if [ -d "ios" ]; then
        echo "Navigating to ios directory..."
        cd ios
    else
        echo "❌ Cannot find iOS project. Make sure you're running this from the project root or ios directory."
        exit 1
    fi
fi

# Local configuration based on your actual certificates and profiles
LOCAL_TEAM_ID="368HV7DHRL"
LOCAL_PROFILE_UUID="a48e78c9-b174-4d03-b8eb-79e0e5a741a6"

echo "Using Team ID: $LOCAL_TEAM_ID"
echo "Using Provisioning Profile: $LOCAL_PROFILE_UUID"

# Check available certificates
echo ""
echo "Available certificates:"
security find-identity -v -p codesigning

# Backup the project file
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup.$(date +%s)

echo ""
echo "Configuring Xcode project for manual signing..."

# Create Python script to update the Xcode project
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
            
            # Set team ID (handle both empty and existing team IDs)
            if 'DEVELOPMENT_TEAM = ' in line and ('""' in line or '"368HV7DHRL"' not in line):
                line = re.sub(r'DEVELOPMENT_TEAM = "[^"]*";', f'DEVELOPMENT_TEAM = "{LOCAL_TEAM_ID}";', line)
                print(f"✓ Set team ID for {current_config}")
            
            # Add or update provisioning profile specifier
            if 'DEVELOPMENT_TEAM = "368HV7DHRL"' in line:
                # Check if next lines already have PROVISIONING_PROFILE_SPECIFIER
                has_provisioning = False
                for j in range(1, 5):  # Check next few lines
                    if i + j < len(lines) and 'PROVISIONING_PROFILE_SPECIFIER' in lines[i + j]:
                        has_provisioning = True
                        break
                
                if not has_provisioning:
                    # Add provisioning profile after team ID
                    result_lines.append(line)
                    result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{LOCAL_PROFILE_UUID}";')
                    print(f"✓ Added provisioning profile for {current_config}")
                    i += 1
                    continue
            
            # Update existing provisioning profile specifier
            if 'PROVISIONING_PROFILE_SPECIFIER = ' in line:
                line = re.sub(r'PROVISIONING_PROFILE_SPECIFIER = "[^"]*";', f'PROVISIONING_PROFILE_SPECIFIER = "{LOCAL_PROFILE_UUID}";', line)
                print(f"✓ Updated provisioning profile for {current_config}")
        
        result_lines.append(line)
        i += 1
    
    # Write the result back
    with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
        f.write('\n'.join(result_lines))
    
    print("✅ Xcode project configuration updated")

# Set the variables
LOCAL_TEAM_ID = "$LOCAL_TEAM_ID"
LOCAL_PROFILE_UUID = "$LOCAL_PROFILE_UUID"

update_xcode_project()
EOF

echo ""
echo "=== Verification ==="
echo "Manual signing configurations:"
grep -c "CODE_SIGN_STYLE = Manual;" Runner.xcodeproj/project.pbxproj

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"$LOCAL_TEAM_ID\";" Runner.xcodeproj/project.pbxproj

echo "Provisioning profile configurations:"
grep -c "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj

echo ""
echo "Provisioning profile details:"
grep -A1 -B1 "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj

echo ""
echo "✅ Local iOS signing configuration completed!"
echo ""
echo "Now testing the build..."

# Test the build
cd ..
echo "Building with code signing..."
flutter build ios --release

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Local iOS build with signing completed successfully!"
    echo "The configuration works locally."
else
    echo ""
    echo "❌ Build failed. Let's check what went wrong..."
fi
