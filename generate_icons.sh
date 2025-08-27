#!/bin/bash

# ASIM Platform Icon Management Script
# This script provides utilities for icon management

echo "🎨 ASIM Platform Icon Management"
echo "================================"

# Check if magick (ImageMagick) is available
if ! command -v magick &> /dev/null; then
    echo "❌ ImageMagick is required but not installed."
    echo "Install it with: brew install imagemagick"
    exit 1
fi

echo "✅ ImageMagick found"

# Function to regenerate web icons manually if needed
regenerate_web_icons() {
    echo "🌐 Regenerating web icons..."
    
    BASE_SVG="assets/images/app_icon_fixed.svg"
    
    # Web App Manifest Icons
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 192x192 "web/android-chrome-192x192.png"
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 512x512 "web/android-chrome-512x512.png"
    
    # Apple Touch Icons for Web
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 180x180 "web/apple-touch-icon.png"
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 152x152 "web/apple-touch-icon-152x152.png"
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 144x144 "web/apple-touch-icon-144x144.png"
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 120x120 "web/apple-touch-icon-120x120.png"
    
    # Favicons
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 32x32 "web/favicon-32x32.png"
    magick -background transparent -colorspace sRGB "$BASE_SVG" -resize 16x16 "web/favicon-16x16.png"
    magick "web/favicon-32x32.png" "web/favicon-16x16.png" "web/favicon.ico"
    
    echo "✅ Web icons regenerated"
}

# Function to regenerate Flutter icons
regenerate_flutter_icons() {
    echo "📱 Regenerating Flutter launcher icons..."
    flutter pub get
    flutter pub run flutter_launcher_icons:main
    echo "✅ Flutter icons regenerated"
}

# Function to verify icon colors
verify_icon_colors() {
    echo "🔍 Verifying icon colors..."
    
    # Check key files for proper color depth
    echo "Main app icon:"
    file assets/images/app_icon.png | grep -E "(color|RGB|RGBA)" || echo "⚠️  May be grayscale"
    
    echo "iOS App Store icon:"
    file ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png | grep -E "(color|RGB|RGBA)" || echo "⚠️  May be grayscale"
    
    echo "Web PWA icon:"
    file web/android-chrome-512x512.png | grep -E "(color|RGB|RGBA)" || echo "⚠️  May be grayscale"
    
    echo "Apple touch icon:"
    file web/apple-touch-icon.png | grep -E "(color|RGB|RGBA)" || echo "⚠️  May be grayscale"
}

# Main menu
case "${1:-menu}" in
    "web")
        regenerate_web_icons
        ;;
    "flutter")
        regenerate_flutter_icons
        ;;
    "verify")
        verify_icon_colors
        ;;
    "all")
        echo "🚀 Regenerating all icons..."
        regenerate_web_icons
        regenerate_flutter_icons
        verify_icon_colors
        ;;
    *)
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  web      - Regenerate web icons only"
        echo "  flutter  - Regenerate Flutter launcher icons"
        echo "  verify   - Verify icon colors are correct"
        echo "  all      - Regenerate all icons and verify"
        echo ""
        echo "🎨 Design Details:"
        echo "   • Colors: Afghan flag green (#228B22-#32CD32) and red (#CC0000-#FF3333)"
        echo "   • Theme: Mobile signal bars with SIM card element"
        echo "   • Style: Modern gradient with professional appearance"
        echo ""
        echo "📁 Current icon status:"
        verify_icon_colors
        ;;
esac
