#!/bin/bash

echo "=== GitHub Actions iOS Distribution Fix ==="
echo "This script fixes the certificate/profile mismatch for App Store distribution"

# Navigate to iOS directory if needed
if [ ! -f "Runner.xcodeproj/project.pbxproj" ]; then
    if [ -d "ios" ]; then
        cd ios
    else
        echo "❌ Cannot find iOS project"
        exit 1
    fi
fi

echo ""
echo "=== Checking available certificates ==="
echo "All signing identities:"
security find-identity -v -p codesigning

echo ""
echo "Distribution certificates specifically:"
security find-identity -v -p codesigning | grep -i "distribution"

echo ""
echo "=== Checking available provisioning profiles ==="
PROFILE_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"

if [ -d "$PROFILE_DIR" ]; then
    echo "Provisioning profiles directory exists"
    ls -la "$PROFILE_DIR"
    
    echo ""
    echo "Profile details:"
    for profile in "$PROFILE_DIR"/*.mobileprovision; do
        if [ -f "$profile" ]; then
            echo "=== $(basename "$profile") ==="
            NAME=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract Name raw - 2>/dev/null)
            UUID=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract UUID raw - 2>/dev/null)
            TEAM_ID=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract TeamIdentifier.0 raw - 2>/dev/null)
            APP_ID=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract Entitlements.application-identifier raw - 2>/dev/null)
            
            echo "Name: $NAME"
            echo "UUID: $UUID"
            echo "Team: $TEAM_ID"
            echo "App ID: $APP_ID"
            echo ""
            
            # Use this team ID for configuration
            if [ -n "$TEAM_ID" ] && [ -z "$FOUND_TEAM_ID" ]; then
                FOUND_TEAM_ID="$TEAM_ID"
            fi
        fi
    done
else
    echo "No provisioning profiles directory found"
    echo "This script should be run in GitHub Actions after profiles are downloaded"
    exit 1
fi

if [ -z "$FOUND_TEAM_ID" ]; then
    echo "❌ Could not find team ID from provisioning profiles"
    exit 1
fi

echo "Using Team ID: $FOUND_TEAM_ID"

echo ""
echo "=== Configuring Xcode project for App Store distribution ==="

# Backup the project file
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup

# Use environment variable or fallback to found team ID
TEAM_ID="${IOS_TEAM_ID:-$FOUND_TEAM_ID}"
export TEAM_ID

echo "Final Team ID: $TEAM_ID"

python3 << 'EOF'
import re
import os

def fix_xcode_project_for_appstore():
    team_id = os.environ.get('TEAM_ID', '')
    if not team_id:
        print("❌ No team ID available")
        return False
    
    print(f"Configuring project for team: {team_id}")
    
    with open('Runner.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    result_lines = []
    changes_made = 0
    
    # Track configuration contexts more precisely
    in_runner_config = False
    current_config_type = None
    
    for i, line in enumerate(lines):
        original_line = line
        
        # Detect Runner target configuration sections
        config_match = re.search(r'([A-F0-9]{24}) /\* (Debug|Release|Profile) \*/ = {', line)
        if config_match:
            config_id = config_match.group(1)
            config_type = config_match.group(2)
            
            # Look ahead to confirm this is a Runner (not RunnerTests) configuration
            lookahead_lines = lines[i:min(i+30, len(lines))]
            lookahead_text = '\n'.join(lookahead_lines)
            
            # Check for Runner-specific indicators
            is_runner = (
                'PRODUCT_BUNDLE_IDENTIFIER' in lookahead_text and
                'Runner' in lookahead_text and
                'RunnerTests' not in lookahead_text and
                'ASSETCATALOG_COMPILER_APPICON_NAME' in lookahead_text
            )
            
            if is_runner:
                in_runner_config = True
                current_config_type = config_type
                print(f"✓ Found Runner {config_type} configuration: {config_id}")
            else:
                in_runner_config = False
                current_config_type = None
        
        elif line.strip() == '};' and in_runner_config:
            in_runner_config = False
            current_config_type = None
        
        # Apply fixes only to Runner configurations
        if in_runner_config and current_config_type:
            # Fix 1: Change to manual signing
            if 'CODE_SIGN_STYLE = Automatic;' in line:
                line = line.replace('CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;')
                print(f"✓ Set manual signing for {current_config_type}")
                changes_made += 1
            
            # Fix 2: Set team ID
            elif 'DEVELOPMENT_TEAM = "";' in line:
                line = line.replace('DEVELOPMENT_TEAM = "";', f'DEVELOPMENT_TEAM = "{team_id}";')
                print(f"✓ Set team ID for {current_config_type}")
                changes_made += 1
            
            # Fix 3: Remove old provisioning profile specifiers
            elif 'PROVISIONING_PROFILE_SPECIFIER' in line:
                print(f"Removing old provisioning profile specifier in {current_config_type}")
                continue  # Skip this line to remove it
        
        result_lines.append(line)
        
        # Fix 4: Add correct provisioning profile after setting team ID
        if (in_runner_config and 
            f'DEVELOPMENT_TEAM = "{team_id}";' in line):
            
            if current_config_type == 'Debug':
                # Use development profile for debug builds
                result_lines.append('\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "asim";')
                print("✓ Added development profile for Debug builds")
            else:
                # Use distribution profile for Release/Profile builds
                result_lines.append('\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "asim-prod";')
                print(f"✓ Added distribution profile for {current_config_type} builds")
            changes_made += 1
    
    # Write the modified content back
    with open('Runner.xcodeproj/project.pbxproj', 'w') as f:
        f.write('\n'.join(result_lines))
    
    print(f"✅ Made {changes_made} configuration changes")
    return changes_made > 0

if __name__ == "__main__":
    success = fix_xcode_project_for_appstore()
    if not success:
        exit(1)
EOF

echo ""
echo "=== Verification ==="
echo "Manual signing configurations:"
grep -c "CODE_SIGN_STYLE = Manual;" Runner.xcodeproj/project.pbxproj

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" Runner.xcodeproj/project.pbxproj

echo "Provisioning profile configurations:"
grep "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj

echo ""
echo "✅ GitHub Actions iOS Distribution Fix Complete!"
echo ""
echo "Key changes made:"
echo "1. Set CODE_SIGN_STYLE = Manual for all Runner configurations"
echo "2. Set DEVELOPMENT_TEAM to your team ID"
echo "3. Use 'asim' profile for Debug builds"
echo "4. Use 'asim-prod' profile for Release/Profile builds"
echo ""
echo "For xcodebuild archive command, use:"
echo "  PROVISIONING_PROFILE_SPECIFIER=\"asim-prod\""
echo "  CODE_SIGN_IDENTITY should be auto-detected from the distribution certificate"
