import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import 'patient_home_screen.dart';
import 'sales_rep_dashboard_screen.dart';
import 'manager_analytics_screen.dart';
import 'boss_analytics_screen.dart';
import 'login_screen.dart';
import '../main.dart'; // For ThemeHelper

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _rememberChoice = false;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    // Config for the roles
    final List<Map<String, dynamic>> roles = [
      {
        'title': 'Patient',
        'subtitle': 'Manage health & reminders',
        'icon': FontAwesomeIcons.pills,
        'color': AppTheme.secondaryCyan,
        'destination': const PatientHomeScreen(),
      },
      {
        'title': 'Sales Rep',
        'subtitle': 'Field sales & visits',
        'icon': FontAwesomeIcons.briefcase,
        'color': Colors.orange,
        'destination': const SalesRepDashboardScreen(),
      },
      {
        'title': 'Manager',
        'subtitle': 'Team oversight',
        'icon': FontAwesomeIcons.users,
        'color': AppTheme.primaryPurple,
        'destination': const ManagerAnalyticsScreen(),
      },
      {
        'title': 'Boss',
        'subtitle': 'Analytics & Insights',
        'icon': FontAwesomeIcons.chartLine,
        'color': Colors.amber,
        'destination': const BossAnalyticsScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Gradient (Subtle)
          if (isDark)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      AppTheme.primaryPurple.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                // Top Bar with Theme Switcher
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: AppTheme.primaryPurple,
                        ),
                        onPressed: () => ThemeHelper.toggleTheme(context),
                      ),
                    ],
                  ),
                ),

                // Centered Header
                FadeInDown(
                  child: Column(
                    children: [
                      // Logo / Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                        ),
                        child: const Icon(
                          Icons.medication_liquid_rounded,
                          size: 40,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'AmgoLink',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select your role to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Vertical List of Roles
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    itemCount: roles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: _buildVerticalRoleCard(
                          context,
                          role['title'],
                          role['subtitle'],
                          role['icon'],
                          role['color'],
                          role['destination'],
                        ),
                      );
                    },
                  ),
                ),

                // Footer Checkbox
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _rememberChoice,
                          activeColor: AppTheme.primaryPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) =>
                              setState(() => _rememberChoice = val!),
                        ),
                        Text(
                          'Remember my choice',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalRoleCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget destination,
  ) {
    final isDark = ThemeHelper.isDarkMode(context);

    return GestureDetector(
      onTap: () async {
        if (_rememberChoice) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_role', title);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              targetRoute: destination,
              roleName: title,
              role: title.toLowerCase().replaceAll(' ', '_'),
            ),
          ),
        );
      },
      child: Container(
        height: 90, // Fixed height for consistency
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),

          // BORDER LOGIC: Darker and thicker in light mode
          border: Border.all(
            color: isDark
                ? color.withValues(alpha: 0.3)
                : color.withValues(
                    alpha: 0.5), // Increased visibility in light mode
            width: isDark ? 1 : 1.5, // Slightly thicker in light mode
          ),

          // SHADOW LOGIC: Deeper shadow + Color Glow
          boxShadow: [
            if (!isDark) ...[
              // The Darker "Structure" Shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              // The "Color Glow"
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ] else ...[
              // Dark mode glow
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 20),

            // Text Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: isDark ? Colors.white70 : Colors.grey[600],
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
