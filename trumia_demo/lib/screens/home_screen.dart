import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/shadows.dart';
import '../core/theme/typography.dart';
import '../core/widgets/glass_ribbon.dart';
import '../core/widgets/pill_button.dart';
import '../core/widgets/soft_card.dart';
import '../core/widgets/status_bar.dart';
import '../data/mock_data.dart';
import '../navigation/direction.dart';
import '../navigation/shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TrumiaColors.bgPrimary,
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopCardsPeek(),
          ),
          const Positioned(
            left: -80,
            right: -80,
            top: 240,
            child: Center(
              child: GlassRibbon(size: 560),
            ),
          ),
          Column(
            children: [
              const FakeStatusBar(),
              const _TopToolbar(),
              const SizedBox(height: 24),
              const _HeroBalance(),
              const SizedBox(height: 6),
              Text('Main euro', style: TrumiaTypography.heroSubtitle),
              const SizedBox(height: 86),
              const _CarouselDots(),
              const SizedBox(height: 22),
              const _ActionRow(),
              const Spacer(),
              const _TransactionsPeek(),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopToolbar extends StatelessWidget {
  const _TopToolbar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleIconButton(icon: Icons.person_outline_rounded),
          const Spacer(),
          const CircleIconButton(icon: Icons.credit_card_rounded),
          const Spacer(),
          const CircleIconButton(
            icon: Icons.notifications_none_rounded,
            badge: CountBadge(count: 4),
          ),
        ],
      ),
    );
  }
}

class _HeroBalance extends StatelessWidget {
  const _HeroBalance();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('15 999', style: TrumiaTypography.heroBalance),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(',74 €', style: TrumiaTypography.heroBalanceSuffix),
        ),
      ],
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => TrumiaShell.of(context).open(NavDirection.left),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 6,
            decoration: BoxDecoration(
              color: TrumiaColors.accentGreen,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          _dot(const Color(0xFFCDD0D6)),
          const SizedBox(width: 8),
          _dot(const Color(0xFFCDD0D6)),
          const SizedBox(width: 12),
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: TrumiaColors.surfaceElevated,
              shape: BoxShape.circle,
              boxShadow: trumiaPillShadow,
            ),
            child: const Icon(
              Icons.add_rounded,
              size: 14,
              color: TrumiaColors.accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            label: 'Top-up',
            icon: Icons.upload_rounded,
            onTap: () {},
          ),
          _ActionButton(
            label: 'Move',
            icon: Icons.swap_horiz_rounded,
            onTap: () {},
          ),
          _ActionButton(
            label: 'Send',
            icon: Icons.north_east_rounded,
            background: TrumiaColors.accentGreen,
            foreground: Colors.white,
            elevated: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    this.onTap,
    this.background,
    this.foreground,
    this.elevated = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? background;
  final Color? foreground;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final fg = foreground ?? TrumiaColors.textPrimary;
    return SoftCard(
      onTap: onTap,
      width: 110,
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 18),
      radius: 22,
      elevated: elevated,
      color: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: fg, size: 22),
          const SizedBox(height: 14),
          Text(label, style: TrumiaTypography.buttonLabel.copyWith(color: fg)),
        ],
      ),
    );
  }
}

/// Cards card peeking from above — most of the card sits off-screen, only the
/// bottom edge is visible behind the top toolbar. The opacity follows the
/// shell's "cards" controller (60% at rest → 100% as the card slides into view).
class _TopCardsPeek extends StatelessWidget {
  const _TopCardsPeek();

  @override
  Widget build(BuildContext context) {
    final ctrl = TrumiaShell.of(context).controllerFor(NavDirection.up);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => TrumiaShell.of(context).open(NavDirection.up),
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (context, _) {
          final v = ctrl.value;
          final opacity = (0.6 + 0.4 * v).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Transform.translate(
              offset: const Offset(0, -120),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: TrumiaColors.cardTeal.withValues(alpha: opacity),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      offset: Offset(0, 8),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TransactionsPeek extends StatelessWidget {
  const _TransactionsPeek();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => TrumiaShell.of(context).open(NavDirection.down),
      child: Container(
        decoration: const BoxDecoration(
          color: TrumiaColors.surfaceMuted,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              offset: Offset(0, -4),
              blurRadius: 20,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _PeekHeader(),
            const SizedBox(height: 12),
            const _PeekTodayRow(),
            const SizedBox(height: 8),
            for (var i = 0; i < mockTransactionGroups.first.items.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _PeekItem(item: mockTransactionGroups.first.items[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _PeekHeader extends StatelessWidget {
  const _PeekHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleIconButton(icon: Icons.search_rounded, size: 36),
        const Spacer(),
        Text('Transactions', style: TrumiaTypography.screenTitle),
        const Spacer(),
        const CircleIconButton(icon: Icons.tune_rounded, size: 36),
      ],
    );
  }
}

class _PeekTodayRow extends StatelessWidget {
  const _PeekTodayRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Today', style: TrumiaTypography.groupHeader),
          Text(
            '+2 197,19 €',
            style: TrumiaTypography.amountSecondary
                .copyWith(color: TrumiaColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _PeekItem extends StatelessWidget {
  const _PeekItem({required this.item});

  final MockTransaction item;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      radius: 16,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TrumiaColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, size: 20, color: TrumiaColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: TrumiaTypography.listTitle),
                Text(item.time, style: TrumiaTypography.listSubtitle),
              ],
            ),
          ),
          Text(
            item.amount,
            style: TrumiaTypography.amount.copyWith(
              color: item.isCredit
                  ? TrumiaColors.accentGreen
                  : TrumiaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
