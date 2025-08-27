# ASIM Platform - Logo & Brand Guidelines

## 🎨 Brand Overview

The ASIM Platform logo represents mobile connectivity and eSIM technology through a professional design that incorporates elements from the Afghan flag while maintaining modern aesthetics.

## 📱 Logo Concept

### Main Elements:
- **Signal Bars**: Four ascending bars representing mobile signal strength and connectivity
- **Signal Waves**: Curved lines indicating wireless transmission and communication
- **SIM Element**: Central element representing eSIM/SIM card technology
- **Color Scheme**: Afghan flag colors (green and red) with professional gradient treatment

### Symbolism:
- **Green Gradient**: Represents growth, prosperity, and the green stripe of the Afghan flag
- **Red Accent**: Represents strength and the red stripe of the Afghan flag  
- **Signal Theme**: Mobile connectivity, international reach, and technological advancement
- **Modern Design**: Professional appearance suitable for enterprise and consumer markets

## 🎯 Available Assets

### Logo Variants:
1. **`logo.svg`** - Full logo with company name and tagline (400x120px)
2. **`app_icon.svg`** - Icon-only version for app icons (1024x1024px)
3. **`brand_logo.svg`** - Horizontal brand logo for headers and branding

### Generated Icons:
- **iOS**: Complete icon set for all iOS devices and App Store
- **Android**: Adaptive icons and notification icons
- **Web**: PWA icons, favicons, and touch icons
- **Desktop**: Windows and macOS application icons

## 🌈 Color Palette

### Primary Colors (Afghan Flag Green):
- `#006633` - Dark Green (Primary)
- `#228B22` - Medium Green
- `#32CD32` - Light Green (Accent)

### Secondary Colors (Afghan Flag Red):
- `#CC0000` - Dark Red (Primary)
- `#FF3333` - Light Red (Accent)

### Neutral Colors:
- `#FFFFFF` - White (Background)
- `#F5F5F5` - Light Gray (Secondary Background)
- `#1A1A1A` - Dark Gray (Text)
- `#666666` - Medium Gray (Secondary Text)

## 📐 Usage Guidelines

### Logo Sizing:
- **Minimum Width**: 120px for brand logo
- **Maximum Width**: No limit, maintain aspect ratio
- **Clear Space**: Minimum 20px on all sides

### Icon Sizing:
- **App Icons**: Use `app_icon.svg` - automatically scaled by build tools
- **Favicons**: 16x16, 32x32, 48x48 variants provided
- **Touch Icons**: 180x180 for iOS, 192x192 for Android

### Background Usage:
- **Light Backgrounds**: Use standard logo with full colors
- **Dark Backgrounds**: Use white/light version (to be created if needed)
- **Colored Backgrounds**: Ensure sufficient contrast

## 🛠️ Implementation

### Flutter Integration:
1. Run `flutter pub get` to install dependencies
2. Execute `flutter pub run flutter_launcher_icons:main` to generate icons
3. Icons will be automatically applied to all platforms

### Manual Generation:
Run the provided script:
```bash
./generate_icons.sh
```

### Web Integration:
- Icons are referenced in `web/manifest.json`
- Favicon is set in `web/index.html`
- Progressive Web App icons included

## 📱 Platform-Specific Notes

### iOS:
- Icons include all required sizes for iPhone and iPad
- App Store icon (1024x1024) included
- Uses rounded corners automatically applied by iOS

### Android:
- Adaptive icons with foreground/background separation
- Notification icons (monochrome white versions)
- Supports dynamic theming on Android 12+

### Web:
- Progressive Web App manifest configured
- Multiple favicon formats for browser compatibility
- Apple touch icons for iOS Safari bookmarks

## 🎨 Design Philosophy

The ASIM Platform brand reflects:
- **Professional Excellence**: Clean, modern design suitable for business use
- **Cultural Respect**: Tasteful incorporation of Afghan flag colors
- **Technological Innovation**: Signal/connectivity theme represents cutting-edge eSIM technology
- **Global Reach**: Universal symbols that work across cultures and markets
- **Trust & Reliability**: Solid, stable visual elements that inspire confidence

## 🔄 Future Enhancements

Consider creating:
- Animated logo variants for splash screens
- Dark mode versions
- Simplified monochrome versions
- Branded templates for presentations
- Social media profile images
- Business card layouts

## 📞 Contact

For questions about brand usage or additional assets, please refer to the brand guidelines or contact the design team.

---

*Generated on: $(date)*
*Version: 1.0.0*
