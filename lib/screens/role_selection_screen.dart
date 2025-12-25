import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_card.dart';
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

    // Grid Items Config (Video: 4 Grid Cards)
    final List<Map<String, dynamic>> roles = [
      {
        'title': 'Patient',
        'icon': FontAwesomeIcons.pills,
        'color': AppTheme.secondaryCyan, // Cyan
        'destination': const PatientHomeScreen(),
      },
      {
        'title': 'Sales Rep',
        'icon': FontAwesomeIcons.briefcase,
        'color': Colors.orange, // Orange
        'destination': const SalesRepDashboardScreen(),
      },
      {
        'title': 'Manager',
        'icon': FontAwesomeIcons.users,
        'color': AppTheme.primaryPurple, // Purple
        'destination': const ManagerAnalyticsScreen(),
      },
      {
        'title': 'Boss',
        'icon': FontAwesomeIcons.chartLine,
        'color': Colors.amber, // Gold
        'destination': const BossAnalyticsScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Stack for background elements if needed
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // Header
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        Text(
                         'AmgoLink',
                         style: TextStyle(
                           fontFamily: 'Orbitron', // Assuming font is available or fallback
                           fontSize: 28,
                           fontWeight: FontWeight.bold,
                           color: isDark ? Colors.white : Colors.black,
                           shadows: [
                             if (isDark)
                               const BoxShadow(color: AppTheme.primaryPurple, blurRadius: 20),
                           ]
                         ),
                       ),
                       IconButton(
                        icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: AppTheme.primaryPurple),
                        onPressed: () => ThemeHelper.toggleTheme(context),
                      ),
                     ],
                   ),
                   const SizedBox(height: 8),
                   Text(
                     'Select your role to continue',
                     style: TextStyle(color: Colors.grey[600]),
                   ),

                   const SizedBox(height: 40),

                   // Role Grid
                   Expanded(
                     child: GridView.builder(
                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 2,
                         crossAxisSpacing: 16,
                         mainAxisSpacing: 16,
                         childAspectRatio: 0.85,
                       ),
                       itemCount: roles.length,
                       itemBuilder: (context, index) {
                         final role = roles[index];
                         return FadeInUp(
                           delay: Duration(milliseconds: 100 * index),
                           child: _buildRoleCard(
                             context,
                             role['title'],
                             role['icon'],
                             role['color'],
                             role['destination'],
                           ),
                         );
                       },
                     ),
                   ),

                   // Remember Me Toggle
                   FadeInUp(
                     delay: const Duration(milliseconds: 600),
                     child: Center(
                       child: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Checkbox(
                             value: _rememberChoice,
                             activeColor: AppTheme.primaryPurple,
                             onChanged: (val) => setState(() => _rememberChoice = val!),
                           ),
                           Text('Remember my choice', style: TextStyle(color: isDark ? Colors.grey : Colors.black87)),
                         ],
                       ),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String title, IconData icon, Color color, Widget destination) {
    bool isDark = ThemeHelper.isDarkMode(context);
    return GestureDetector(
      onTap: () async {
        if (_rememberChoice) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_role', title);
        }
        // Navigate to Login Screen first, passing the destination
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
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: isDark ? [
            BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: -5)
          ] : [
            BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
             Icon(Icons.arrow_forward, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
