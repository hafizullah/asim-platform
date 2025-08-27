import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Commented out temporarily

/// SVG-based ASIM Platform Logo Widget
/// 
/// Uses the actual brand SVG files for high-quality rendering
/// Note: SVG support temporarily disabled, using fallback
class AsimSvgLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final AsimSvgLogoVariant variant;
  final BoxFit fit;
  final Color? color;

  const AsimSvgLogo({
    super.key,
    this.width,
    this.height,
    this.variant = AsimSvgLogoVariant.brand,
    this.fit = BoxFit.contain,
    this.color,
  });

  /// Small logo for app bars (uses icon variant)
  const AsimSvgLogo.small({
    super.key,
    this.color,
  }) : width = 120,
       height = 36,
       variant = AsimSvgLogoVariant.icon,
       fit = BoxFit.contain;

  /// Medium logo for headers (uses brand variant)
  const AsimSvgLogo.medium({
    super.key,
    this.color,
  }) : width = 200,
       height = 60,
       variant = AsimSvgLogoVariant.brand,
       fit = BoxFit.contain;

  /// Large logo for hero sections (uses brand variant)
  const AsimSvgLogo.large({
    super.key,
    this.color,
  }) : width = 400,
       height = 120,
       variant = AsimSvgLogoVariant.brand,
       fit = BoxFit.contain;

  /// Icon only for compact spaces
  const AsimSvgLogo.iconOnly({
    super.key,
    this.width = 48,
    this.height = 48,
    this.color,
  }) : variant = AsimSvgLogoVariant.icon,
       fit = BoxFit.contain;

  @override
  Widget build(BuildContext context) {
    // Temporarily use fallback until SVG is properly set up
    return _buildFallback(context);
    
    // TODO: Enable SVG when properly configured
    // final String assetPath = _getAssetPath();
    // 
    // return SizedBox(
    //   width: width,
    //   height: height,
    //   child: SvgPicture.asset(
    //     assetPath,
    //     width: width,
    //     height: height,
    //     fit: fit,
    //     colorFilter: color != null 
    //         ? ColorFilter.mode(color!, BlendMode.srcIn)
    //         : null,
    //     placeholderBuilder: (context) => _buildFallback(context),
    //   ),
    // );
  }

  String _getAssetPath() {
    switch (variant) {
      case AsimSvgLogoVariant.brand:
        return 'assets/images/brand_logo.svg';
      case AsimSvgLogoVariant.icon:
        return 'assets/images/app_icon_fixed.svg';
      case AsimSvgLogoVariant.full:
        return 'assets/images/logo.svg';
    }
  }

  Widget _buildFallback(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;
    final greenColor = const Color(0xFF228B22);
    final redColor = const Color(0xFFCC0000);
    
    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Signal icon with Afghan flag colors
          Container(
            width: (height ?? 48) * 0.8,
            height: (height ?? 48) * 0.6,
            child: CustomPaint(
              painter: SignalIconPainter(
                greenColor: greenColor,
                redColor: redColor,
                size: (height ?? 48) * 0.5,
              ),
            ),
          ),
          if (variant == AsimSvgLogoVariant.brand || variant == AsimSvgLogoVariant.full) ...[
            const SizedBox(width: 8),
            Text(
              'ASIM',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: (height ?? 48) * 0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom painter for the signal icon (same as in asim_logo.dart)
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

enum AsimSvgLogoVariant {
  /// Full brand logo with text and taglines (logo.svg)
  full,
  
  /// Horizontal brand logo with ASIM text (brand_logo.svg)
  brand,
  
  /// Icon only version (app_icon_fixed.svg)
  icon,
}
