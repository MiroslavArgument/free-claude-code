import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/shadows.dart';
import '../core/theme/typography.dart';
import '../core/widgets/pill_button.dart';
import '../core/widgets/soft_card.dart';
import '../core/widgets/status_bar.dart';
import '../navigation/direction.dart';
import '../navigation/shell.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TrumiaColors.bgPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FakeStatusBar(),
          const SizedBox(height: 24),
          const _CardCarousel(),
          const SizedBox(height: 18),
          const _Dots(),
          const SizedBox(height: 22),
          const _ActionRow(),
          const SizedBox(height: 22),
          const _LinkedCard(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Center(
              child: PillButton(
                label: 'Back',
                icon: Icons.keyboard_arrow_up_rounded,
                onTap: () => TrumiaShell.of(context).close(NavDirection.up),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardCarousel extends StatelessWidget {
  const _CardCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Container(
          width: 320,
          height: 196,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [TrumiaColors.cardTeal, TrumiaColors.cardTealDark],
            ),
            boxShadow: trumiaElevatedShadow,
          ),
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('TRUMIA', style: TrumiaTypography.cardLogo),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('··  1922', style: TrumiaTypography.cardNumber),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'VISA',
                  style: TrumiaTypography.base(
                    size: 22,
                    weight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ).copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots();

  @override
  Widget build(BuildContext context) {
    return Row(
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
        _dot(),
        const SizedBox(width: 8),
        _dot(),
        const SizedBox(width: 12),
        Container(
          width: 24,
          height: 24,
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
    );
  }

  Widget _dot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFFCDD0D6),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: SoftCard(
              height: 96,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const _ActionContent(
                icon: Icons.ac_unit_rounded,
                label: 'Freeze',
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SoftCard(
              height: 96,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const _ActionContent(
                icon: Icons.visibility_outlined,
                label: 'Details',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionContent extends StatelessWidget {
  const _ActionContent({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: TrumiaColors.textPrimary),
        const SizedBox(height: 12),
        Text(label, style: TrumiaTypography.buttonLabel),
      ],
    );
  }
}

class _LinkedCard extends StatelessWidget {
  const _LinkedCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SoftCard(
        radius: 24,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Linked to', style: TrumiaTypography.sectionLabel),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF003399),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🇪🇺', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Text('Personal • EUR', style: TrumiaTypography.listTitle),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: TrumiaColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _LinkedRow(
              icon: Icons.description_outlined,
              label: 'Transactions',
            ),
            const SizedBox(height: 8),
            const _LinkedRow(
              icon: Icons.shield_outlined,
              label: 'Security settings',
            ),
            const SizedBox(height: 8),
            const _LinkedRow(
              icon: Icons.tune_rounded,
              label: 'Spending limits',
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkedRow extends StatelessWidget {
  const _LinkedRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: TrumiaColors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TrumiaColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: TrumiaColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Text(label, style: TrumiaTypography.listTitle),
        ],
      ),
    );
  }
}
