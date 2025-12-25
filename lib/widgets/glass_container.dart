import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final bool showGlow;
  final Color glowColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.showGlow = false,
    this.glowColor = AppTheme.primaryPurple,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    if (isDark) {
      // Dark theme: glassmorphism
      return Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showGlow ? AppTheme.neonGlow(color: glowColor, blur: 15) : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: child,
            ),
          ),
        ),
      );
    } else {
      // Light theme: solid card with soft shadow
      return Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: showGlow 
                ? glowColor.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: showGlow
              ? AppTheme.softGlow(color: glowColor)
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: child,
      );
    }
  }
}
