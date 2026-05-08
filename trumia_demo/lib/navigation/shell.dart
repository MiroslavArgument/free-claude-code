import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/accounts_modal.dart';
import '../screens/cards_screen.dart';
import '../screens/home_screen.dart';
import '../screens/payments_screen.dart';
import '../screens/transactions_screen.dart';
import 'direction.dart';

/// Direction semantics:
///   NavDirection.up    = Cards. Off-screen at the TOP. Opens with swipe DOWN.
///   NavDirection.down  = Transactions. Off-screen at BOTTOM. Opens with swipe UP.
///   NavDirection.left  = Accounts. Off-screen at the LEFT. Opens with swipe RIGHT.
///   NavDirection.right = Payments. Off-screen at the RIGHT. Opens with swipe LEFT.
class TrumiaShell extends StatefulWidget {
  const TrumiaShell({super.key});

  @override
  State<TrumiaShell> createState() => TrumiaShellState();

  static TrumiaShellState of(BuildContext context) {
    final state = context.findAncestorStateOfType<TrumiaShellState>();
    assert(state != null, 'TrumiaShell not found in context');
    return state!;
  }
}

class TrumiaShellState extends State<TrumiaShell>
    with TickerProviderStateMixin {
  static const _settleDuration = Duration(milliseconds: 320);
  static const _cancelDuration = Duration(milliseconds: 220);
  static const _settleCurve = Curves.easeOutCubic;
  static const _commitProgress = 0.35;
  static const _commitVelocity = 500.0;
  static const _axisLockThreshold = 10.0;
  static const _leftEdgeRegion = 32.0;

  late final Map<NavDirection, AnimationController> _ctrls;

  NavDirection? _activeAxis;
  Offset _startGlobal = Offset.zero;
  bool _hapticFired = false;

  @override
  void initState() {
    super.initState();
    _ctrls = {
      for (final d in NavDirection.values)
        d: AnimationController(vsync: this, duration: _settleDuration),
    };
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  AnimationController controllerFor(NavDirection d) => _ctrls[d]!;

  NavDirection? get openDirection {
    for (final entry in _ctrls.entries) {
      if (entry.value.value > 0.5) return entry.key;
    }
    return null;
  }

  Future<void> open(NavDirection d) async {
    final c = _ctrls[d]!;
    await c.animateTo(1.0, duration: _settleDuration, curve: _settleCurve);
  }

  Future<void> close(NavDirection d) async {
    final c = _ctrls[d]!;
    await c.animateTo(0.0, duration: _cancelDuration, curve: _settleCurve);
  }

  Future<void> closeAll() async {
    await Future.wait(_ctrls.entries.map((e) => e.value.animateTo(
          0.0,
          duration: _cancelDuration,
          curve: _settleCurve,
        )));
  }

  // Signed progress in the OPENING direction (positive when opening).
  // Closing happens by negative progress added to value 1.0.
  double _openingProgress(NavDirection dir, Offset delta, Size size) {
    switch (dir) {
      case NavDirection.up:
        return delta.dy / size.height; // swipe down opens
      case NavDirection.down:
        return -delta.dy / size.height; // swipe up opens
      case NavDirection.left:
        return delta.dx / size.width; // swipe right opens
      case NavDirection.right:
        return -delta.dx / size.width; // swipe left opens
    }
  }

  double _signedVelocity(NavDirection dir, Offset v) {
    switch (dir) {
      case NavDirection.up:
        return v.dy;
      case NavDirection.down:
        return -v.dy;
      case NavDirection.left:
        return v.dx;
      case NavDirection.right:
        return -v.dx;
    }
  }

  void _onPanStart(DragStartDetails d) {
    _startGlobal = d.globalPosition;
    _activeAxis = null;
    _hapticFired = false;
  }

  void _onPanUpdate(DragUpdateDetails d, Size size) {
    final delta = d.globalPosition - _startGlobal;
    final open = openDirection;

    if (_activeAxis == null) {
      if (delta.distance < _axisLockThreshold) return;
      _activeAxis = _resolveAxis(delta, open: open);
      if (_activeAxis == null) return;
    }

    final dir = _activeAxis!;
    final ctrl = _ctrls[dir]!;
    final progress = _openingProgress(dir, delta, size);

    if (open == null) {
      // Opening from home: drag opens dir.
      ctrl.value = progress.clamp(0.0, 1.0);
    } else if (open == dir) {
      // Closing the currently open overlay: progress goes negative.
      ctrl.value = (1.0 + progress).clamp(0.0, 1.0);
    } else {
      ctrl.value = 0.0;
    }

    if (!_hapticFired) {
      final delta01 = open == null ? ctrl.value : (1.0 - ctrl.value);
      if (delta01 >= _commitProgress) {
        _hapticFired = true;
        HapticFeedback.lightImpact();
      }
    }
  }

  NavDirection? _resolveAxis(Offset delta, {NavDirection? open}) {
    final ax = delta.dx.abs();
    final ay = delta.dy.abs();

    // If a panel is open, only allow gestures that close it (opposite to open dir).
    if (open != null) {
      switch (open) {
        case NavDirection.up:
          return delta.dy < 0 && ay >= ax ? NavDirection.up : null;
        case NavDirection.down:
          return delta.dy > 0 && ay >= ax ? NavDirection.down : null;
        case NavDirection.left:
          return delta.dx < 0 && ax >= ay ? NavDirection.left : null;
        case NavDirection.right:
          // Only edge-swipe from left edge counts (per spec).
          final fromLeftEdge = _startGlobal.dx <= _leftEdgeRegion;
          return delta.dx > 0 && ax >= ay && fromLeftEdge
              ? NavDirection.right
              : null;
      }
    }

    if (ax > ay) {
      // Horizontal axis dominant.
      if (delta.dx < 0) return NavDirection.right; // swipe left → Payments
      if (delta.dx > 0) return NavDirection.left;  // swipe right → Accounts
    } else {
      if (delta.dy > 0) return NavDirection.up;    // swipe down → Cards
      if (delta.dy < 0) return NavDirection.down;  // swipe up   → Transactions
    }
    return null;
  }

  void _onPanEnd(DragEndDetails d, Size size) {
    final dir = _activeAxis;
    _activeAxis = null;
    _hapticFired = false;
    if (dir == null) return;

    final ctrl = _ctrls[dir]!;
    final v = _signedVelocity(dir, d.velocity.pixelsPerSecond);

    final bool shouldOpen;
    if (v >= _commitVelocity) {
      shouldOpen = true;
    } else if (v <= -_commitVelocity) {
      shouldOpen = false;
    } else {
      shouldOpen = ctrl.value >= 0.5;
    }

    if (shouldOpen) {
      ctrl.animateTo(1.0, duration: _settleDuration, curve: _settleCurve);
    } else {
      ctrl.animateTo(0.0, duration: _cancelDuration, curve: _settleCurve);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: _onPanStart,
          onPanUpdate: (d) => _onPanUpdate(d, size),
          onPanEnd: (d) => _onPanEnd(d, size),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const HomeScreen(),
              _buildSlideOverlay(NavDirection.right, const PaymentsScreen(), size),
              _buildSlideOverlay(NavDirection.up, const CardsScreen(), size),
              _buildSlideOverlay(NavDirection.down, const TransactionsScreen(), size),
              _buildAccountsOverlay(size),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlideOverlay(NavDirection dir, Widget child, Size size) {
    final ctrl = _ctrls[dir]!;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final v = ctrl.value;
        if (v <= 0.001) return const SizedBox.shrink();
        Offset offset;
        switch (dir) {
          case NavDirection.up:
            offset = Offset(0, -size.height * (1 - v));
            break;
          case NavDirection.down:
            offset = Offset(0, size.height * (1 - v));
            break;
          case NavDirection.right:
            offset = Offset(size.width * (1 - v), 0);
            break;
          case NavDirection.left:
            offset = Offset(-size.width * (1 - v), 0);
            break;
        }
        return Transform.translate(offset: offset, child: child);
      },
    );
  }

  Widget _buildAccountsOverlay(Size size) {
    final ctrl = _ctrls[NavDirection.left]!;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final v = ctrl.value;
        if (v <= 0.001) return const SizedBox.shrink();
        return IgnorePointer(
          ignoring: v < 0.05,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => close(NavDirection.left),
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.4 * v),
                ),
              ),
              Transform.translate(
                offset: Offset(-340 * (1 - v), 0),
                child: const AccountsModal(),
              ),
              Positioned(
                top: 36,
                right: 16,
                child: Opacity(
                  opacity: v,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => close(NavDirection.left),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14000000),
                            offset: Offset(2, 3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
