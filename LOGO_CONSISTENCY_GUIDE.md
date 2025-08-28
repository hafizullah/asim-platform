# ASIM Platform Logo Consistency Guide

## Overview
This document outlines the logo standardization implemented across the ASIM Platform to ensure consistent branding across all platforms and user touchpoints.

## Implemented Changes

### 1. Centralized Logo Management
- **Created**: `lib/core/constants/logo_assets.dart` - Centralized asset paths and brand colors
- **Created**: `lib/core/widgets/asim_unified_logo.dart` - Single logo widget for all use cases

### 2. Logo Asset Organization
All logo assets are now standardized in `/assets/images/`:

#### SVG Assets (Primary)
- `app_icon_fixed.svg` - High-quality app icon (1024x1024)
- `brand_logo.svg` - Horizontal brand logo with text (400x120)
- `logo.svg` - Full logo with taglines (400x120)

#### PNG Assets (Fallback)
- `app_icon_color.png` - PNG version for launcher icons

### 3. Usage Patterns

#### Navigation Bar
```dart
AsimUnifiedLogo.navBar()
// 120x36, brand variant, no tagline
```

#### Page Headers
```dart
AsimUnifiedLogo.header(showTagline: true)
// 200x60, brand variant, with tagline
```

#### Hero Sections
```dart
AsimUnifiedLogo.hero()
// 400x120, full variant, with taglines
```

#### Icon Only
```dart
AsimUnifiedLogo.iconOnly()
// 48x48, icon variant only
```

#### App Icon/Splash
```dart
AsimUnifiedLogo.appIcon()
// 128x128, icon variant for app stores
```

### 4. Brand Colors (Afghan Flag Theme)
All widgets now use consistent brand colors from `LogoAssets.brandColors`:

- **Primary Green**: `#006633` - Dark green from Afghan flag
- **Accent Green**: `#228B22` - Medium green for signal bars
- **Light Green**: `#32CD32` - Light green highlights
- **Primary Red**: `#CC0000` - Dark red from Afghan flag
- **Accent Red**: `#FF3333` - Light red accents
- **White**: `#FFFFFF` - White from Afghan flag

### 5. Platform-Specific Updates

#### Web (index.html)
- Favicons regenerated from consistent source
- Apple touch icons updated
- Proper theme colors applied

#### Flutter App
- Launcher icons use `app_icon_color.png` (PNG required)
- All in-app usage now uses SVG assets via `AsimUnifiedLogo`

#### Icon Generation
- Script updated to use `app_icon_fixed.svg` as source
- All web icons regenerated for consistency

### 6. File Updates Made

#### New Files
- `lib/core/constants/logo_assets.dart`
- `lib/core/widgets/asim_unified_logo.dart`
- `LOGO_CONSISTENCY_GUIDE.md` (this file)

#### Updated Files
- `lib/core/widgets/asim_svg_logo.dart` - Enabled SVG support, updated constants
- `lib/core/widgets/asim_logo.dart` - Updated to use centralized constants
- `lib/screens/landing_page.dart` - Updated to use unified logo widget
- `flutter_launcher_icons.yaml` - Kept PNG for compatibility
- Web icons regenerated via `generate_icons.sh`

### 7. Benefits of Standardization

1. **Consistent Branding**: Same logo appears identical across all platforms
2. **Maintainability**: Single source of truth for assets and colors
3. **Scalability**: SVG assets ensure crisp rendering at all sizes
4. **Performance**: Proper fallback handling prevents loading errors
5. **Developer Experience**: Clear usage patterns with semantic constructors

### 8. Usage Guidelines

#### When to Use Each Variant

| Context | Widget | Size | Variant |
|---------|--------|------|---------|
| Navigation bars | `AsimUnifiedLogo.navBar()` | 120x36 | Brand |
| Page headers | `AsimUnifiedLogo.header()` | 200x60 | Brand |
| Hero sections | `AsimUnifiedLogo.hero()` | 400x120 | Full |
| Lists, cards | `AsimUnifiedLogo.iconOnly()` | 48x48 | Icon |
| Splash screens | `AsimUnifiedLogo.appIcon()` | 128x128 | Icon |

#### Color Customization
```dart
AsimUnifiedLogo.header(
  color: Theme.of(context).colorScheme.primary, // Custom color
)
```

### 9. Technical Implementation

#### SVG Support
- Uses `flutter_svg` package for high-quality rendering
- Automatic fallback to custom painting if SVG fails to load
- Color filtering support for theme integration

#### Responsive Design
- Predefined sizes for different contexts
- Proportional scaling maintains aspect ratios
- Automatic tagline hiding on small sizes

#### Performance
- SVG assets cached by Flutter
- Minimal custom painting overhead
- Efficient painter implementations

### 10. Verification Steps

To verify logo consistency:

1. Check navigation bar logo in app
2. Verify hero section logo on landing page
3. Confirm app icons on device/emulator
4. Test web favicons in browser
5. Validate theme colors match brand guidelines

### 11. Future Maintenance

#### Adding New Logo Usage
1. Use existing `AsimUnifiedLogo` constructors when possible
2. If new variant needed, add to `AsimLogoType` enum
3. Update `LogoAssets` if new assets required
4. Follow established naming patterns

#### Asset Updates
1. Update source SVG files in `/assets/images/`
2. Run `./generate_icons.sh all` to regenerate derived assets
3. Test across all platforms
4. Update version in pubspec.yaml if needed

## Summary

The ASIM Platform now has consistent logo implementation across all platforms, with proper fallback handling, centralized asset management, and developer-friendly APIs. The Afghan flag color theme is consistently applied, and the mobile signal bar design maintains brand identity across all touchpoints.
