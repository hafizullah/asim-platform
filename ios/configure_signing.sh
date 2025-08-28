#!/bin/bash

# Configure iOS Signing Script
# This script helps you set up your development team ID for local development and CI/CD

echo "🔧 iOS Signing Configuration"
echo "=============================="

# Function to get team ID
get_team_id() {
    echo ""
    echo "📋 How to find your Team ID:"
    echo "1. Go to https://developer.apple.com/account/"
    echo "2. Sign in and click 'Membership'"
    echo "3. Copy the 10-character Team ID (like ABC1234567)"
    echo ""
    echo "Alternatively, run: security find-identity -v -p codesigning"
    echo "and look for your Team ID in the certificate names"
    echo ""
}

# Check if TEAM_ID is provided as argument
if [ "$1" ]; then
    TEAM_ID="$1"
    echo "✅ Using provided Team ID: $TEAM_ID"
else
    # Show help and ask for Team ID
    get_team_id
    read -p "Enter your Apple Developer Team ID: " TEAM_ID
    
    if [ -z "$TEAM_ID" ]; then
        echo "❌ Team ID is required"
        exit 1
    fi
fi

# Validate Team ID format (should be 10 alphanumeric characters)
if [[ ! "$TEAM_ID" =~ ^[A-Z0-9]{10}$ ]]; then
    echo "⚠️  Warning: Team ID should be 10 alphanumeric characters (like ABC1234567)"
    echo "You entered: $TEAM_ID"
    read -p "Continue anyway? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "🔄 Updating Xcode project with Team ID: $TEAM_ID"

# Update the project file
cd "$(dirname "$0")"
PROJECT_PATH="Runner.xcodeproj/project.pbxproj"

# Make a backup
cp "$PROJECT_PATH" "$PROJECT_PATH.backup"

# Ensure automatic signing and set team ID
sed -i '' 's/CODE_SIGN_STYLE = Manual;/CODE_SIGN_STYLE = Automatic;/g' "$PROJECT_PATH"
sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" "$PROJECT_PATH"

# Remove any manual provisioning profile specifiers (they're not needed with automatic signing)
sed -i '' '/PROVISIONING_PROFILE_SPECIFIER/d' "$PROJECT_PATH"

# Verify the changes
UPDATED_COUNT=$(grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" "$PROJECT_PATH")
AUTO_SIGNING_COUNT=$(grep -c "CODE_SIGN_STYLE = Automatic;" "$PROJECT_PATH")

echo ""
if [ "$UPDATED_COUNT" -gt 0 ] && [ "$AUTO_SIGNING_COUNT" -gt 0 ]; then
    echo "✅ Successfully updated $UPDATED_COUNT development team references"
    echo "✅ Confirmed $AUTO_SIGNING_COUNT automatic signing configurations"
    echo "✅ Backup saved as project.pbxproj.backup"
    echo ""
    echo "🎉 iOS signing is now configured for automatic signing!"
    echo "   Team ID: $TEAM_ID"
    echo "   Signing: Automatic (consistent for local and CI/CD)"
    echo ""
    echo "💡 Tips:"
    echo "   • Build locally: flutter build ios"
    echo "   • Open in Xcode: open ios/Runner.xcworkspace"
    echo "   • Your GitHub Actions will use the same automatic signing"
    echo "   • No more provisioning profile management needed!"
else
    echo "❌ Configuration failed"
    echo "   Development team updates: $UPDATED_COUNT"
    echo "   Automatic signing configs: $AUTO_SIGNING_COUNT"
    
    # Restore backup
    mv "$PROJECT_PATH.backup" "$PROJECT_PATH"
    exit 1
fi
