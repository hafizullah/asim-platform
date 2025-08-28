#!/bin/bash

# configure_signing.sh
# Script to configure iOS code signing for CI/CD

set -e

TEAM_ID="$1"
PROJECT_PATH="Runner.xcodeproj/project.pbxproj"

if [ -z "$TEAM_ID" ]; then
    echo "Error: Team ID is required"
    echo "Usage: $0 <TEAM_ID>"
    exit 1
fi

echo "Configuring iOS project for CI with Team ID: $TEAM_ID"

# Backup the original project file
cp "$PROJECT_PATH" "$PROJECT_PATH.backup"

# Replace CODE_SIGN_STYLE from Automatic to Manual
sed -i '' 's/CODE_SIGN_STYLE = Automatic;/CODE_SIGN_STYLE = Manual;/g' "$PROJECT_PATH"

# Set the development team for all configurations
sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" "$PROJECT_PATH"

# Add PROVISIONING_PROFILE_SPECIFIER if not present
if ! grep -q "PROVISIONING_PROFILE_SPECIFIER" "$PROJECT_PATH"; then
    # Find the line with DEVELOPMENT_TEAM and add PROVISIONING_PROFILE_SPECIFIER after it
    sed -i '' "/DEVELOPMENT_TEAM = \"$TEAM_ID\";/a\\
				PROVISIONING_PROFILE_SPECIFIER = \"ASIM Platform Distribution\";
" "$PROJECT_PATH"
fi

echo "iOS project configuration completed successfully"
echo "Set CODE_SIGN_STYLE to Manual"
echo "Set DEVELOPMENT_TEAM to $TEAM_ID"
echo "Set PROVISIONING_PROFILE_SPECIFIER to ASIM Platform Distribution"
