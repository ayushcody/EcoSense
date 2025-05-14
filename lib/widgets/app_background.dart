import 'package:flutter/material.dart';
import 'dart:ui';

class AppBackground extends StatelessWidget {
  final Widget child;
  final ScrollController? scrollController;

  const AppBackground({
    super.key,
    required this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image or gradient
        _buildBackground(context),

        // Scrollable content
        child,
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  Color(0xFF252218),
                  Color(0xFF1E1C16),
                ]
              : const [
                  Color(0xFFF7F3E9),
                  Color(0xFFEAE6D7),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Overlay pattern
          Opacity(
            opacity: 0.03,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isDark
                      ? 'assets/images/pattern_dark.png'
                      : 'assets/images/pattern_light.png'),
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
          ),

          // Garden/eco-city image simulation with circles (since we don't have the image)
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: _buildDecorationElements(isDark),
            ),
          ),

          // Glass effect overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorationElements(bool isDark) {
    return CustomPaint(
      painter: DecorationPainter(isDark: isDark),
    );
  }
}

class DecorationPainter extends CustomPainter {
  final bool isDark;

  DecorationPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..style = PaintingStyle.fill;

    // Draw hills/city silhouette
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.7);

    // First hill
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.35,
      size.height * 0.7,
    );

    // Second hill
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.85,
      size.width * 0.65,
      size.height * 0.7,
    );

    // Third hill
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.5,
      size.width,
      size.height * 0.7,
    );

    path.lineTo(size.width, size.height);
    path.close();

    // Draw the path with a gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [Color(0xFF38352C), Color(0xFF2D2A25)]
          : [Color(0xFFD5CDBA), Color(0xFFCAC2B0)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    basePaint.shader = gradient;
    canvas.drawPath(path, basePaint);

    // Draw some decorative elements (trees, buildings)
    _drawDecorativeElements(canvas, size);
  }

  void _drawDecorativeElements(Canvas canvas, Size size) {
    final treePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDark ? Color(0xFF4A474A) : Color(0xFF7D8C73);

    // Draw some trees or buildings
    for (int i = 0; i < 10; i++) {
      final x = size.width * (0.1 + (i * 0.09));
      final y = size.height * 0.7 - (i % 3) * 10;
      final height = 15 + (i % 4) * 5.0;

      if (i % 2 == 0) {
        // Draw a tree
        final treePath = Path();
        treePath.moveTo(x, y);
        treePath.lineTo(x - 8, y + height);
        treePath.lineTo(x + 8, y + height);
        treePath.close();
        canvas.drawPath(treePath, treePaint);

        // Tree trunk
        canvas.drawRect(
          Rect.fromLTWH(x - 1.5, y + height, 3, 8),
          Paint()..color = isDark ? Color(0xFF3A3730) : Color(0xFF5D4037),
        );
      } else {
        // Draw a building
        canvas.drawRect(
          Rect.fromLTWH(x - 5, y, 10, height + 10),
          Paint()..color = isDark ? Color(0xFF3A3730) : Color(0xFFADA79B),
        );

        // Windows
        final windowPaint = Paint()
          ..color = isDark ? Color(0xFF5A574F) : Color(0xFFD6CFC0);

        for (int j = 0; j < 3; j++) {
          canvas.drawRect(
            Rect.fromLTWH(x - 3, y + 3 + (j * 6), 6, 3),
            windowPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
