#!/bin/bash

echo "=== Simple Flutter IPA Build Test ==="
echo ""

# Test the core Flutter iOS build capability first
echo "1. Testing basic Flutter iOS build..."
flutter build ios --release --no-codesign

if [ $? -ne 0 ]; then
    echo "❌ Basic Flutter iOS build failed"
    exit 1
fi

echo "✅ Basic Flutter iOS build successful"

echo ""
echo "2. Setting up iOS signing configuration..."
cd ios
export TEAM_ID="368HV7DHRL"
./github_actions_signing_fix.sh
./create_export_options.sh

echo ""
echo "3. Testing Flutter build ipa command..."
cd ..

# Try with development first (more likely to work locally)
echo "Attempting Flutter IPA build with development signing..."
flutter build ipa --release --export-method development 2>&1 | tee flutter_ipa_build.log

if [ $? -eq 0 ]; then
    echo "✅ Flutter IPA build succeeded!"
    echo "Output:"
    ls -la build/ios/ipa/ 2>/dev/null || echo "No ipa directory found"
else
    echo "⚠️  Development build failed, checking what went wrong..."
    echo "Last 20 lines of build log:"
    tail -20 flutter_ipa_build.log
    
    echo ""
    echo "Let's see what Flutter build ipa expects..."
    flutter build ipa --help
fi

echo ""
echo "=== Summary ==="
echo "✅ Basic iOS build: Working"
echo "🧪 IPA build: See results above"
