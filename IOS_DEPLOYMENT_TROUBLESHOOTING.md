# 🛠️ iOS Deployment Troubleshooting Guide

## Common iOS Deployment Issues and Solutions

### 1. "Signing for Runner requires a development team"

**Problem**: No development team configured in Xcode project.

**Solution**: 
1. Ensure `IOS_TEAM_ID` secret is set in GitHub with your Apple Developer Team ID
2. The workflow will automatically configure the development team

**How to get Team ID**: See [GITHUB_SECRETS_SETUP.md](./GITHUB_SECRETS_SETUP.md)

### 2. "Runner requires a provisioning profile"

**Problem**: No provisioning profile configured for manual signing.

**Causes & Solutions**:

#### A. Missing Provisioning Profile
- **Check**: Ensure you have created an App Store Distribution provisioning profile in Apple Developer Portal
- **Fix**: Create a new provisioning profile for `com.asim.asimPlatform` with App Store distribution

#### B. Wrong Bundle ID
- **Check**: Verify the bundle ID in the provisioning profile matches `com.asim.asimPlatform`
- **Fix**: Update the provisioning profile or app configuration

#### C. Expired Provisioning Profile
- **Check**: Provisioning profiles expire after 1 year
- **Fix**: Renew the provisioning profile in Apple Developer Portal

#### D. Missing Distribution Certificate
- **Check**: Ensure you have a valid iOS Distribution certificate
- **Fix**: Create a new distribution certificate if needed

### 3. "No profiles for 'com.asim.asimPlatform' were found"

**Problem**: The App Store Connect API can't find matching provisioning profiles.

**Solutions**:
1. **Verify Bundle ID**: Ensure the bundle ID exactly matches
2. **Check App Store Connect**: Verify the app exists in App Store Connect
3. **Recreate Provisioning Profile**: Delete and recreate the provisioning profile
4. **Wait for Sync**: Sometimes it takes a few minutes for profiles to sync

### 4. Certificate Issues

**Problem**: Code signing certificate issues.

**Common Fixes**:
1. **Export Certificate**: Export as .p12 from Keychain Access
2. **Check Password**: Ensure the .p12 password is correct in secrets
3. **Certificate Type**: Use "iOS Distribution" certificate, not "iOS Development"
4. **Base64 Encoding**: Ensure the certificate is properly base64 encoded

### 5. Required GitHub Secrets

Ensure all these secrets are configured:

- ✅ `IOS_TEAM_ID` - Your Apple Developer Team ID
- ✅ `IOS_BUNDLE_ID` - `com.asim.asimPlatform`
- ✅ `IOS_DIST_SIGNING_KEY` - Base64 encoded .p12 certificate
- ✅ `IOS_DIST_SIGNING_KEY_PASSWORD` - Password for .p12 file
- ✅ `APPSTORE_ISSUER_ID` - From App Store Connect API
- ✅ `APPSTORE_API_KEY_ID` - From App Store Connect API
- ✅ `APPSTORE_API_PRIVATE_KEY` - Content of .p8 file

### 6. Manual Testing Steps

To test iOS deployment locally:

```bash
# 1. Navigate to iOS directory
cd ios

# 2. Install dependencies
pod install

# 3. Build Flutter app
cd ..
flutter build ios --release --no-codesign

# 4. Archive with Xcode (replace with your team ID)
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath Runner.xcarchive \
  archive \
  DEVELOPMENT_TEAM=YOUR_TEAM_ID \
  CODE_SIGN_STYLE=Manual
```

### 7. Debug Steps in CI

The workflow includes debugging steps that will show:
- Available provisioning profiles
- Profile names and details
- Configuration changes made to Xcode project

Check the GitHub Actions logs for this debug information.

### 8. Common Xcode Project Issues

**Problem**: Xcode project configuration is incorrect.

**Solutions**:
1. **Clean Build**: Delete derived data and rebuild
2. **Reset Signing**: Switch to Automatic signing, then back to Manual
3. **Verify Settings**: Check that provisioning profile specifier matches the actual profile name

### 9. App Store Connect Setup

Ensure your app is properly configured:

1. **App Record**: App must exist in App Store Connect
2. **Bundle ID**: Must match exactly: `com.asim.asimPlatform`
3. **Certificates**: Valid iOS Distribution certificate
4. **Provisioning Profile**: App Store distribution profile for the bundle ID

### 10. Testing the Fix

After setting up all secrets:

1. **Create a Tag**: Push a tag starting with 'v' (e.g., `v1.0.0`)
2. **Monitor Workflow**: Check GitHub Actions for detailed logs
3. **Check TestFlight**: App should appear in TestFlight if successful

### 11. Additional Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [Xcode Build Settings](https://help.apple.com/xcode/mac/current/#/itcaec37c2a6)
