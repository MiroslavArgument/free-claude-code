import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/shadows.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
    this.elevated = false,
    this.color,
    this.onTap,
    this.width,
    this.height,
    this.alignment,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final bool elevated;
  final Color? color;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? TrumiaColors.surfaceElevated,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: elevated ? trumiaElevatedShadow : trumiaSoftShadow,
      ),
      child: child,
    );

    if (onTap == null) return container;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: container,
    );
  }
}
