import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/colors.dart';
import 'core/theme/theme.dart';
import 'navigation/shell.dart';

class TrumiaApp extends StatelessWidget {
  const TrumiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trumia',
      theme: TrumiaTheme.light(),
      home: const _DeviceFrame(child: TrumiaShell()),
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: TrumiaColors.bgPrimary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const targetW = 390.0;
          const targetH = 844.0;

          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          if (w <= targetW + 16) {
            return SizedBox(
              width: w,
              height: h,
              child: ClipRect(child: child),
            );
          }

          final frameH = h.clamp(0.0, targetH);
          return Center(
            child: ClipRect(
              child: SizedBox(
                width: targetW,
                height: frameH,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
