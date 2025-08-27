import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// ASIM Platform Brand Logo Widget
/// 
/// A professional logo widget that displays the ASIM Platform brand
/// with Afghan flag colors and mobile signal theme.
/// 
/// Features:
/// - Scalable SVG graphics
/// - Professional Afghan flag color scheme
/// - Mobile signal bars theme
/// - Multiple size variants
/// - Consistent branding across app
class AsimLogo extends StatelessWidget {
  final AsimLogoSize size;
  final AsimLogoVariant variant;
  final bool showTagline;
  final Color? color;

  const AsimLogo({
    super.key,
    this.size = AsimLogoSize.medium,
    this.variant = AsimLogoVariant.brand,
    this.showTagline = true,
    this.color,
  });

  /// Small logo for app bars and compact spaces
  const AsimLogo.small({
    super.key,
    this.variant = AsimLogoVariant.brand,
    this.showTagline = false,
    this.color,
  }) : size = AsimLogoSize.small;

  /// Large logo for hero sections and splash screens
  const AsimLogo.large({
    super.key,
    this.variant = AsimLogoVariant.brand,
    this.showTagline = true,
    this.color,
  }) : size = AsimLogoSize.large;

  /// Icon-only version for tight spaces
  const AsimLogo.iconOnly({
    super.key,
    this.size = AsimLogoSize.small,
    this.showTagline = false,
    this.color,
  }) : variant = AsimLogoVariant.iconOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = _getDimensions();

    if (variant == AsimLogoVariant.iconOnly) {
      return _buildSignalIcon(context, dimensions);
    }

    return _buildBrandLogo(context, dimensions);
  }

  LogoDimensions _getDimensions() {
    switch (size) {
      case AsimLogoSize.small:
        return const LogoDimensions(width: 120, height: 36, iconSize: 24);
      case AsimLogoSize.medium:
        return const LogoDimensions(width: 200, height: 60, iconSize: 32);
      case AsimLogoSize.large:
        return const LogoDimensions(width: 400, height: 120, iconSize: 48);
    }
  }

  Widget _buildBrandLogo(BuildContext context, LogoDimensions dimensions) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;

    return SizedBox(
      width: dimensions.width,
      height: dimensions.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSignalIcon(context, dimensions),
          SizedBox(width: dimensions.width * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ASIM',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: dimensions.height * 0.35,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                if (showTagline) ...[
                  SizedBox(height: dimensions.height * 0.05),
                  Text(
                    'Professional eSIM Platform',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: dimensions.height * 0.12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (size == AsimLogoSize.large) ...[
                    SizedBox(height: dimensions.height * 0.02),
                    Text(
                      'Connecting Afghanistan to the World',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: dimensions.height * 0.10,
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
      ),
    );
  }

  Widget _buildSignalIcon(BuildContext context, LogoDimensions dimensions) {
    final theme = Theme.of(context);
    final greenColor = color ?? const Color(0xFF228B22);
    final redColor = const Color(0xFFCC0000);
    final iconSize = dimensions.iconSize;

    return Container(
      width: iconSize * 1.8,
      height: iconSize * 1.2,
      child: CustomPaint(
        painter: SignalIconPainter(
          greenColor: greenColor,
          redColor: redColor,
          size: iconSize,
        ),
      ),
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

enum AsimLogoSize { small, medium, large }
enum AsimLogoVariant { brand, iconOnly }

class LogoDimensions {
  final double width;
  final double height;
  final double iconSize;

  const LogoDimensions({
    required this.width,
    required this.height,
    required this.iconSize,
  });
}
