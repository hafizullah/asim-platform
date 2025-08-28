/// ASIM Platform Logo Asset Constants
/// 
/// Centralized management of all logo and icon assets to ensure consistency
/// across the platform. Use these constants instead of hardcoded paths.
library;

class LogoAssets {
  // Private constructor to prevent instantiation
  LogoAssets._();

  /// Main brand SVG assets
  static const String brandLogo = 'assets/images/brand_logo.svg';
  static const String fullLogo = 'assets/images/logo.svg';
  static const String appIcon = 'assets/images/app_icon_fixed.svg';
  
  /// PNG fallbacks (for platforms that don't support SVG)
  static const String appIconPng = 'assets/images/app_icon_color.png';
  
  /// Logo usage guidelines
  static const Map<String, String> usage = {
    'brand': brandLogo,     // Horizontal brand logo for headers and navigation
    'full': fullLogo,       // Full logo with taglines for hero sections
    'icon': appIcon,        // Icon-only version for app icons and favicons
    'fallback': appIconPng, // PNG fallback for compatibility
  };
  
  /// Recommended sizes for different contexts
  static const Map<String, Map<String, double>> recommendedSizes = {
    'small': {'width': 120, 'height': 36},    // App bars, navigation
    'medium': {'width': 200, 'height': 60},   // Headers, footers
    'large': {'width': 400, 'height': 120},   // Hero sections, splash
    'icon': {'width': 48, 'height': 48},      // Compact spaces, lists
  };
  
  /// Brand colors matching the Afghan flag theme
  static const Map<String, int> brandColors = {
    'primaryGreen': 0xFF006633,      // Dark green from Afghan flag
    'accentGreen': 0xFF228B22,       // Medium green
    'lightGreen': 0xFF32CD32,        // Light green highlight
    'primaryRed': 0xFFCC0000,        // Dark red from Afghan flag
    'accentRed': 0xFFFF3333,         // Light red accent
    'white': 0xFFFFFFFF,             // White from Afghan flag
    'textDark': 0xFF1A1A1A,          // Dark text
    'textLight': 0xFF666666,         // Light text
  };
}
