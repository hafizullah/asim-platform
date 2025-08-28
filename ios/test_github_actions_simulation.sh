#!/bin/bash

echo "=== Testing GitHub Actions iOS Signing Configuration ==="
echo "This script simulates what GitHub Actions will do and tests if it works"
echo ""

# Check if we're in the right directory
if [ ! -f "Runner.xcodeproj/project.pbxproj" ]; then
    echo "❌ Please run this script from the ios directory"
    exit 1
fi

# Check prerequisites
echo "1. Checking prerequisites..."

# Check if we have a distribution certificate
echo "   Checking for Apple Distribution certificate..."
if security find-identity -v -p codesigning | grep -q "Apple Distribution"; then
    echo "   ✅ Apple Distribution certificate found"
    DIST_CERT=$(security find-identity -v -p codesigning | grep "Apple Distribution" | head -1 | cut -d'"' -f2)
    echo "   Certificate: $DIST_CERT"
else
    echo "   ❌ Apple Distribution certificate not found"
    echo "   Note: GitHub Actions will install this from secrets"
fi

# Check if signing script exists
if [ -f "github_actions_signing_fix.sh" ]; then
    if [ -x "github_actions_signing_fix.sh" ]; then
        echo "   ✅ GitHub Actions signing script exists and is executable"
    else
        echo "   ⚠️  Making signing script executable..."
        chmod +x github_actions_signing_fix.sh
    fi
else
    echo "   ❌ github_actions_signing_fix.sh not found"
    exit 1
fi

# Backup the project file
echo ""
echo "2. Creating backup of project file..."
cp Runner.xcodeproj/project.pbxproj Runner.xcodeproj/project.pbxproj.backup.test.$(date +%s)
echo "   ✅ Backup created"

# Simulate GitHub Actions environment
echo ""
echo "3. Simulating GitHub Actions environment..."
export TEAM_ID="368HV7DHRL"  # Your actual team ID
echo "   Set TEAM_ID=$TEAM_ID"

# Run the GitHub Actions signing fix script
echo ""
echo "4. Running GitHub Actions signing configuration script..."
./github_actions_signing_fix.sh

if [ $? -eq 0 ]; then
    echo "   ✅ Signing script completed successfully"
else
    echo "   ❌ Signing script failed"
    exit 1
fi

# Verify the configuration
echo ""
echo "5. Verifying automatic signing configuration..."

# Check CODE_SIGN_STYLE
AUTO_COUNT=$(grep -c "CODE_SIGN_STYLE = Automatic;" Runner.xcodeproj/project.pbxproj)
if [ $AUTO_COUNT -gt 0 ]; then
    echo "   ✅ Automatic signing enabled ($AUTO_COUNT configurations)"
else
    echo "   ❌ Automatic signing not found"
fi

# Check DEVELOPMENT_TEAM
TEAM_COUNT=$(grep -c "DEVELOPMENT_TEAM = \"$TEAM_ID\";" Runner.xcodeproj/project.pbxproj)
if [ $TEAM_COUNT -gt 0 ]; then
    echo "   ✅ Development team set correctly ($TEAM_COUNT configurations)"
else
    echo "   ❌ Development team not set correctly"
    echo "   Current team settings:"
    grep "DEVELOPMENT_TEAM" Runner.xcodeproj/project.pbxproj
fi

# Check for manual provisioning (should be removed for automatic signing)
MANUAL_PROV_COUNT=$(grep -c "PROVISIONING_PROFILE_SPECIFIER" Runner.xcodeproj/project.pbxproj)
if [ $MANUAL_PROV_COUNT -eq 0 ]; then
    echo "   ✅ No manual provisioning profiles (good for automatic signing)"
else
    echo "   ⚠️  Manual provisioning profiles found ($MANUAL_PROV_COUNT) - these should be removed for automatic signing"
fi

# Check CODE_SIGN_IDENTITY settings
echo ""
echo "6. Checking code signing identity settings..."
grep "CODE_SIGN_IDENTITY" Runner.xcodeproj/project.pbxproj | while read line; do
    echo "   $line"
done

if grep -q '"Apple Distribution"' Runner.xcodeproj/project.pbxproj; then
    echo "   ❌ Found hardcoded 'Apple Distribution' - this conflicts with automatic signing"
else
    echo "   ✅ No hardcoded 'Apple Distribution' found"
fi

# Test workspace validation
echo ""
echo "7. Testing Xcode workspace validation..."
if xcodebuild -list -workspace Runner.xcworkspace > /dev/null 2>&1; then
    echo "   ✅ Xcode workspace is valid"
else
    echo "   ❌ Xcode workspace validation failed"
    xcodebuild -list -workspace Runner.xcworkspace
fi

# Simulate the actual build command that GitHub Actions will use
echo ""
echo "8. Testing the actual GitHub Actions build command..."
echo "   Command: xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -destination generic/platform=iOS -archivePath Runner.xcarchive archive -allowProvisioningUpdates DEVELOPMENT_TEAM=\"$TEAM_ID\" ONLY_ACTIVE_ARCH=NO"

# Create a test script to run the build without actually executing it
echo "#!/bin/bash" > test_build_command.sh
echo "set -e" >> test_build_command.sh
echo "xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -destination generic/platform=iOS -archivePath Runner.xcarchive archive -allowProvisioningUpdates DEVELOPMENT_TEAM=\"$TEAM_ID\" ONLY_ACTIVE_ARCH=NO -dry-run" >> test_build_command.sh
chmod +x test_build_command.sh

echo "   Running dry-run test..."
if ./test_build_command.sh > build_test.log 2>&1; then
    echo "   ✅ Build command validation passed"
else
    echo "   ❌ Build command validation failed"
    echo "   Last 20 lines of build log:"
    tail -20 build_test.log
fi

# Clean up test files
rm -f test_build_command.sh build_test.log

# Restore the backup
echo ""
echo "9. Restoring original project configuration..."
BACKUP_FILE=$(ls -t Runner.xcodeproj/project.pbxproj.backup.test.* | head -1)
if [ -f "$BACKUP_FILE" ]; then
    cp "$BACKUP_FILE" Runner.xcodeproj/project.pbxproj
    echo "   ✅ Original configuration restored"
    rm "$BACKUP_FILE"
else
    echo "   ⚠️  Could not find backup file"
fi

echo ""
echo "=== Test Summary ==="
echo "This test simulated the GitHub Actions workflow configuration."
echo ""
echo "Key points for successful GitHub Actions build:"
echo "✓ Automatic signing should be enabled"
echo "✓ Development team should be set via environment variable"
echo "✓ No manual code signing identity should be hardcoded"
echo "✓ No manual provisioning profiles for automatic signing"
echo "✓ Xcode workspace should be valid"
echo ""
echo "If all checks passed above, your GitHub Actions workflow should work!"
echo ""
echo "To run the actual GitHub Actions:"
echo "1. Push your changes to the repository"
echo "2. Go to GitHub Actions tab"
echo "3. Run the 'Manual Deploy' workflow with 'ios' target"
