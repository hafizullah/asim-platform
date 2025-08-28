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

### iOS Secrets (for future iOS deployment):

3. **IOS_BUNDLE_ID**
   - **Value**: Your app's bundle identifier (e.g., `com.yourcompany.asim`)
   - **Purpose**: iOS app identification

4. **IOS_DIST_SIGNING_KEY**
   - **Value**: Base64 encoded .p12 certificate file
   - **How to get**: Export distribution certificate from Xcode
   - **Purpose**: Code signing for App Store

5. **IOS_DIST_SIGNING_KEY_PASSWORD**
   - **Value**: Password for the .p12 file
   - **Purpose**: Unlock the signing certificate

6. **APPSTORE_ISSUER_ID**
   - **Value**: From App Store Connect API settings
   - **Purpose**: App Store Connect authentication

7. **APPSTORE_API_KEY_ID**
   - **Value**: From App Store Connect API settings
   - **Purpose**: App Store Connect API key identification

8. **APPSTORE_API_PRIVATE_KEY**
   - **Value**: Content of the .p8 file from App Store Connect
   - **Purpose**: App Store Connect API authentication

## 🚀 Getting Your Firebase Token

Run this command in your terminal:
```bash
firebase login:ci
```

Copy the token that appears and add it as `FIREBASE_TOKEN` in GitHub Secrets.

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
