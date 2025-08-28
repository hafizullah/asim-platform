#!/bin/bash

echo "=== Testing GitHub Actions Build Command with -allowProvisioningUpdates ==="

cd /Users/Hafiz/workspace/asim/asim-platform/ios

# First configure the project
echo "1. Configuring project..."
TEAM_ID="368HV7DHRL" ./github_actions_signing_fix.sh

echo ""
echo "2. Testing xcodebuild archive command..."

# This simulates the exact command GitHub Actions will run
xcodebuild \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath Runner.xcarchive \
  archive \
  -allowProvisioningUpdates \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM="368HV7DHRL"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! The archive command worked!"
    echo "Archive created at: $(pwd)/Runner.xcarchive"
    ls -la Runner.xcarchive/
else
    echo ""
    echo "❌ Archive command failed"
fi
