#!/bin/bash

echo "=== Quick Local GitHub Actions Test ==="
echo "This runs the exact same steps as GitHub Actions (minus secrets)"

cd ios

echo "1. Running signing configuration..."
export TEAM_ID="368HV7DHRL"
./github_actions_signing_fix.sh

echo ""
echo "2. Creating ExportOptions.plist..."
./create_export_options.sh

echo ""
echo "3. Testing flutter build ios (no codesign)..."
cd ..
flutter build ios --release --no-codesign

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! The workflow steps work locally"
    echo "GitHub Actions should now work"
else
    echo ""
    echo "❌ Flutter build failed"
fi
