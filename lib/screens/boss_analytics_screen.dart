import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_glass_card.dart';
import '../data/dummy_data.dart';
import '../main.dart';
import 'manager_analytics_screen.dart';

class BossAnalyticsScreen extends StatelessWidget {
  const BossAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Boss Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Company Overview',
                style: TextStyle(
                    fontSize: 12, color: theme.onSurface.withOpacity(0.6))),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                color: AppTheme.primaryPurple),
            onPressed: () => ThemeHelper.toggleTheme(context),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. KPI Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildKPI(
                  context, "Total Reps", "24", Icons.people, Colors.purple),
              _buildKPI(context, "Tasks Done", "156 / 200", Icons.check_circle,
                  Colors.purple),
              _buildKPI(context, "Sales Growth", "+18.5%", Icons.trending_up,
                  Colors.purple),
              _buildKPI(
                  context, "Target Hit", "92%", Icons.flag, Colors.orange),
            ],
          ),
          const SizedBox(height: 24),

          // 2. Action Buttons (Navigation Hub)
          _actionButton(
              context,
              "Manage Reps",
              "View all sales representatives",
              FontAwesomeIcons.users,
              Colors.purple,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ManagerAnalyticsScreen()))),
          const SizedBox(height: 12),
          _actionButton(
              context,
              "Sales Data",
              "View daily sales per rep",
              FontAwesomeIcons.dollarSign,
              Colors.pink,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const _BossSalesDataScreen()))),
          const SizedBox(height: 12),
          _actionButton(
              context,
              "Field Visits",
              "View all reps' visits & feedback",
              FontAwesomeIcons.mapLocationDot,
              Colors.blue,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const _BossVisitsScreen()))),

          const SizedBox(height: 24),

          // 3. UPGRADED Sales Analytics Chart
          const Text("Sales Analytics",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          NeonGlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Monthly Revenue",
                        style: TextStyle(
                            color: theme.onSurface.withOpacity(0.6),
                            fontSize: 14)),
                    Text("EGP 2.4M",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                            fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),

                // Target Progress Bar (Custom Gradient Implementation)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Quarterly Target",
                        style: TextStyle(
                            color: theme.onSurface.withOpacity(0.6),
                            fontSize: 12)),
                    Text("92%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.success,
                            fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.onSurface.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.92,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: AppTheme.neonGradient,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // THE FIXED CHART
                SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 3.5,
                      // Tooltip Fixed for version 0.66.0
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor:
                              theme.surface, // FIXED: was getTooltipColor
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY}M',
                              TextStyle(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        touchCallback:
                            (FlTouchEvent event, barTouchResponse) {},
                      ),
                      // Grid Lines
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.onSurface.withOpacity(0.1),
                          strokeWidth: 1,
                        ),
                      ),
                      // Borders
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                            bottom: BorderSide(
                                color: theme.onSurface.withOpacity(0.2))),
                      ),
                      // Axis Titles
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              const titles = ['Jan', 'Feb', 'Mar', 'Apr'];
                              if (value.toInt() >= titles.length)
                                return const Text("");
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  titles[value.toInt()],
                                  style: TextStyle(
                                      color: theme.onSurface.withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // The Bars
                      barGroups: [
                        _makeBar(0, 1.8),
                        _makeBar(1, 2.1),
                        _makeBar(2, 2.8, isPeak: true), // Current Month
                        _makeBar(3, 2.4), // Projected
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text("Doctor Performance",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          // 4. Doctor List
          ...dummyDoctors.take(3).map((doc) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeonGlassCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor:
                              AppTheme.primaryPurple.withOpacity(0.1),
                          child: Text(doc.name[4],
                              style: const TextStyle(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(doc.revenue,
                                style: const TextStyle(
                                    color: AppTheme.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(doc.growth,
                          style: const TextStyle(color: Colors.green))
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 24),
          const Text("Disease Market Trends",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          // 5. Market Trends
          _trendItem(
              "Cardiovascular", "Market Share: 28%", "+12%", Colors.green),
          _trendItem("Diabetes", "Market Share: 22%", "+8%", Colors.green),
          _trendItem("Respiratory", "Market Share: 15%", "+3%", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildKPI(BuildContext context, String title, String val,
      IconData icon, Color color) {
    return NeonGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(val,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String title, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: NeonGlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20)
          ],
        ),
      ),
    );
  }

  Widget _chartRow(String label, String val, ColorScheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: theme.onSurface.withOpacity(0.6), fontSize: 12)),
        Text(val,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
                fontSize: 12)),
      ],
    );
  }

  Widget _trendItem(String title, String sub, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonGlassCard(
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(sub,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(val,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y, {bool isPeak = false}) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y,
        width: 18,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        gradient: isPeak
            ? AppTheme.neonGradient // Bright Gradient for peak
            : LinearGradient(
                // Subtle Gradient for others
                colors: [
                  AppTheme.primaryPurple.withOpacity(0.5),
                  AppTheme.primaryPurple.withOpacity(0.3)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
      )
    ]);
  }
}

// ================= SUB-SCREEN: BOSS SALES DATA =================
class _BossSalesDataScreen extends StatelessWidget {
  const _BossSalesDataScreen();

