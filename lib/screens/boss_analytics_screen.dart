import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/neon_card.dart';
import '../data/dummy_data.dart';
import '../main.dart';

class BossAnalyticsScreen extends StatefulWidget {
  const BossAnalyticsScreen({super.key});

  @override
  State<BossAnalyticsScreen> createState() => _BossAnalyticsScreenState();
}

class _BossAnalyticsScreenState extends State<BossAnalyticsScreen> {
  final List<Doctor> _topDoctors = dummyDoctors; 
  String _selectedRegion = 'All Regions';

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Executive Dashboard',
          style: TextStyle(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
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
            // KPI Row (Video: 0:41)
            FadeInLeft(
              child: Row(
                children: [
                   Expanded(child: _buildKPICard('Total Reps', '24', Icons.people_outline, Colors.blue)),
                   const SizedBox(width: 8),
                   Expanded(child: _buildKPICard('Sales Growth', '+18.5%', Icons.trending_up, Colors.green)), // Green Text
                   const SizedBox(width: 8),
                   Expanded(child: _buildKPICard('Target Hit', '92%', Icons.flag, Colors.orange)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Revenue Chart (Video: Bar Chart EGP 2.4M)
            FadeInUp(
              child: GlassContainer(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Revenue',
                                style: TextStyle(color: isDark ? Colors.grey : Colors.grey[700]), 
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'EGP 2.4M',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '+12.5% vs Prev',
                              style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 3,
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => Colors.grey[800]!,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    '${rod.toY}M',
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const titles = ['Jan', 'Feb', 'Mar', 'Apr'];
                                    return Text(
                                      titles[value.toInt()],
                                      style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600], fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1.8, color: AppTheme.primaryPurple.withValues(alpha: 0.5), width: 16)]),
                              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2.1, color: AppTheme.primaryPurple.withValues(alpha: 0.7), width: 16)]),
                              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2.4, color: AppTheme.secondaryCyan, width: 16)]), // Highlight Peak
                              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 2.3, color: AppTheme.primaryPurple.withValues(alpha: 0.6), width: 16)]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Market Trends (Video: Cardio +12%)
            FadeInUp(
               delay: const Duration(milliseconds: 200),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   _buildTrendCard('Cardio', '+12%', Colors.red),
                   _buildTrendCard('Diabetes', '+9%', Colors.blue),
                   _buildTrendCard('Neuro', '+4%', Colors.purple),
                 ],
               ),
            ),

            const SizedBox(height: 32),

            // Top Doctors List (Video: 0:50)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Performing Doctors',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: AppTheme.secondaryPink)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._topDoctors.map((doc) => _buildDoctorRankCard(doc, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    final isDark = ThemeHelper.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2)),
        boxShadow: isDark ? [] : [
           BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color, // Green text for growth
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: isDark ? Colors.grey : Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(String title, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
           Text(title, style: TextStyle(color: color, fontSize: 12)),
           const SizedBox(height: 4),
           Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDoctorRankCard(Doctor doc, bool isDark) {
    return Container(
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
            backgroundColor: AppTheme.primaryPurple.withValues(alpha: 0.2),
            child: Text(doc.name[4], style: const TextStyle(color: AppTheme.primaryPurple, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  doc.revenue,
                  style: const TextStyle(color: AppTheme.success, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               Text(doc.growth, style: const TextStyle(color: Colors.green)),
               Text('Growth', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
             ],
          ),
        ],
      ),
    );
  }
}
