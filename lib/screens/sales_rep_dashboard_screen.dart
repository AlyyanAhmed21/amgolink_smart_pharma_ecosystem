import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_glass_card.dart';
import '../data/dummy_data.dart';
import '../main.dart';

class SalesRepDashboardScreen extends StatefulWidget {
  const SalesRepDashboardScreen({super.key});

  @override
  State<SalesRepDashboardScreen> createState() =>
      _SalesRepDashboardScreenState();
}

class _SalesRepDashboardScreenState extends State<SalesRepDashboardScreen> {
  int _currentIndex = 0;

  // Screens
  final List<Widget> _screens = [
    const _ActivityTab(),
    const _DoctorsTab(),
    const _SalesTab(),
    const _VisitsTab(),
    const _MySalesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        height: 70,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
          border:
              isDark ? Border.all(color: Colors.white.withOpacity(0.1)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, FontAwesomeIcons.chartPie, "Activity"),
            _buildNavItem(1, FontAwesomeIcons.userDoctor, "Doctors"),
            _buildNavItem(2, FontAwesomeIcons.chartLine, "Sales"),
            _buildNavItem(3, FontAwesomeIcons.locationDot, "Visits"),
            _buildNavItem(4, FontAwesomeIcons.dollarSign, "My Sales"),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryPurple : Colors.grey,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                  color: isSelected ? AppTheme.primaryPurple : Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

// ================= TAB 1: ACTIVITY =================
class _ActivityTab extends StatefulWidget {
  const _ActivityTab();

  @override
  State<_ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<_ActivityTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Portal",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                color: AppTheme.primaryPurple),
            onPressed: () => ThemeHelper.toggleTheme(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 4 Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.6,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _statCard(
                  "124", "Meetings", FontAwesomeIcons.handshake, Colors.purple),
              _statCard(
                  "1,665", "Samples", FontAwesomeIcons.boxOpen, Colors.pink),
              _statCard("4", "Pending", FontAwesomeIcons.clock, Colors.orange),
              _statCard("87%", "Coverage", FontAwesomeIcons.mapLocation,
                  Colors.green),
            ],
          ),
          const SizedBox(height: 24),

          // Territory Bar Chart
          NeonGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Territory Insights",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.onSurface)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (v, m) => Text(
                                      v.toInt().toString(),
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey)))),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const titles = [
                                      'North',
                                      'South',
                                      'East',
                                      'West',
                                      'Central'
                                    ];
                                    if (value.toInt() < titles.length)
                                      return Text(titles[value.toInt()],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey));
                                    return const Text("");
                                  }))),
                      barGroups: [
                        _barGroup(0, 400),
                        _barGroup(1, 300),
                        _barGroup(2, 500),
                        _barGroup(3, 200),
                        _barGroup(4, 350),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stock Count Donut
          NeonGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Stock Count",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.onSurface)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(
                                value: 450,
                                color: Colors.purple,
                                radius: 15,
                                showTitle: false),
                            PieChartSectionData(
                                value: 320,
                                color: Colors.pink,
                                radius: 15,
                                showTitle: false),
                            PieChartSectionData(
                                value: 180,
                                color: Colors.blue,
                                radius: 15,
                                showTitle: false),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          _legendItem("Product A", "450", Colors.purple),
                          _legendItem("Product B", "320", Colors.pink),
                          _legendItem("Product C", "180", Colors.blue),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tasks Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pending Tasks",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.onSurface)),
              IconButton(
                onPressed: _showAddTaskDialog,
                icon: const Icon(Icons.add, color: AppTheme.primaryPurple),
              )
            ],
          ),
          const SizedBox(height: 12),

          // Tasks List
          ...MockData.tasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      MockData.tasks.removeWhere((t) => t.id == task.id);
                    });
                  },
                  child: NeonGlassCard(
                    child: Row(
                      children: [
                        const Icon(Icons.circle_outlined, color: Colors.grey),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.onSurface)),
                              Text(task.subtitle,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(task.dueDate,
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: _getPriorityColor(task.priority)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: _getPriorityColor(task.priority)
                                      .withOpacity(0.3))),
                          child: Text(task.priority,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: _getPriorityColor(task.priority),
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label, IconData icon, Color color) {
    return NeonGlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(val,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          toY: y,
          color: AppTheme.primaryPurple,
          width: 12,
          borderRadius: BorderRadius.circular(4))
    ]);
  }

  Widget _legendItem(String label, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const Spacer(),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getPriorityColor(String p) {
    if (p == 'High') return Colors.red;
    if (p == 'Medium') return Colors.orange;
    return Colors.green;
  }

  void _showAddTaskDialog() {
    String title = "";
    String subtitle = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                decoration:
                    const InputDecoration(labelText: "Task description"),
                onChanged: (v) => title = v),
            TextField(
                decoration: const InputDecoration(labelText: "Location"),
                onChanged: (v) => subtitle = v),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (title.isNotEmpty) {
                setState(() {
                  MockData.tasks.insert(
                      0,
                      Task(
                          id: DateTime.now().toString(),
                          title: title,
                          subtitle: subtitle,
                          priority: 'Medium',
                          dueDate: DateFormat('MMM d').format(DateTime.now())));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add Task"),
          )
        ],
      ),
    );
  }
}

