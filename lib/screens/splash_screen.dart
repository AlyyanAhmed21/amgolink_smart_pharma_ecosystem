import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'role_selection_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final rememberedRole = prefs.getString('remembered_role');

    if (rememberedRole != null && mounted) {
      _navigateToRole(rememberedRole);
    } else if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const RoleSelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _navigateToRole(String role) {
    String roleName = '';
    switch (role) {
      case 'patient': roleName = 'Patient'; break;
      case 'sales_rep': roleName = 'Sales Rep'; break;
      case 'manager': roleName = 'Manager'; break;
      case 'boss': roleName = 'Executive'; break;
      default: roleName = 'User';
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            LoginScreen(role: role, roleName: roleName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with glow
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.neonGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple
                                .withValues(alpha: 0.6 * _glowAnimation.value),
                            blurRadius: 30 * _glowAnimation.value,
                            spreadRadius: 10 * _glowAnimation.value,
                          ),
                          BoxShadow(
                            color: AppTheme.secondaryCyan
                                .withValues(alpha: 0.4 * _glowAnimation.value),
                            blurRadius: 50 * _glowAnimation.value,
                            spreadRadius: 15 * _glowAnimation.value,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.medication_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // App name
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: ShaderMask(
                    shaderCallback: (bounds) => AppTheme.neonGradient.createShader(bounds),
                    child: Text(
                      'AmgoLink',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Opacity(
                  opacity: _fadeAnimation.value * _glowAnimation.value,
                  child: Text(
                    'Smart Pharma Ecosystem',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 3,
                        ),
                  ),
                ),
                const SizedBox(height: 60),
                // Loading indicator
                Opacity(
                  opacity: _glowAnimation.value,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryPurple.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ],
            );
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
