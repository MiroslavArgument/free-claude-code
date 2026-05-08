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

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
    this.background,
    this.foreground,
    this.elevated = false,
    this.badge,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? background;
  final Color? foreground;
  final bool elevated;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background ?? TrumiaColors.surfaceElevated,
          shape: BoxShape.circle,
          boxShadow: elevated ? trumiaElevatedShadow : trumiaPillShadow,
        ),
        child: Center(
          child: Icon(
            icon,
            size: size * 0.45,
            color: foreground ?? TrumiaColors.textPrimary,
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