// ================= TAB 2: DOCTORS =================
class _DoctorsTab extends StatelessWidget {
  const _DoctorsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Doctors")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: MockData.doctors.length,
        itemBuilder: (context, index) {
          final doc = MockData.doctors[index];
          return FadeInUp(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _showDoctorProfile(context, doc),
                child: NeonGlassCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            AppTheme.secondaryCyan.withOpacity(0.2),
                        child: Text(doc.name[0],
                            style: const TextStyle(
                                color: AppTheme.secondaryCyan,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(doc.specialty,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 12, color: Colors.amber),
                                Text(" ${doc.engagementScore}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                const Icon(Icons.history,
                                    size: 12, color: Colors.grey),
                                Text(" ${doc.visits} visits",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDoctorProfile(BuildContext context, Doctor doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              // 1. Header with Back Button
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 16, color: AppTheme.primaryPurple),
                    label: const Text("Back to list",
                        style: TextStyle(color: AppTheme.primaryPurple)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Profile Card
              NeonGlassCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(FontAwesomeIcons.userDoctor,
                          color: AppTheme.primaryPurple, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(doc.specialty,
                              style: const TextStyle(
                                  color: AppTheme.secondaryCyan)),
                          Text(doc.hospital,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.primaryPurple.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(children: [
                        const Text("Score", style: TextStyle(fontSize: 10)),
                        Text("${doc.engagementScore}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryPurple))
                      ]),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Mini Stats
              Row(
                children: [
                  Expanded(
                      child: _miniStat(
                          Icons.calendar_today, "${doc.visits}", "Visits")),
                  Expanded(
                      child:
                          _miniStat(Icons.access_time, doc.lastVisit, "Last")),
                  Expanded(
                      child: _miniStat(Icons.trending_up, "High", "Trend")),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Prescribing Trends (Line Chart)
              const Text("Prescribing Trends",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink)),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (v, m) => Text(
                                  v.toInt().toString(),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey)))),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, m) {
                                const m = [
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec'
                                ];
                                if (v.toInt() < m.length)
                                  return Text(m[v.toInt()],
                                      style: const TextStyle(fontSize: 10));
                                return const Text("");
                              })),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: Border(
                            left:
                                BorderSide(color: Colors.grey.withOpacity(0.3)),
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.3)))),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 40),
                          const FlSpot(1, 45),
                          const FlSpot(2, 42),
                          const FlSpot(3, 60),
                          const FlSpot(4, 70),
                          const FlSpot(5, 75)
                        ],
                        isCurved: true,
                        color: AppTheme.primaryPurple,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 5. Engagement Breakdown (Radar Chart Replacement)
              const Text("Engagement Breakdown",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink)),
              const SizedBox(height: 12),
              NeonGlassCard(
                child: Column(
                  children: [
                    _progressBar("Response", 0.8, Colors.blue),
                    _progressBar("Meetings", 0.6, Colors.purple),
                    _progressBar("Samples", 0.9, Colors.orange),
                    _progressBar("Feedback", 0.7, Colors.green),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 6. Visit History List
              const Text("Visit History",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink)),
              const SizedBox(height: 12),
              _visitHistoryItem(
                  "Product Presentation", "Dec 1", "Positive", Colors.purple),
              _visitHistoryItem(
                  "Follow-up Meeting", "Nov 28", "Sample Request", Colors.blue),
              _visitHistoryItem("Clinical Data Discussion", "Nov 20",
                  "Scheduled", Colors.orange),
              _visitHistoryItem(
                  "Initial Introduction", "Nov 15", "Interested", Colors.pink),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(IconData icon, String val, String label) {
    return NeonGlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.secondaryCyan, size: 20),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _progressBar(String label, double val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text("${(val * 100).toInt()}%",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
          ]),
          const SizedBox(height: 4),
          LinearProgressIndicator(
              value: val,
              color: color,
              backgroundColor: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }

  Widget _visitHistoryItem(
      String title, String date, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonGlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(status,
                        style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Text(date,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ================= TAB 3: SALES =================
class _SalesTab extends StatelessWidget {
  const _SalesTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Group sales by Date
    final Map<String, List<SaleRecord>> groupedSales = {};
    for (var sale in MockData.sales) {
      if (!groupedSales.containsKey(sale.date)) {
        groupedSales[sale.date] = [];
      }
      groupedSales[sale.date]!.add(sale);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Data"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          NeonGlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Revenue",
                        style:
                            TextStyle(color: theme.onSurface.withOpacity(0.6))),
                    const SizedBox(height: 8),
                    Text("EGP 9,225",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.onSurface)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Units Sold",
                        style:
                            TextStyle(color: theme.onSurface.withOpacity(0.6))),
                    const SizedBox(height: 8),
                    Text("150 units",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.onSurface)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...groupedSales.entries.map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📅 ${entry.key}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: theme.primary)),
                  const SizedBox(height: 12),
                  ...entry.value.map((sale) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeonGlassCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color:
                                        AppTheme.primaryPurple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.attach_money,
                                    color: AppTheme.primaryPurple),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sale.product,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(sale.doctorName,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("EGP ${sale.amount.toInt()}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryPink)),
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
              ))
        ],
      ),
    );
  }
}

