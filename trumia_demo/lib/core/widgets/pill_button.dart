import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/shadows.dart';
import '../theme/typography.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.background,
    this.foreground,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? background;
  final Color? foreground;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final fg = foreground ?? TrumiaColors.textPrimary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: background ?? TrumiaColors.surfaceElevated,
          borderRadius: BorderRadius.circular(100),
          boxShadow: trumiaPillShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 8),
            ],
            Text(label, style: TrumiaTypography.pillLabel.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}

/// Circular icon button matching the Trumia design spec:
///   - 40×40 outer circle, 24×24 inner icon container, ≤20 glyph
///   - Background: white at 60% opacity
///   - Drop shadow: y=4, blur=31, black at 12%
///   - Approximated iOS "Liquid Glass" via BackdropFilter (frost ~4)
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 40,
    this.background,
    this.foreground,
    this.elevated = false,
    this.badge,
    this.glyphSize = 20,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? background;
  final Color? foreground;
  final bool elevated;
  final Widget? badge;
  final double glyphSize;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000), // black at ~12%
              offset: Offset(0, 4),
              blurRadius: 31,
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: background ?? Colors.white.withValues(alpha: 0.6),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: Icon(
                      icon,
                      size: glyphSize.clamp(0, 20).toDouble(),
                      color: foreground ?? TrumiaColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (badge == null) return button;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        button,
        Positioned(top: -2, right: -2, child: badge!),
      ],
    );
  }
}

class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: TrumiaTypography.base(
          size: 11,
          weight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
