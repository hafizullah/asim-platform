#!/bin/bash

echo "=== App Store Distribution Signing Fix ==="

# Navigate to iOS directory if needed
if [ ! -f "Runner.xcodeproj/project.pbxproj" ]; then
    if [ -d "ios" ]; then
        cd ios
    else
        echo "❌ Cannot find iOS project"
        exit 1
    fi
fi

# Fixed UUIDs from your GitHub Actions log
DEV_PROFILE_UUID="de5c7240-7cc2-4453-86f0-8aeb731909db"
DIST_PROFILE_UUID="d1677fe0-db29-4970-937c-d44ec7067064"

# Extract team ID
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

echo ""
echo "=== Checking Available Certificates ==="
echo "All signing identities in keychain:"
security find-identity -v -p codesigning

# Check specifically for distribution certificates
echo ""
echo "Distribution certificates:"
security find-identity -v -p codesigning | grep -i distribution

echo ""
echo "Development certificates:"
security find-identity -v -p codesigning | grep -i development

# The key insight: For App Store distribution, we need to ensure we're using
# the correct certificate type. Let's configure the project properly.

echo ""
echo "=== Configuring Xcode Project for App Store Distribution ==="

# Backup
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup

# Export variables for Python
export TEAM_ID
export DEV_PROFILE_UUID  
export DIST_PROFILE_UUID

python3 << 'EOF'
import re
import os

def update_xcode_project():
    TEAM_ID = os.environ.get('TEAM_ID', '')
    DEV_PROFILE_UUID = os.environ.get('DEV_PROFILE_UUID', '')
    DIST_PROFILE_UUID = os.environ.get('DIST_PROFILE_UUID', '')
    
    with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    result_lines = []
    
    in_runner_debug = False
    in_runner_release = False
    in_runner_profile = False
    current_config_name = ""
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # More precise detection of Runner target configurations
        if re.search(r'[A-F0-9]{24} /\* (Debug|Release|Profile) \*/ = {', line):
            config_match = re.search(r'/\* (Debug|Release|Profile) \*/', line)
            if config_match:
                current_config_name = config_match.group(1)
                # Look ahead to see if this is for the Runner app target
                lookahead = '\n'.join(lines[i:min(i+30, len(lines))])
                is_runner_config = (
                    'PRODUCT_BUNDLE_IDENTIFIER = ' in lookahead and 
                    'Runner' in lookahead and
                    'RunnerTests' not in lookahead
                )
                
                if is_runner_config:
                    in_runner_debug = (current_config_name == 'Debug')
                    in_runner_release = (current_config_name == 'Release')
                    in_runner_profile = (current_config_name == 'Profile')
                    print(f"✓ Found Runner {current_config_name} configuration")
                else:
                    in_runner_debug = in_runner_release = in_runner_profile = False
        
        elif line.strip() == '};' and (in_runner_debug or in_runner_release or in_runner_profile):
            in_runner_debug = in_runner_release = in_runner_profile = False
        
        # Process the line for Runner configurations only
        if in_runner_debug or in_runner_release or in_runner_profile:
            config_type = 'Debug' if in_runner_debug else 'Release' if in_runner_release else 'Profile'
            
            # Set manual signing
            if 'CODE_SIGN_STYLE = Automatic;' in line:
                line = line.replace('CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;')
                print(f"✓ Set manual signing for {config_type}")
            
            # Set team ID
            if 'DEVELOPMENT_TEAM = "";' in line:
                line = line.replace('DEVELOPMENT_TEAM = "";', f'DEVELOPMENT_TEAM = "{TEAM_ID}";')
                print(f"✓ Set team ID for {config_type}")
            
            # Remove any existing provisioning profile specifiers to avoid duplicates
            if 'PROVISIONING_PROFILE_SPECIFIER' in line:
                continue  # Skip this line
        
        result_lines.append(line)
        
        # Add provisioning profile after DEVELOPMENT_TEAM (but only if it's our team ID)
        if (f'DEVELOPMENT_TEAM = "{TEAM_ID}";' in line and 
            (in_runner_debug or in_runner_release or in_runner_profile)):
            
            if in_runner_debug:
                result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{DEV_PROFILE_UUID}";')
                print("✓ Added development provisioning profile for Debug")
            else:  # Release or Profile
                result_lines.append(f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{DIST_PROFILE_UUID}";')
                config_type = "Release" if in_runner_release else "Profile"
                print(f"✓ Added distribution provisioning profile for {config_type}")
        
        i += 1
    
    # Write back
    with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
        f.write('\n'.join(result_lines))
    
    print("✅ Xcode project updated for App Store distribution")

if __name__ == "__main__":
    update_xcode_project()
EOF

echo ""
echo "=== Verification ==="
echo "Manual signing configurations:"
grep -c "CODE_SIGN_STYLE = Manual;" Runner.xcodeproj/project.pbxproj

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" Runner.xcodeproj/project.pbxproj

echo "Provisioning profile configurations:"
grep -c "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj

echo ""
echo "Provisioning profiles in project:"
grep "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj

echo ""
echo "✅ App Store distribution signing configured!"
echo ""
echo "IMPORTANT: For GitHub Actions, use the distribution certificate and profile:"
echo "- Certificate: iOS Distribution (not iOS Development)"
echo "- Profile UUID for Release/Archive: $DIST_PROFILE_UUID"
echo "- Profile Name: asim-prod"
echo ""
echo "The xcodebuild archive command should use:"
echo "  PROVISIONING_PROFILE_SPECIFIER=\"$DIST_PROFILE_UUID\""
echo "  or"
echo "  PROVISIONING_PROFILE_SPECIFIER=\"asim-prod\""
