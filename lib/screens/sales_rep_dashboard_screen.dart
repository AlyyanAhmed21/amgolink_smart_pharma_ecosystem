import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_card.dart';
import '../data/dummy_data.dart';
import '../main.dart'; 

class SalesRepDashboardScreen extends StatefulWidget {
  const SalesRepDashboardScreen({super.key});

  @override
  State<SalesRepDashboardScreen> createState() => _SalesRepDashboardScreenState();
}

class _SalesRepDashboardScreenState extends State<SalesRepDashboardScreen> {
  final List<Doctor> _doctors = dummyDoctors;
  final List<Task> _tasks = repTasks;

  // Stock Data for Pie Chart
  final Map<String, double> _stock = stockData;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Field Dashboard', style: TextStyle(color: AppTheme.primaryPurple, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
           IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: AppTheme.primaryPurple),
            onPressed: () => ThemeHelper.toggleTheme(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Placeholder (Video: 1:00)
            FadeInDown(
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=30.0444,31.2357&zoom=12&size=600x300&key=YOUR_API_KEY'), // Placeholder URL, won't load but shows box
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: GlassContainer(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: AppTheme.secondaryPink),
                          SizedBox(width: 8),
                          Text('Cairo North Territory', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Stock Count Donut Chart (Video: 1:00)
            FadeInUp(
              child: GlassContainer(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 30,
                            sections: [
                              PieChartSectionData(
                                color: AppTheme.primaryPurple, 
                                value: _stock['Product A']!, 
                                title: '${_stock['Product A']!.toInt()}',
                                radius: 12,
                                titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                              PieChartSectionData(
                                color: AppTheme.secondaryCyan, 
                                value: _stock['Product B']!, 
                                title: '${_stock['Product B']!.toInt()}',
                                radius: 12,
                                titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stock Count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 8),
                            _LegendItem(color: AppTheme.primaryPurple, label: 'Product A (450)'),
                            SizedBox(height: 4),
                            _LegendItem(color: AppTheme.secondaryCyan, label: 'Product B (320)'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Tasks Section
            Text('Pending Tasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ..._tasks.map((task) => FadeInLeft(child: _buildTaskCard(task, isDark))),

            const SizedBox(height: 32),

            // Doctor List
             Text('My Doctors', style: Theme.of(context).textTheme.titleLarge),
             const SizedBox(height: 12),
             ..._doctors.map((doc) => FadeInUp(child: _buildDoctorCard(doc, isDark))),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, bool isDark) {
    Color priorityColor = task.priority == 'High' ? Colors.red : Colors.orange;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
         children: [
           Icon(Icons.check_circle_outline, color: Colors.grey[600]),
           const SizedBox(width: 12),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
               Text(task.priority, style: TextStyle(color: priorityColor, fontSize: 12, fontWeight: FontWeight.bold)),
             ],
           ),
         ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doc, bool isDark) {
    return GestureDetector(
      onTap: () => _showDoctorProfile(doc),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
           border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
             CircleAvatar(
               backgroundColor: AppTheme.secondaryPink,
               child: const Icon(Icons.person, color: Colors.white),
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                   Text(doc.specialty, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                 ],
               ),
             ),
             const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showDoctorProfile(Doctor doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
             Container(width: 40, height: 4, color: Colors.grey[600]),
             const SizedBox(height: 24),
             CircleAvatar(
               radius: 40, 
               backgroundColor: AppTheme.secondaryPink,
               child: Text(doc.name[0], style: const TextStyle(fontSize: 32, color: Colors.white)),
             ),
             const SizedBox(height: 16),
             Text(doc.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
             Text(doc.specialty, style: const TextStyle(color: Colors.grey)),
             
             const SizedBox(height: 32),
             
             // Prescribing Trends Chart (Video: 1:30)
             Align(alignment: Alignment.centerLeft, child: Text('Prescribing Trends', style: Theme.of(context).textTheme.titleMedium)),
             const SizedBox(height: 16),
             SizedBox(
               height: 150,
               child: LineChart(
                 LineChartData(
                   gridData: const FlGridData(show: false),
                   titlesData: const FlTitlesData(show: false),
                   borderData: FlBorderData(show: false),
                   lineBarsData: [
                     LineChartBarData(
                       spots: const [
                         FlSpot(0, 1),
                         FlSpot(1, 1.5),
                         FlSpot(2, 1.4),
                         FlSpot(3, 3.4),
                         FlSpot(4, 2),
                         FlSpot(5, 2.2),
                         FlSpot(6, 4.0),
                       ],
                       isCurved: true,
                       color: AppTheme.secondaryCyan,
                       barWidth: 4,
                       isStrokeCapRound: true,
                       dotData: const FlDotData(show: false),
                       belowBarData: BarAreaData(show: true, color: AppTheme.secondaryCyan.withValues(alpha: 0.1)),
                     ),
                   ],
                 ),
               ),
             ),
             
             const Spacer(),
             
             SizedBox(
               width: double.infinity,
               child: ElevatedButton.icon(
                 onPressed: () => Navigator.pop(context),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppTheme.success,
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                 ),
                 icon: const Icon(Icons.check, color: Colors.white),
                 label: const Text('Mark Visit Complete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
               ),
             ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
