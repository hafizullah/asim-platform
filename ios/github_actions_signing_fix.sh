#!/bin/bash

echo "=== Flutter-Compatible iOS Signing Configuration ==="

# This script configures the Xcode project for Flutter + GitHub Actions deployment
# It ensures automatic signing works seamlessly with Flutter's build process

# Check if we're already in the ios directory
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

# GitHub Actions should set TEAM_ID as environment variable
if [ -z "$TEAM_ID" ]; then
    echo "❌ TEAM_ID environment variable not set"
    exit 1
fi

echo "Using Team ID: $TEAM_ID"
echo "Available certificates:"
security find-identity -v -p codesigning

echo ""
echo "Configuring Xcode project for automatic signing with Flutter..."

# Use sed to configure automatic signing directly (simpler and more reliable than Python)
# This approach works perfectly with Flutter's build process

# Set automatic signing for all configurations
sed -i '' 's/CODE_SIGN_STYLE = Manual;/CODE_SIGN_STYLE = Automatic;/g' Runner.xcodeproj/project.pbxproj

# Set the team ID for all configurations
sed -i '' "s/DEVELOPMENT_TEAM = \"[^\"]*\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" Runner.xcodeproj/project.pbxproj
sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" Runner.xcodeproj/project.pbxproj

# Remove any manual provisioning profile specifications (automatic signing will handle this)
sed -i '' '/PROVISIONING_PROFILE_SPECIFIER/d' Runner.xcodeproj/project.pbxproj

echo ""
echo "=== Verification ==="
echo "Automatic signing configurations:"
grep -c "CODE_SIGN_STYLE = Automatic;" Runner.xcodeproj/project.pbxproj || echo "0"

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" Runner.xcodeproj/project.pbxproj || echo "0"

echo "Manual provisioning profiles (should be 0):"
grep -c "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj || echo "0"

echo ""
echo "✅ Flutter-compatible iOS signing configuration completed!"
echo "Project is ready for 'flutter build ipa' with automatic signing"
