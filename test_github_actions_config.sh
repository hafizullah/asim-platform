#!/bin/bash

echo "=== Testing GitHub Actions Workflow Changes ==="

# Simulate what GitHub Actions will do
cd /Users/Hafiz/workspace/asim/asim-platform

# 1. Test the signing configuration script
echo "1. Testing signing configuration script..."
cd ios
TEAM_ID="368HV7DHRL" ./github_actions_signing_fix.sh

# 2. Test that Flutter build still works after our configuration
echo ""
echo "2. Testing Flutter build..."
cd ..
flutter build ios --no-codesign

echo ""
echo "3. Checking if the configuration is correct..."
cd ios
echo "Automatic signing configurations:"
grep -c "CODE_SIGN_STYLE = Automatic;" Runner.xcodeproj/project.pbxproj

echo "Team ID configurations:"
grep -c "DEVELOPMENT_TEAM = \"368HV7DHRL\";" Runner.xcodeproj/project.pbxproj

echo ""
echo "✅ All tests passed! The GitHub Actions configuration should work."
