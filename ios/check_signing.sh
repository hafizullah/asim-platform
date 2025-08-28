#!/bin/bash

echo "=== iOS Signing Configuration Check ==="
echo ""

# Check if we're in the right directory
if [ ! -f "Runner.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Not in iOS directory or project.pbxproj not found"
    exit 1
fi

echo "✅ Found Xcode project"
echo ""

# Check available signing identities
echo "=== Available Signing Identities ==="
security find-identity -v -p codesigning | grep -E "(iPhone Developer|iPhone Distribution|Apple Development|Apple Distribution)" || echo "No valid signing identities found"
echo ""

# Check provisioning profiles
echo "=== Available Provisioning Profiles ==="
if [ -d ~/Library/MobileDevice/Provisioning\ Profiles/ ]; then
    PROFILES_FOUND=false
    for profile in ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision; do
        if [ -f "$profile" ]; then
            PROFILES_FOUND=true
            echo "Profile: $(basename "$profile")"
            
            # Extract profile info
            PROFILE_CONTENT=$(security cms -D -i "$profile" 2>/dev/null)
            if [ $? -eq 0 ]; then
                NAME=$(echo "$PROFILE_CONTENT" | plutil -extract Name xml1 -o - - 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<[^>]*>//g')
                APP_ID=$(echo "$PROFILE_CONTENT" | plutil -extract Entitlements.application-identifier xml1 -o - - 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<[^>]*>//g')
                TEAM_ID=$(echo "$PROFILE_CONTENT" | plutil -extract TeamIdentifier.0 xml1 -o - - 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<[^>]*>//g')
                
                echo "  Name: $NAME"
                echo "  App ID: $APP_ID"
                echo "  Team ID: $TEAM_ID"
                
                # Check if it matches our bundle ID
                if [[ "$APP_ID" == *"com.asim.asimPlatform"* ]]; then
                    echo "  ✅ Matches our bundle ID"
                else
                    echo "  ⚠️  Does not match our bundle ID (com.asim.asimPlatform)"
                fi
            else
                echo "  ❌ Failed to read profile content"
            fi
            echo ""
        fi
    done
    
    if [ "$PROFILES_FOUND" = false ]; then
        echo "❌ No provisioning profiles found"
    fi
else
    echo "❌ Provisioning profiles directory not found"
fi

echo ""

# Check current project configuration
echo "=== Current Project Configuration ==="
echo "Bundle Identifier:"
grep -A 1 -B 1 "PRODUCT_BUNDLE_IDENTIFIER" Runner.xcodeproj/project.pbxproj | head -5

echo ""
echo "Code Signing Style:"
grep -A 1 -B 1 "CODE_SIGN_STYLE" Runner.xcodeproj/project.pbxproj | head -10

echo ""
echo "Development Team:"
grep -A 1 -B 1 "DEVELOPMENT_TEAM" Runner.xcodeproj/project.pbxproj | head -5

echo ""
echo "Provisioning Profile Specifier:"
grep -A 1 -B 1 "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj || echo "Not configured"

echo ""
echo "=== ExportOptions.plist ==="
if [ -f "ExportOptions.plist" ]; then
    cat ExportOptions.plist
else
    echo "❌ ExportOptions.plist not found"
fi

echo ""
echo "=== Recommendations ==="
echo "1. Ensure you have a valid Apple Distribution certificate in your keychain"
echo "2. Ensure you have a valid App Store provisioning profile for com.asim.asimPlatform"
echo "3. Set up the following GitHub secrets:"
echo "   - IOS_DIST_SIGNING_KEY (P12 certificate base64 encoded)"
echo "   - IOS_DIST_SIGNING_KEY_PASSWORD"
echo "   - IOS_TEAM_ID"
echo "   - IOS_BUNDLE_ID (should be: com.asim.asimPlatform)"
echo "   - APPSTORE_ISSUER_ID"
echo "   - APPSTORE_API_KEY_ID"
echo "   - APPSTORE_API_PRIVATE_KEY"
