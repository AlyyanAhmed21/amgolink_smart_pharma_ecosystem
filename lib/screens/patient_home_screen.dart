import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../data/dummy_data.dart';
import '../main.dart'; // For ThemeHelper

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final List<Medicine> _meds = dummyMedicines;
  bool _caretakerAlertEnabled = true; // Default ON per video

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
             backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=patient'), // Placeholder
             backgroundColor: AppTheme.secondaryCyan,
             child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                fontSize: 14, 
                color: isDark ? Colors.grey[400] : Colors.grey[700]
              ),
            ),
             Text(
              'Ali',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: AppTheme.secondaryCyan,
            ),
            onPressed: () => ThemeHelper.toggleTheme(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cycle-based Reminders Button (Video: 0:05)
            FadeInDown(
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.secondaryCyan),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(FontAwesomeIcons.rotate, color: AppTheme.secondaryCyan, size: 16),
                  label: const Text('Cycle-based Reminders', style: TextStyle(color: AppTheme.secondaryCyan)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hero Card: Next Dose Countdown (Video: 0:05)
            FadeInUp(
              child: GlassContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 10.0,
                        percent: 0.75,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("02:15", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                            Text("Hrs left", style: TextStyle(fontSize: 10, color: Colors.grey[300])),
                          ],
                        ),
                        progressColor: AppTheme.secondaryCyan,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Next Dose',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'CardioMax 10mg',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '8:00 PM • After Meal',
                              style: TextStyle(
                                  color: AppTheme.secondaryCyan,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Caretaker Alert Toggle (Video: 0:26)
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _caretakerAlertEnabled 
                      ? AppTheme.secondaryPink.withValues(alpha: 0.1) 
                      : Colors.transparent,
                  border: Border.all(
                      color: _caretakerAlertEnabled 
                          ? AppTheme.secondaryPink 
                          : Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notification_important, 
                        color: _caretakerAlertEnabled ? AppTheme.secondaryPink : Colors.grey),
                    const SizedBox(width: 12),
                     Expanded(
                      child: Text(
                        'Caretaker Alerts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87
                        ),
                      ),
                    ),
                    Switch(
                      value: _caretakerAlertEnabled,
                      activeColor: AppTheme.secondaryPink,
                      onChanged: (val) {
                        setState(() => _caretakerAlertEnabled = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(val ? 'Family Alerts Enabled 🔔' : 'Family Alerts Disabled 🔕'),
                            backgroundColor: val ? AppTheme.secondaryPink : Colors.grey,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Today's Meds (Using Dummy Data)
            Text(
              'Today\'s Meds',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ..._meds.map((med) => FadeInLeft(
              child: _buildMedicineItem(med, isDark),
            )),

            const SizedBox(height: 32),

            // Education Section (Video: 0:26 Education Tab)
            Text(
              'Education & Insights',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildEducationCard(
                    'Hypertension', 
                    'High Incidence Areas:\nCairo North 28%', 
                    const Color(0xFFEF5350)
                  ),
                  const SizedBox(width: 16),
                  _buildEducationCard(
                    'Type 2 Diabetes', 
                    'Prevention Tips &\nDiebetic Diet', 
                    const Color(0xFF42A5F5)
                  ),
                  const SizedBox(width: 16),
                  _buildEducationCard(
                    'Asthma', 
                    'Air Quality Alert:\nModerate', 
                    Colors.orange
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            
            // Emergency Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: Colors.red),
                ),
                icon: const Icon(Icons.emergency),
                label: const Text('Emergency Hotline 911', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineItem(Medicine med, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2)),
        boxShadow: isDark ? [] : [
           BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(med.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: med.isTaken ? TextDecoration.lineThrough : null,
                     color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  '${med.dosage} • ${med.time}',
                  style: TextStyle(color: isDark ? Colors.grey : Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
          Checkbox(
            value: med.isTaken,
            activeColor: AppTheme.success,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onChanged: (val) {
              setState(() => med.isTaken = val!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(String title, String subtitle, Color color) {
    return Container(
      width: 200,
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.article, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
