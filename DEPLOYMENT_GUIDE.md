# Deployment Setup Guide

This guide will help you set up automated deployment for your Flutter app to both iOS App Store and Firebase web hosting using GitHub Actions.

## 🌐 Firebase Web Hosting Setup

### 1. Firebase Project Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Enable Hosting in the console

### 2. Get Firebase Token
```bash
# Install Firebase CLI if you haven't already
npm install -g firebase-tools

# Login to Firebase
firebase login

# Get the deployment token
firebase login:ci
```
Copy the token that's generated - you'll need it for GitHub secrets.

### 3. Test Local Deployment
```bash
# Build your Flutter web app
flutter build web --release

# Deploy to Firebase (test)
firebase deploy --only hosting
```

## 📱 iOS App Store Setup

### 1. Apple Developer Account
- Ensure you have an Apple Developer account ($99/year)
- Create your app in App Store Connect
- Set up your Bundle ID (e.g., `com.yourcompany.asim`)

### 2. App Store Connect API Key
1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to Users and Access → Keys
3. Create a new API Key with App Manager role
4. Download the `.p8` file and note the Key ID and Issuer ID

### 3. iOS Certificates and Provisioning Profiles
1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/certificates/)
2. Create a Distribution Certificate
3. Create an App Store Provisioning Profile for your Bundle ID
4. Export the certificate as `.p12` file with a password

## 🔐 GitHub Secrets Configuration

Add these secrets in your GitHub repository (Settings → Secrets and variables → Actions):

### Firebase Secrets:
- `FIREBASE_TOKEN`: The token from `firebase login:ci`
- `FIREBASE_PROJECT_ID`: Your Firebase project ID
- `FIREBASE_PROJECT_ID_STAGING`: (Optional) Staging project ID

### iOS Secrets:
- `IOS_BUNDLE_ID`: Your app's bundle identifier (e.g., `com.yourcompany.asim`)
- `IOS_DIST_SIGNING_KEY`: Base64 encoded .p12 certificate file
- `IOS_DIST_SIGNING_KEY_PASSWORD`: Password for the .p12 file
- `APPSTORE_ISSUER_ID`: From App Store Connect API
- `APPSTORE_API_KEY_ID`: From App Store Connect API  
- `APPSTORE_API_PRIVATE_KEY`: Content of the .p8 file

### How to encode certificate for GitHub:
```bash
# Convert .p12 to base64
base64 -i YourCertificate.p12 | pbcopy
# Paste the result into IOS_DIST_SIGNING_KEY secret
```

## 📋 Bundle ID Configuration

Update your iOS Bundle ID in the Xcode project:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Update Bundle Identifier in Signing & Capabilities
4. Make sure it matches your App Store Connect app

## 🚀 Deployment Workflows

### Automatic Deployment:
- **Web**: Deploys automatically on every push to `main` branch
- **iOS**: Deploys automatically when you create a new tag (e.g., `v1.0.0`)

### Manual Deployment:
- Go to GitHub Actions tab
- Select "Manual Deploy" workflow
- Choose what to deploy (web/ios/both) and environment

### Creating a Release:
```bash
# Create and push a tag for iOS deployment
git tag v1.0.0
git push origin v1.0.0
```

## 💰 Cost Breakdown

### Firebase Hosting:
- **Free Tier**: 10 GB storage, 360 MB/day transfer
- **Paid**: $0.026/GB storage, $0.15/GB transfer
- **Estimated monthly cost**: $0-5 for most apps

### iOS App Store:
- **Apple Developer**: $99/year
- **No additional deployment costs**

### GitHub Actions:
- **Free**: 2,000 minutes/month for public repos
- **Private repos**: 2,000 minutes/month (free tier)

**Total estimated monthly cost: $0-10** (very cost-effective!)

## 🛠️ Pre-deployment Checklist

### Web Deployment:
- [ ] Flutter web build works locally
- [ ] Firebase project configured
- [ ] Firebase token added to GitHub secrets
- [ ] Test deployment works

### iOS Deployment:
- [ ] iOS app builds and runs on device
- [ ] Apple Developer account active
- [ ] App created in App Store Connect
- [ ] Certificates and provisioning profiles set up
- [ ] All iOS secrets added to GitHub
- [ ] Bundle ID matches across all platforms

## 🔍 Troubleshooting

### Common Issues:

1. **Firebase deployment fails**:
   - Check if Firebase token is valid: `firebase login:ci`
   - Verify project ID is correct

2. **iOS build fails**:
   - Ensure certificates are not expired
   - Check Bundle ID matches everywhere
   - Verify provisioning profile includes your device

3. **Code signing issues**:
   - Make sure distribution certificate is valid
   - Check provisioning profile includes your Bundle ID
   - Verify the .p12 file password is correct

### Testing Locally:
```bash
# Test Flutter web build
flutter build web --release

# Test iOS build (on macOS)
flutter build ios --release
```

## 📱 Next Steps After Setup

1. **Test the workflows** with a simple change
2. **Set up staging environment** for testing
3. **Configure app icons and metadata** in App Store Connect
4. **Set up crash reporting** (Firebase Crashlytics)
5. **Add analytics** (Firebase Analytics)

## 🔗 Useful Links

- [Firebase Hosting Documentation](https://firebase.google.com/docs/hosting)
- [Apple Developer Portal](https://developer.apple.com/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment)
