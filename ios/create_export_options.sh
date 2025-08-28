#!/bin/bash

echo "=== Creating ExportOptions.plist for App Store deployment ==="

# Check if TEAM_ID is provided
if [ -z "$TEAM_ID" ]; then
    echo "❌ TEAM_ID environment variable not set"
    exit 1
fi

# Check if PROFILE_UUID is provided
if [ -z "$PROFILE_UUID" ]; then
    echo "❌ PROFILE_UUID environment variable not set"
    exit 1
fi

echo "Using Team ID: $TEAM_ID"
echo "Using Provisioning Profile UUID: $PROFILE_UUID"

# Create ExportOptions.plist for manual signing with explicit provisioning profile
cat > ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>destination</key>
    <string>export</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>teamID</key>
    <string>$TEAM_ID</string>
    <key>signingCertificate</key>
    <string>Apple Distribution</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.asim.asimPlatform</key>
        <string>$PROFILE_UUID</string>
    </dict>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
    <key>manageAppVersionAndBuildNumber</key>
    <false/>
</dict>
</plist>
EOF

echo "✅ ExportOptions.plist created successfully"
echo "Content:"
cat ExportOptions.plist
