import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../data/dummy_data.dart';
import '../main.dart'; // For ThemeHelper

class ManagerAnalyticsScreen extends StatefulWidget {
  const ManagerAnalyticsScreen({super.key});

  @override
  State<ManagerAnalyticsScreen> createState() => _ManagerAnalyticsScreenState();
}

class _ManagerAnalyticsScreenState extends State<ManagerAnalyticsScreen> {
  final List<SalesRep> _reps = dummySalesReps;
  final TextEditingController _searchController = TextEditingController();

  // Solid colors for avatars
  final List<Color> _avatarColors = [
    const Color(0xFF5B8DEF), // Blue
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFF10B981), // Green
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Manager Portal',
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTaskDialog,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppTheme.primaryPurple, AppTheme.secondaryPink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search Bar (Video: 0:27)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FadeInDown(
              child: GlassContainer(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search reps...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _reps.length,
              itemBuilder: (context, index) {
                final rep = _reps[index];
                return FadeInUp(
                  delay: Duration(milliseconds: 100 * index),
                  child: GestureDetector(
                    onTap: () => _showRepDetails(rep, index),
                    child: _buildRepCard(rep, index, isDark),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepCard(SalesRep rep, int index, bool isDark) {
    bool hasPending = rep.status.contains('Pending');
    Color statusColor = hasPending ? Colors.red : AppTheme.success;

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
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _avatarColors[index % _avatarColors.length],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rep.name.substring(0, 1),
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rep.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${rep.code} • ${rep.territory}', // Video: REP001, Cairo North
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: statusColor),
                const SizedBox(width: 8),
                Text(
                  rep.status,
                  style: TextStyle(
                    color: statusColor, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 12
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRepDetails(SalesRep rep, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, color: Colors.grey[600],),
              const SizedBox(height: 16),
              // Rep Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                     CircleAvatar(
                      radius: 30,
                      backgroundColor: _avatarColors[index % _avatarColors.length],
                      child: Text(rep.name[0], style: const TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rep.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(rep.territory, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const TabBar(
                indicatorColor: AppTheme.secondaryPink,
                labelColor: AppTheme.secondaryPink,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "All Tasks"),
                  Tab(text: "Pending"),
                  Tab(text: "Completed"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTaskList(repTasks),
                    _buildTaskList(repTasks.where((t) => !t.isCompleted).toList()),
                    _buildTaskList(repTasks.where((t) => t.isCompleted).toList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildTaskList(List<Task> tasks) {
    final isDark = ThemeHelper.isDarkMode(context);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: task.priority == 'High' 
                      ? Colors.red.withValues(alpha: 0.1) 
                      : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assignment, 
                  color: task.priority == 'High' ? Colors.red : Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Pending', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateTaskDialog() {
    // Keep existing dialog or simpler one
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign New Task'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Task Title...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Assign')),
        ],
      ),
    );
  }
}
