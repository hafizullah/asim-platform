import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/logo_assets.dart';

/// Unified ASIM Platform Logo Widget
/// 
/// This widget provides a single interface for all logo usage across the platform,
/// ensuring consistency and proper fallback handling.
class AsimUnifiedLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final AsimLogoType type;
  final AsimLogoSize size;
  final Color? color;
  final BoxFit fit;
  final bool showTagline;

  const AsimUnifiedLogo({
    super.key,
    this.width,
    this.height,
    this.type = AsimLogoType.brand,
    this.size = AsimLogoSize.medium,
    this.color,
    this.fit = BoxFit.contain,
    this.showTagline = false,
  });

  /// Small brand logo for navigation bars
  const AsimUnifiedLogo.navBar({
    super.key,
    this.color,
  }) : width = 120,
       height = 36,
       type = AsimLogoType.brand,
       size = AsimLogoSize.small,
       fit = BoxFit.contain,
       showTagline = false;

  /// Medium brand logo for headers
  const AsimUnifiedLogo.header({
    super.key,
    this.color,
    this.showTagline = true,
  }) : width = 200,
       height = 60,
       type = AsimLogoType.brand,
       size = AsimLogoSize.medium,
       fit = BoxFit.contain;

  /// Large full logo for hero sections
  const AsimUnifiedLogo.hero({
    super.key,
    this.color,
  }) : width = 400,
       height = 120,
       type = AsimLogoType.full,
       size = AsimLogoSize.large,
       fit = BoxFit.contain,
       showTagline = true;

  /// Icon-only for compact spaces
  const AsimUnifiedLogo.iconOnly({
    super.key,
    this.width = 48,
    this.height = 48,
    this.color,
  }) : type = AsimLogoType.icon,
       size = AsimLogoSize.small,
       fit = BoxFit.contain,
       showTagline = false;

  /// App icon for splash screens and app store
  const AsimUnifiedLogo.appIcon({
    super.key,
    this.width = 128,
    this.height = 128,
    this.color,
  }) : type = AsimLogoType.icon,
       size = AsimLogoSize.medium,
       fit = BoxFit.contain,
       showTagline = false;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? _getDefaultDimensions().width;
    final effectiveHeight = height ?? _getDefaultDimensions().height;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: type == AsimLogoType.icon
          ? _buildIconLogo(context, effectiveWidth, effectiveHeight)
          : _buildBrandLogo(context, effectiveWidth, effectiveHeight),
    );
  }

  Widget _buildIconLogo(BuildContext context, double width, double height) {
    return SvgPicture.asset(
      LogoAssets.appIcon,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null 
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => _buildFallbackIcon(context, width, height),
    );
  }

  Widget _buildBrandLogo(BuildContext context, double width, double height) {
    final assetPath = type == AsimLogoType.full 
        ? LogoAssets.fullLogo 
        : LogoAssets.brandLogo;

    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null 
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => _buildFallbackBrand(context, width, height),
    );
  }

  Widget _buildFallbackIcon(BuildContext context, double width, double height) {
    final greenColor = color ?? Color(LogoAssets.brandColors['accentGreen']!);
    final redColor = Color(LogoAssets.brandColors['primaryRed']!);

    return Container(
      width: width,
      height: height,
      child: CustomPaint(
        painter: SignalIconPainter(
          greenColor: greenColor,
          redColor: redColor,
          size: height * 0.8,
        ),
      ),
    );
  }

  Widget _buildFallbackBrand(BuildContext context, double width, double height) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;
    final greenColor = Color(LogoAssets.brandColors['accentGreen']!);
    final redColor = Color(LogoAssets.brandColors['primaryRed']!);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: height * 0.8,
          height: height * 0.6,
          child: CustomPaint(
            painter: SignalIconPainter(
              greenColor: greenColor,
              redColor: redColor,
              size: height * 0.5,
            ),
          ),
        ),
        SizedBox(width: width * 0.05),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ASIM',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: height * 0.35,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              if (showTagline && size != AsimLogoSize.small) ...[
                SizedBox(height: height * 0.05),
                Text(
                  'Professional eSIM Platform',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: height * 0.12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (type == AsimLogoType.full && size == AsimLogoSize.large) ...[
                  SizedBox(height: height * 0.02),
                  Text(
                    'Connecting Afghanistan to the World',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: height * 0.10,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  LogoDimensions _getDefaultDimensions() {
    final sizeMap = LogoAssets.recommendedSizes[size.name]!;
    return LogoDimensions(
      width: sizeMap['width']!,
      height: sizeMap['height']!,
    );
  }
}

/// Custom painter for the signal icon
class SignalIconPainter extends CustomPainter {
  final Color greenColor;
  final Color redColor;
  final double size;

  SignalIconPainter({
    required this.greenColor,
    required this.redColor,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()..style = PaintingStyle.fill;
    final barWidth = size * 0.15;
    final spacing = size * 0.05;
    final baseY = canvasSize.height * 0.8;

    // Signal bars with Afghan flag green gradient effect
    final bars = [
      (height: size * 0.4, x: 0.0),
      (height: size * 0.6, x: barWidth + spacing),
      (height: size * 0.8, x: (barWidth + spacing) * 2),
      (height: size * 1.0, x: (barWidth + spacing) * 3),
    ];

    // Draw signal bars
    for (final bar in bars) {
      // Main bar (darker green)
      paint.color = greenColor;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(bar.x, baseY - bar.height, barWidth, bar.height),
        Radius.circular(barWidth * 0.2),
      );
      canvas.drawRRect(rect, paint);

      // Highlight effect (lighter green)
      paint.color = greenColor.withOpacity(0.7);
      final highlightRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          bar.x + barWidth * 0.1, 
          baseY - bar.height + barWidth * 0.1, 
          barWidth * 0.8, 
          bar.height * 0.8
        ),
        Radius.circular(barWidth * 0.15),
      );
      canvas.drawRRect(highlightRect, paint);
    }

    // SIM card element (Afghan flag red)
    paint.color = redColor;
    final simRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        canvasSize.width * 0.3,
        canvasSize.height * 0.1,
        canvasSize.width * 0.4,
        canvasSize.height * 0.15,
      ),
      Radius.circular(size * 0.1),
    );
    canvas.drawRRect(simRect, paint);

    // Signal waves
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size * 0.05;
    paint.strokeCap = StrokeCap.round;
    paint.color = redColor.withOpacity(0.8);

    final waveStartX = canvasSize.width * 0.7;
    final waveY = canvasSize.height * 0.25;

    // First wave
    final path1 = Path();
    path1.moveTo(waveStartX, waveY);
    path1.quadraticBezierTo(
      waveStartX + size * 0.2, 
      waveY - size * 0.1, 
      waveStartX + size * 0.4, 
      waveY,
    );
    canvas.drawPath(path1, paint);

    // Second wave (longer)
    paint.color = redColor.withOpacity(0.6);
    paint.strokeWidth = size * 0.04;
    final path2 = Path();
    path2.moveTo(waveStartX - size * 0.1, waveY - size * 0.1);
    path2.quadraticBezierTo(
      waveStartX + size * 0.25, 
      waveY - size * 0.25, 
      waveStartX + size * 0.6, 
      waveY - size * 0.1,
    );
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum AsimLogoType {
  /// Horizontal brand logo with ASIM text
  brand,
  
  /// Full logo with text and taglines
  full,
  
  /// Icon only version
  icon,
}

enum AsimLogoSize {
  small,
  medium,
  large,
}

class LogoDimensions {
  final double width;
  final double height;

  const LogoDimensions({
    required this.width,
    required this.height,
  });
}
