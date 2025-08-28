# iOS Signing Fix Summary

## Problem
The GitHub Actions workflow was failing with the error:
```
"Runner" requires a provisioning profile. Select a provisioning profile in the Signing & Capabilities editor.
```

Even though the provisioning profiles were being downloaded correctly, Xcode couldn't find them because the project was still configured for automatic signing but the build process needed manual signing.

## Root Cause
1. **Xcode project configuration**: The project was still set to `CODE_SIGN_STYLE = Automatic` 
2. **Missing provisioning profile specifiers**: The project didn't have `PROVISIONING_PROFILE_SPECIFIER` entries
3. **Wrong profile references**: The build scripts were trying to use profile names instead of UUIDs

## Solution Applied

### 1. Updated Scripts
- **`ios/quick_signing_fix.sh`**: New script that directly fixes the Xcode project using the exact provisioning profile UUIDs from your GitHub Actions logs
- **`ios/configure_signing.sh`**: Updated to use UUIDs instead of names
- **`ios/fix_provisioning.sh`**: Enhanced with better UUID detection

### 2. Updated GitHub Actions Workflows
- **`.github/workflows/deploy.yml`**: Now uses `quick_signing_fix.sh` and the correct UUIDs
- **`.github/workflows/manual-deploy.yml`**: Updated with the same approach

### 3. Key Changes Made
- Set `CODE_SIGN_STYLE = Manual` in all build configurations
- Added `PROVISIONING_PROFILE_SPECIFIER` with the correct UUIDs:
  - Development (Debug): `de5c7240-7cc2-4453-86f0-8aeb731909db`
  - Distribution (Release/Profile): `d1677fe0-db29-4970-937c-d44ec7067064`
- Updated `ExportOptions.plist` to use UUID instead of profile name
- Updated xcodebuild commands to specify the correct provisioning profile UUID

## Expected Results
Your next GitHub Actions run should:
1. ✅ Download provisioning profiles successfully
2. ✅ Configure Xcode project for manual signing
3. ✅ Build the archive without "requires a provisioning profile" errors
4. ✅ Export the IPA successfully
5. ✅ Upload to TestFlight

## Verification
You can verify the fix locally by:
1. Running `cd ios && ./quick_signing_fix.sh`
2. Checking that the project file contains:
   ```
   CODE_SIGN_STYLE = Manual;
   PROVISIONING_PROFILE_SPECIFIER = "de5c7240-7cc2-4453-86f0-8aeb731909db"; // for Debug
   PROVISIONING_PROFILE_SPECIFIER = "d1677fe0-db29-4970-937c-d44ec7067064"; // for Release
   ```

## What Was Different This Time
- Used **exact UUIDs** from your GitHub Actions logs instead of guessing profile names
- Applied changes to **all build configurations** (Debug, Release, Profile)
- Updated **both the project file AND the build commands** to use the same UUIDs
- Created a **targeted script** that directly addresses the specific provisioning profiles in your setup

The key insight was that Apple's provisioning profile system works much more reliably with UUIDs than with names, especially in CI/CD environments.