// ================= TAB 4: VISITS (Fixed Button) =================
class _VisitsTab extends StatefulWidget {
  const _VisitsTab();
  @override
  State<_VisitsTab> createState() => _VisitsTabState();
}

class _VisitsTabState extends State<_VisitsTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Scheduled Visits")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                  child: _headerStat("4", "Completed", AppTheme.primaryPurple)),
              const SizedBox(width: 16),
              Expanded(
                  child: _headerStat("2", "Upcoming", AppTheme.primaryPink)),
            ],
          ),
          const SizedBox(height: 24),
          Text("Upcoming",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.onSurface)),
          const SizedBox(height: 12),
          _visitCard("Dr. Lisa Anderson", "City General", "9:00 AM", true),
          _visitCard("Dr. Robert Taylor", "Prime Healthcare", "2:30 PM", true),
          const SizedBox(height: 24),
          Text("Recent",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.onSurface)),
          const SizedBox(height: 12),
          _visitCard("Dr. Sarah Mitchell", "City General", "Completed", false),
          _visitCard("Dr. James Wilson", "Metro Medical", "Completed", false),
        ],
      ),
    );
  }

  Widget _headerStat(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(val,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }

  Widget _visitCard(
      String name, String hospital, String time, bool isUpcoming) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonGlassCard(
        child: Row(
          children: [
            Column(
              children: [
                Icon(isUpcoming ? Icons.circle_outlined : Icons.check_circle,
                    size: 16,
                    color: isUpcoming
                        ? AppTheme.primaryPink
                        : AppTheme.primaryPurple),
                Container(
                    width: 2, height: 35, color: Colors.grey.withOpacity(0.2)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(hospital,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (isUpcoming)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppTheme.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(time,
                    style: const TextStyle(
                        color: AppTheme.primaryPink,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              )
            else
              ElevatedButton(
                onPressed: () => _showFeedbackDialog(name),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    minimumSize: const Size(90, 35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.zero),
                child: const Text("Feedback",
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              )
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(String doctorName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Feedback for $doctorName"),
        content: const TextField(
          decoration: InputDecoration(
            hintText: "Enter visit notes...",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Feedback Submitted!")));
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}

// ================= TAB 5: MY SALES (Fixed Button) =================
class _MySalesTab extends StatefulWidget {
  const _MySalesTab();

  @override
  State<_MySalesTab> createState() => _MySalesTabState();
}

class _MySalesTabState extends State<_MySalesTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("My Sales")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSaleDialog,
        backgroundColor: AppTheme.secondaryCyan,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          NeonGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Revenue",
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text("EGP 9,225",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryPurple)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.bar_chart,
                        color: AppTheme.primaryPurple),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text("Recent Transactions",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.onSurface)),
          const SizedBox(height: 16),
          ...MockData.sales.map((sale) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeonGlassCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppTheme.success.withOpacity(0.1),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.attach_money,
                          color: AppTheme.success),
                    ),
                    title: Text(sale.product,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${sale.doctorName} • ${sale.units} units"),
                    trailing: Text("EGP ${sale.amount.toInt()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                            fontSize: 16)),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void _showAddSaleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Record New Sale"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
                decoration: InputDecoration(labelText: "Product Name")),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: "Units Sold"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: "Total Amount (EGP)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sale Recorded Successfully!")));
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}
