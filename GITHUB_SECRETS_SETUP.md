# 🔐 GitHub Secrets Setup Guide

## ⚠️ Important Security Note
Never commit Firebase tokens or other secrets directly to your repository. Always use GitHub Secrets for sensitive information.

## 🔑 Required GitHub Secrets

To set up automatic deployment, add these secrets in your GitHub repository:
**Settings → Secrets and variables → Actions → New repository secret**

### Firebase Secrets:

1. **FIREBASE_TOKEN**
   - **How to get**: Run `firebase login:ci` in your terminal
   - **Value**: Copy the generated token (starts with `1//`)
   - **Purpose**: Allows GitHub Actions to deploy to Firebase

2. **FIREBASE_PROJECT_ID**
   - **Value**: `asim-24e42`
   - **Purpose**: Identifies your Firebase project

### iOS Secrets (for automatic signing):

3. **IOS_BUNDLE_ID**
   - **Value**: `com.asim.asimPlatform`
   - **Purpose**: iOS app identification

4. **IOS_TEAM_ID**
   - **Value**: Your Apple Developer Team ID (10 character string)
   - **How to get**: 
     - **Method 1 (Web)**: Go to [Apple Developer Account](https://developer.apple.com/account/) → Sign in → Click "Membership" in sidebar → Your Team ID is displayed
     - **Method 2 (Xcode)**: Open Xcode → Preferences → Accounts → Select your Apple ID → Click team name → Team ID shown in details
     - **Method 3 (Terminal)**: Run `security find-identity -v -p codesigning` and look for "Apple Development" or "Apple Distribution" certificates
   - **Purpose**: Required for automatic code signing in CI/CD

5. **IOS_DIST_SIGNING_KEY**
   - **Value**: Base64 encoded .p12 certificate file
   - **How to get**: Export distribution certificate from Xcode/Keychain
   - **Purpose**: Code signing certificate for App Store

6. **IOS_DIST_SIGNING_KEY_PASSWORD**
   - **Value**: Password for the .p12 file
   - **Purpose**: Unlock the signing certificate

7. **APPSTORE_ISSUER_ID**
   - **Value**: From App Store Connect API settings
   - **Purpose**: App Store Connect authentication

8. **APPSTORE_API_KEY_ID**
   - **Value**: From App Store Connect API settings
   - **Purpose**: App Store Connect API key identification

9. **APPSTORE_API_PRIVATE_KEY**
   - **Value**: Content of the .p8 file from App Store Connect
   - **Purpose**: App Store Connect API authentication

## 🎯 Why Automatic Signing?

This project uses **automatic signing** for both local development and CI/CD because:

✅ **Consistency**: Same signing method locally and in GitHub Actions  
✅ **Simplicity**: No manual provisioning profile management  
✅ **Reliability**: Xcode manages certificates and profiles automatically  
✅ **Modern**: Apple's recommended approach  

**No more manual provisioning profiles needed!** 🎉

## 🚀 Getting Your Firebase Token

Run this command in your terminal:
```bash
firebase login:ci
```

Copy the token that appears and add it as `FIREBASE_TOKEN` in GitHub Secrets.

## 🛠️ Setting Up Local iOS Development

To configure your local development environment:

1. **Find your Team ID** (see methods above)

2. **Run the configuration script**:
   ```bash
   cd ios
   ./configure_signing.sh YOUR_TEAM_ID
   ```

   Or run it interactively (it will prompt for your Team ID):
   ```bash
   cd ios
   ./configure_signing.sh
   ```

3. **Done!** Now both your local development and GitHub Actions use automatic signing consistently.

## 🚀 Getting Your Firebase Token

Run this command in your terminal:
```bash
firebase login:ci
```

Copy the token that appears and add it as `FIREBASE_TOKEN` in GitHub Secrets.

## 🍎 Getting Your Apple Developer Team ID

Your Team ID is a 10-character alphanumeric string (like `ABC1234567`) that identifies your Apple Developer account.

### Method 1: Apple Developer Website (Recommended)
1. Go to [developer.apple.com/account](https://developer.apple.com/account/)
2. Sign in with your Apple ID
3. Click **"Membership"** in the left sidebar
4. Your **Team ID** is displayed prominently on the page
5. Copy this 10-character string

### Method 2: Xcode
1. Open Xcode
2. Go to **Xcode** → **Preferences** (or **Settings** in newer versions)
3. Click the **Accounts** tab
4. Select your Apple ID account
5. Click on your team name in the right panel
6. Your Team ID will be shown in the details

### Method 3: Terminal (For existing certificates)
```bash
security find-identity -v -p codesigning
```
Look for entries like:
```
1) ABC1234567 "Apple Development: your.email@example.com (Team ID: ABC1234567)"
```
The Team ID is the part in parentheses.

### Method 4: Keychain Access
1. Open **Keychain Access** app
2. Search for "Apple Development" or "Apple Distribution"
3. Double-click on a certificate
4. The Team ID is shown in the certificate details

## ✅ Verification

Once you add the Firebase secrets:
1. Push any change to the `main` branch
2. Check GitHub Actions tab
3. Watch your app auto-deploy to https://asim-24e42.web.app

## 🛡️ Security Best Practices

- ✅ Use GitHub Secrets for all sensitive data
- ✅ Never commit tokens/keys to the repository
- ✅ Rotate tokens periodically
- ✅ Use minimum required permissions
- ❌ Never share tokens in documentation
- ❌ Never commit `.env` files with secrets