  @override
  Widget build(BuildContext context) {
    // Group sales by Date for Boss View
    final Map<String, List<SaleRecord>> groupedSales = {};
    for (var sale in MockData.sales) {
      if (!groupedSales.containsKey(sale.date)) {
        groupedSales[sale.date] = [];
      }
      groupedSales[sale.date]!.add(sale);
    }

    // Hardcode dates for demo visual match
    groupedSales['Tuesday, December 16, 2025'] = [
      SaleRecord(
          id: 's1',
          date: '',
          product: 'CardioMax 10mg',
          doctorName: 'Dr. Ibrahim Clinic',
          amount: 2250,
          units: 50),
      SaleRecord(
          id: 's2',
          date: '',
          product: 'DiabetoCare 500mg',
          doctorName: 'Dr. Fatima Medical',
          amount: 1950,
          units: 30),
    ];
    groupedSales['Monday, December 15, 2025'] = [
      SaleRecord(
          id: 's3',
          date: '',
          product: 'CardioMax 10mg',
          doctorName: 'Dr. Ahmed Hospital',
          amount: 1800,
          units: 40),
      SaleRecord(
          id: 's4',
          date: '',
          product: 'RespiClear Inhaler',
          doctorName: 'City Hospital',
          amount: 3000,
          units: 25),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Sales Data")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          NeonGlassCard(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Revenue", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text("EGP 23,975",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                    width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Units Sold", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text("400 units",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Ledger
          ...groupedSales.entries.map((entry) {
            // Calculate daily total
            double dailyTotal =
                entry.value.fold(0, (sum, item) => sum + item.amount);
            int dailyUnits =
                entry.value.fold(0, (sum, item) => sum + item.units);

            return Column(
              children: [
                // Date Header with Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: AppTheme.primaryPurple),
                        const SizedBox(width: 8),
                        Text(entry.key,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("EGP ${dailyTotal.toInt()}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("$dailyUnits units",
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Transactions
                ...entry.value.map((sale) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NeonGlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:
                                      AppTheme.primaryPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.shopping_bag,
                                  color: AppTheme.primaryPurple, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sale.product,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(sale.doctorName,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          size: 10,
                                          color: AppTheme.primaryPink),
                                      const SizedBox(width: 4),
                                      const Text("Ahmed Hassan",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: AppTheme.primaryPink)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("EGP ${sale.amount.toInt()}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryPurple)),
                                Text("${sale.units} x EGP 45",
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey)),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
              ],
            );
          })
        ],
      ),
    );
  }
}

// ================= SUB-SCREEN: BOSS VISITS =================
class _BossVisitsScreen extends StatelessWidget {
  const _BossVisitsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Field Visits & Feedback"),
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_alt_outlined), onPressed: () {})
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Stats
          Row(
            children: [
              Expanded(child: _visitStat("Total Visits", "8", Colors.purple)),
              const SizedBox(width: 12),
              Expanded(child: _visitStat("Avg Rating", "4.5", Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _visitStat("Total Time", "5h 40m", Colors.blue)),
            ],
          ),
          const SizedBox(height: 24),

          // Feedback List (Grouped by Date visually)
          _dateHeader("Tuesday, December 16, 2025", "4.5"),
          const SizedBox(height: 12),
          _feedbackCard(
              "Dr. Ibrahim Clinic",
              "City General Hospital",
              "Ahmed Hassan",
              "Excellent visit! Doctor was very receptive to new cardiology products.",
              5,
              true),
          _feedbackCard(
              "Dr. Fatima Medical",
              "Metro Medical Center",
              "Ahmed Hassan",
              "Good meeting. Doctor interested in diabetes line.",
              4,
              true),

          const SizedBox(height: 24),
          _dateHeader("Monday, December 15, 2025", "5.0"),
          const SizedBox(height: 12),
          _feedbackCard("Dr. Ahmed Hospital", "Wellness Hospital",
              "Fatima Mohamed", "Outstanding presentation.", 5, true),
        ],
      ),
    );
  }

  Widget _visitStat(String label, String val, Color color) {
    return NeonGlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(val,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _dateHeader(String date, String rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const Icon(Icons.calendar_today,
              size: 14, color: AppTheme.primaryPurple),
          const SizedBox(width: 8),
          Text(date,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
        ]),
        Row(children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text(rating, style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
      ],
    );
  }

  Widget _feedbackCard(String doc, String hosp, String rep, String feedback,
      int rating, bool hasQuote) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.secondaryCyan,
                    child: Icon(Icons.person, size: 16, color: Colors.white)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(hosp,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Row(
                    children: List.generate(
                        5,
                        (index) => Icon(Icons.star,
                            size: 12,
                            color: index < rating
                                ? Colors.amber
                                : Colors.grey[300])))
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 12, color: AppTheme.primaryPink),
                const SizedBox(width: 4),
                Text(rep,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.primaryPink)),
              ],
            ),
            if (hasQuote) ...[
              const SizedBox(height: 8),
              Text('"$feedback"',
                  style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)),
            ]
          ],
        ),
      ),
    );
  }
}
