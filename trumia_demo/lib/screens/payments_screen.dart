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

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TrumiaColors.bgPrimary,
      child: Stack(
        children: [
          Column(
            children: [
              const FakeStatusBar(),
              _TopBar(
                onBack: () => TrumiaShell.of(context).close(NavDirection.right),
              ),
              const SizedBox(height: 12),
              const _SearchField(),
              const SizedBox(height: 18),
              const _ActionTiles(),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                  itemCount: mockContacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _ContactRow(contact: mockContacts[i]),
                ),
              ),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: const _BalancePill(),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          const Spacer(),
          Text('Payments', style: TrumiaTypography.screenTitle),
          const Spacer(),
          const CircleIconButton(icon: Icons.calendar_today_rounded),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: TrumiaColors.surfaceElevated,
          borderRadius: BorderRadius.circular(100),
          boxShadow: trumiaPillShadow,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              size: 18,
              color: TrumiaColors.textTertiary,
            ),
            const SizedBox(width: 10),
            Text(
              'Search by name, date, amount',
              style: TrumiaTypography.base(
                size: 14,
                weight: FontWeight.w400,
                color: TrumiaColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTiles extends StatelessWidget {
  const _ActionTiles();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _ActionTile(
              accent: TrumiaColors.accentGreen,
              label: 'Trumia Pay',
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TrumiaColors.accentGreenSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'T',
                  style: TrumiaTypography.base(
                    size: 22,
                    weight: FontWeight.w800,
                    color: TrumiaColors.accentGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionTile(
              accent: null,
              label: 'New bank details',
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TrumiaColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  size: 22,
                  color: TrumiaColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.child,
    this.accent,
  });

  final String label;
  final Widget child;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> shadow = accent != null
        ? [
            const BoxShadow(
              color: Color(0xFFFFFFFF),
              offset: Offset(-3, -3),
              blurRadius: 8,
            ),
            const BoxShadow(
              color: Color(0x331FBF8E),
              offset: Offset(0, 4),
              blurRadius: 18,
            ),
          ]
        : trumiaSoftShadow;

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TrumiaColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        boxShadow: shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          child,
          Text(
            label,
            style: TrumiaTypography.listTitle.copyWith(
              color: accent ?? TrumiaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact});

  final MockContact contact;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      radius: 16,
      child: Row(
        children: [
          _Avatar(contact: contact),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: TrumiaTypography.listTitle),
                const SizedBox(height: 2),
                Text(
                  contact.subtitle,
                  style: TrumiaTypography.listSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            contact.date,
            style: TrumiaTypography.amountSecondary,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.contact});

  final MockContact contact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: contact.color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            contact.initials,
            style: TrumiaTypography.base(
              size: 13,
              weight: FontWeight.w700,
              color: TrumiaColors.textPrimary,
            ),
          ),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: TrumiaColors.bgPrimary, width: 2),
            ),
            child: contact.isTrumia
                ? Text(
                    'T',
                    style: TrumiaTypography.base(
                      size: 10,
                      weight: FontWeight.w800,
                      color: TrumiaColors.accentGreen,
                    ),
                  )
                : const Icon(
                    Icons.account_balance_rounded,
                    size: 10,
                    color: TrumiaColors.textPrimary,
                  ),
          ),
        ),
      ],
    );
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => TrumiaShell.of(context).close(NavDirection.right),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: TrumiaColors.surfaceElevated.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(28),
          boxShadow: trumiaElevatedShadow,
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              children: [
                Text(
                  '15 999',
                  style: TrumiaTypography.base(
                    size: 24,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  ',74 €',
                  style: TrumiaTypography.base(
                    size: 14,
                    weight: FontWeight.w600,
                    color: TrumiaColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Positioned(
              right: 0,
              child: Opacity(
                opacity: 0.55,
                child: MiniGlassRibbon(width: 96, height: 56),
              ),
            ),
            Positioned(
              right: 6,
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TrumiaColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 18,
                  color: TrumiaColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
