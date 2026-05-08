import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

class FakeStatusBar extends StatelessWidget {
  const FakeStatusBar({super.key, this.dark = true});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? TrumiaColors.textPrimary : Colors.white;
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
        child: Row(
          children: [
            Text(
              '9:41',
              style: TrumiaTypography.base(
                size: 16,
                weight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            _SignalBars(color: color),
            const SizedBox(width: 6),
            Icon(Icons.wifi_rounded, size: 16, color: color),
            const SizedBox(width: 6),
            _Battery(color: color),
          ],
        ),
      ),
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List<Widget>.generate(4, (i) {
        return Container(
          margin: const EdgeInsets.only(left: 2),
          width: 3,
          height: 4.0 + i * 2.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}

class _Battery extends StatelessWidget {
  const _Battery({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 12,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.5),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            right: -2,
            top: 4,
            child: Container(
              width: 2,
              height: 4,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicIslandSpacer extends StatelessWidget {
  const DynamicIslandSpacer({super.key, this.opacity = 0.18});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          width: 110,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
