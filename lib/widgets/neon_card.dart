import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class NeonCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color glowColor;
  final bool isSelected;

  const NeonCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.glowColor = AppTheme.primaryPurple,
    this.isSelected = false,
  });

  @override
  State<NeonCard> createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            if (isDark) {
              // Dark theme: neon glow
              return Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin ?? const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: widget.glowColor.withValues(
                      alpha: widget.isSelected ? 0.8 : (_isHovering ? 0.6 : 0.3),
                    ),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor.withValues(
                        alpha: widget.isSelected ? 0.6 : _glowAnimation.value * 0.5,
                      ),
                      blurRadius: widget.isSelected ? 25 : 15 + (_glowAnimation.value * 10),
                      spreadRadius: widget.isSelected ? 3 : 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(20),
                    child: widget.child,
                  ),
                ),
              );
            } else {
              // Light theme: soft card
              return Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin ?? const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: widget.glowColor.withValues(
                      alpha: widget.isSelected ? 0.6 : (_isHovering ? 0.4 : 0.2),
                    ),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor.withValues(
                        alpha: widget.isSelected ? 0.2 : _glowAnimation.value * 0.15,
                      ),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(20),
                    child: widget.child,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
