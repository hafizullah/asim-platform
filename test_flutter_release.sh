#!/bin/bash

echo "=== Testing Flutter iOS Release Build ==="
echo "This tests the new simplified Flutter approach"
echo ""

# Check prerequisites
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Please run this script from the project root directory"
    exit 1
fi

echo "1. Setting up environment..."
export TEAM_ID="368HV7DHRL"

echo "2. Configuring iOS signing..."
cd ios
./github_actions_signing_fix.sh

cd ..

echo ""
echo "3. Testing Flutter IPA build (the GitHub Actions approach)..."
echo "Command: flutter build ipa --release"
echo ""

flutter build ipa --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! Flutter IPA build completed"
    echo ""
    echo "Build output:"
    ls -la build/ios/ipa/
    
    IPA_FILE=$(ls build/ios/ipa/*.ipa | head -1)
    if [ -f "$IPA_FILE" ]; then
        echo "IPA file: $IPA_FILE"
        echo "IPA size: $(du -h "$IPA_FILE")"
        echo ""
        echo "🎉 The new Flutter approach works perfectly!"
        echo "This is exactly what GitHub Actions will do"
    else
        echo "❌ IPA file not found"
    fi
else
    echo ""
    echo "❌ Flutter IPA build failed"
    echo "Check the output above for any issues"
fi

echo ""
echo "=== Test completed ==="
