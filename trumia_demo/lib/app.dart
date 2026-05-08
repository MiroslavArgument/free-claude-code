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
    return ColoredBox(
      color: const Color(0xFFE5E6E9),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const targetW = 390.0;
            const targetH = 844.0;
            const targetRatio = targetW / targetH;

            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final fitNative = w <= targetW + 8 && (w / h - targetRatio).abs() < 0.05;

            if (fitNative) {
              return SizedBox(
                width: w,
                height: h,
                child: ClipRect(child: child),
              );
            }

            final ratio = w / h;
            double frameW;
            double frameH;
            if (ratio > targetRatio) {
              frameH = h.clamp(0, targetH).toDouble();
              frameW = frameH * targetRatio;
            } else {
              frameW = w.clamp(0, targetW).toDouble();
              frameH = frameW / targetRatio;
            }

            return Center(
              child: Container(
                width: frameW + 16,
                height: frameH + 16,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      offset: Offset(0, 24),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ColoredBox(
                    color: TrumiaColors.bgPrimary,
                    child: SizedBox(width: frameW, height: frameH, child: child),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
