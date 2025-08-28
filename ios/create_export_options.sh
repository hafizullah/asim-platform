#!/bin/bash

echo "=== Creating ExportOptions.plist for App Store deployment ==="

# Check if TEAM_ID is provided
if [ -z "$TEAM_ID" ]; then
    echo "❌ TEAM_ID environment variable not set"
    exit 1
fi

echo "Using Team ID: $TEAM_ID"

# Create ExportOptions.plist for automatic signing
cat > ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>destination</key>
    <string>upload</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
    <key>teamID</key>
    <string>$TEAM_ID</string>
</dict>
</plist>
EOF

echo "✅ ExportOptions.plist created successfully"
echo "Content:"
cat ExportOptions.plist
