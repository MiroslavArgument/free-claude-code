import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/widgets/pill_button.dart';
import '../core/widgets/soft_card.dart';
import '../core/widgets/status_bar.dart';
import '../data/mock_data.dart';
import '../navigation/direction.dart';
import '../navigation/shell.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TrumiaColors.bgPrimary,
      child: Stack(
        children: [
          Column(
            children: [
              const FakeStatusBar(),
              const _Header(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  children: [
                    for (final group in mockTransactionGroups) ...[
                      _GroupHeader(group: group),
                      const SizedBox(height: 12),
                      for (final tx in group.items) ...[
                        _TransactionRow(item: tx),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: Center(
              child: PillButton(
                label: 'Back',
                icon: Icons.keyboard_arrow_down_rounded,
                onTap: () => TrumiaShell.of(context).close(NavDirection.down),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          const CircleIconButton(icon: Icons.search_rounded),
          const Spacer(),
          Text('Transactions', style: TrumiaTypography.screenTitle),
          const Spacer(),
          const CircleIconButton(icon: Icons.tune_rounded),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.group});

  final MockTransactionGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Row(
        children: [
          Text(group.label, style: TrumiaTypography.groupHeader),
          const Spacer(),
          Text(
            group.dailyTotal,
            style: TrumiaTypography.amountSecondary
                .copyWith(color: TrumiaColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.item});

  final MockTransaction item;

  @override
  Widget build(BuildContext context) {
    final amountColor = item.isCredit
        ? TrumiaColors.cardTeal
        : TrumiaColors.textPrimary;
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
                const SizedBox(height: 2),
                Text(item.time, style: TrumiaTypography.listSubtitle),
              ],
            ),
          ),
          Text(
            item.amount,
            style: TrumiaTypography.amount.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}
