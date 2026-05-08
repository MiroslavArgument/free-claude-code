import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/shadows.dart';
import '../core/theme/typography.dart';
import '../data/mock_data.dart';

class AccountsModal extends StatelessWidget {
  const AccountsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 220, 20, 0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: TrumiaColors.surfaceElevated,
              borderRadius: BorderRadius.circular(28),
              boxShadow: trumiaElevatedShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < mockAccounts.length; i++) ...[
                  _AccountRow(account: mockAccounts[i]),
                  if (i != mockAccounts.length - 1) const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.account});

  final MockAccount account;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: account.flagColor,
            shape: BoxShape.circle,
          ),
          child: Text(account.flagEmoji, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(account.title, style: TrumiaTypography.listTitle),
              const SizedBox(height: 2),
              Text(account.amount, style: TrumiaTypography.listSubtitle),
            ],
          ),
        ),
      ],
    );
  }
}
