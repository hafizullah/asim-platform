#!/bin/bash

echo "=== Testing Flutter iOS Build with Code Signing ==="
echo "This tests the new Flutter-based build approach"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Please run this script from the project root directory"
    exit 1
fi

echo "1. Setting up environment..."
export TEAM_ID="368HV7DHRL"

echo "2. Configuring iOS signing..."
cd ios
./github_actions_signing_fix.sh

echo ""
echo "3. Creating ExportOptions.plist..."
./create_export_options.sh

echo ""
echo "4. Checking ExportOptions.plist content..."
cat ExportOptions.plist

cd ..

echo ""
echo "5. Testing Flutter IPA build..."
echo "Command: flutter build ipa --release --export-method app-store --export-options-plist ios/ExportOptions.plist"
echo ""

# For local testing, we'll use development export method since we may not have distribution cert
echo "Using development export method for local test..."
flutter build ipa --release \
  --export-method development \
  --export-options-plist ios/ExportOptions.plist

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! Flutter IPA build completed"
    echo ""
    echo "Build output location:"
    ls -la build/ios/ipa/
    
    if [ -f "build/ios/ipa/Runner.ipa" ]; then
        echo "IPA size: $(du -h build/ios/ipa/Runner.ipa)"
        echo ""
        echo "🎉 The Flutter build approach works!"
        echo "This should work even better in GitHub Actions with the distribution certificate"
    else
        echo "❌ IPA file not found in expected location"
    fi
else
    echo ""
    echo "❌ Flutter IPA build failed"
    echo "Let's try a simpler approach..."
    
    echo ""
    echo "Trying basic iOS build..."
    flutter build ios --release
    
    if [ $? -eq 0 ]; then
        echo "✅ Basic iOS build succeeded"
        echo "The issue might be with export options or certificates"
    else
        echo "❌ Even basic iOS build failed"
    fi
fi

echo ""
echo "=== Test completed ==="
