import 'dart:math' as math;

import 'package:flutter/material.dart';

class GlassRibbon extends StatefulWidget {
  const GlassRibbon({super.key, this.size = 520});

  final double size;

  @override
  State<GlassRibbon> createState() => _GlassRibbonState();
}

class _GlassRibbonState extends State<GlassRibbon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        final angle = (t - 0.5) * 0.07;
        return Transform.rotate(
          angle: angle,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _RibbonPainter(t: t),
            ),
          ),
        );
      },
    );
  }
}

class _RibbonPainter extends CustomPainter {
  _RibbonPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 7; i++) {
      final phase = t * 2 * math.pi + i * 0.7;
      final path = Path();
      final amp = radius * (0.55 + 0.06 * math.sin(phase));
      const segs = 90;
      for (var s = 0; s <= segs; s++) {
        final p = s / segs;
        final theta = p * 2 * math.pi;
        final wob = math.sin(theta * 3 + phase) * 0.18;
        final r = amp * (0.65 + wob);
        final x = center.dx + r * math.cos(theta + i * 0.4);
        final y = center.dy +
            r * math.sin(theta + i * 0.4) * 0.55 +
            math.sin(theta * 2 + phase) * 14;
        if (s == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      paint
        ..color = Color.lerp(
          const Color(0x801FBF8E),
          const Color(0x80A0C4D5),
          (i / 7).clamp(0.0, 1.0),
        )!
        ..strokeWidth = 1.6 + (i.isEven ? 0.8 : 0.0);
      canvas.drawPath(path, paint);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x551FBF8E),
          const Color(0x00FFFFFF),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glow);
  }

  @override
  bool shouldRepaint(covariant _RibbonPainter old) => old.t != t;
}

class MiniGlassRibbon extends StatelessWidget {
  const MiniGlassRibbon({super.key, this.height = 56, this.width = 120});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _RibbonPainter(t: 0.4),
      ),
    );
  }
}
