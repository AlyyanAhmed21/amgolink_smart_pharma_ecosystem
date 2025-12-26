import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_glass_card.dart';
import '../main.dart'; // For ThemeHelper

// --- LOCAL DATA MODELS FOR INTERACTIVITY ---
class DemoRep {
  final String id;
  final String name;
  final String code;
  final String area;
  final int badgeCount;
  final Color avatarColor;

  DemoRep(this.id, this.name, this.code, this.area, this.badgeCount,
      this.avatarColor);
}

class DemoTask {
  String id;
  String repId;
  String title;
  String subtitle;
  String date;
  String status; // 'pending', 'in-progress', 'completed'
  String priority;

  DemoTask(this.id, this.repId, this.title, this.subtitle, this.date,
      this.status, this.priority);
}

class ManagerAnalyticsScreen extends StatefulWidget {
  const ManagerAnalyticsScreen({super.key});

  @override
  State<ManagerAnalyticsScreen> createState() => _ManagerAnalyticsScreenState();
}

class _ManagerAnalyticsScreenState extends State<ManagerAnalyticsScreen> {
  // 1. Local State for Interactivity
  final List<DemoRep> _reps = [
    DemoRep('1', 'Ahmed Hassan', 'REP001', 'Cairo North', 5, Colors.blue),
    DemoRep('2', 'Fatima Mohamed', 'REP002', 'Alexandria', 3, Colors.purple),
    DemoRep('3', 'Omar Khaled', 'REP003', 'Giza West', 7, Colors.orange),
    DemoRep('4', 'Sara Ali', 'REP004', 'Cairo East', 2, Colors.pink),
  ];

  final List<DemoTask> _tasks = [
    DemoTask('101', '1', 'Visit Dr. Ibrahim Clinic',
        'Present new cardiology products', '2025-12-20', 'pending', 'High'),
    DemoTask('102', '1', 'Follow up with City Hospital',
        'Check on last month order', '2025-12-18', 'in-progress', 'Medium'),
    DemoTask('103', '2', 'Deliver Samples', 'Wellness Clinic', '2025-12-19',
        'completed', 'Low'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Manager Portal',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                color: AppTheme.primaryPurple),
            onPressed: () => ThemeHelper.toggleTheme(context),
          ),
          // Top Corner Icon from Screenshot
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.neonGradient,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.attach_money, color: Colors.white, size: 20),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search reps...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Sales Representatives",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.onSurface)),
          ),

          // Rep List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reps.length,
              itemBuilder: (context, index) {
                final rep = _reps[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildRepCard(rep, isDark, theme),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepCard(DemoRep rep, bool isDark, ColorScheme theme) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RepDetailScreen(rep: rep, allTasks: _tasks))),
      child: NeonGlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar (Hidden in screenshot, but name is bold) - Keeping clean layout
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rep.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.onSurface)),
                  const SizedBox(height: 4),
                  Text("Code: ${rep.code}",
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.onSurface.withOpacity(0.6))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: AppTheme.primaryPink),
                      const SizedBox(width: 4),
                      Text(rep.area,
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.onSurface.withOpacity(0.8))),
                    ],
                  )
                ],
              ),
            ),
            // Badge
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppTheme.primaryPink,
                shape: BoxShape.circle,
              ),
              child: Text(
                rep.badgeCount.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Add Task Logic ---
  void _showAddTaskDialog() {
    String title = "";
    String subtitle = "";
    String selectedRepId = _reps[0].id;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Assign Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedRepId,
              items: _reps
                  .map(
                      (r) => DropdownMenuItem(value: r.id, child: Text(r.name)))
                  .toList(),
              onChanged: (v) => selectedRepId = v!,
              decoration: const InputDecoration(labelText: "Select Rep"),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Task Title"),
              onChanged: (v) => title = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (v) => subtitle = v,
            ),
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
                  _tasks.insert(
                      0,
                      DemoTask(
                          DateTime.now().toString(),
                          selectedRepId,
                          title,
                          subtitle,
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          'pending',
                          'High'));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task Assigned!")));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white),
            child: const Text("Assign"),
          )
        ],
      ),
    );
  }
}

// ==========================================
// SUB-SCREEN: REP DETAIL (Screenshot 2 & 3)
// ==========================================

class RepDetailScreen extends StatefulWidget {
  final DemoRep rep;
  final List<DemoTask> allTasks;

  const RepDetailScreen({super.key, required this.rep, required this.allTasks});

  @override
  State<RepDetailScreen> createState() => _RepDetailScreenState();
}

class _RepDetailScreenState extends State<RepDetailScreen> {
  String _filter = 'All'; // All, Pending, In progress, Completed

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final theme = Theme.of(context).colorScheme;

    // Filter Logic
    List<DemoTask> filteredTasks = widget.allTasks.where((t) {
      if (t.repId != widget.rep.id) return false;
      if (_filter == 'All') return true;
      if (_filter == 'Pending') return t.status == 'pending';
      if (_filter == 'In progress') return t.status == 'in-progress';
      if (_filter == 'Completed') return t.status == 'completed';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.rep.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(widget.rep.code,
                style: TextStyle(
                    fontSize: 12, color: theme.onSurface.withOpacity(0.6))),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              gradient: AppTheme.neonGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {}, // Add task specifically for this rep
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Custom Tab Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildPill('All'),
                const SizedBox(width: 8),
                _buildPill('Pending'),
                const SizedBox(width: 8),
                _buildPill('In progress'),
                const SizedBox(width: 8),
                _buildPill('Completed'),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _showTaskDetails(task),
                      child: NeonGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(task.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: theme.onSurface))),
                                _statusBadge(task.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(task.subtitle,
                                style: TextStyle(
                                    color: theme.onSurface.withOpacity(0.7),
                                    fontSize: 13)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 14, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text("Due: ${task.date}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.onSurface.withOpacity(0.6))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPill(String text) {
    bool isSelected = _filter == text;
    // Map text to color for selected state
    Color activeColor;
    if (text == 'Pending')
      activeColor = Colors.orange;
    else if (text == 'In progress')
      activeColor = Colors.blue;
    else if (text == 'Completed')
      activeColor = Colors.green;
    else
      activeColor = AppTheme.primaryPurple;

    return GestureDetector(
      onTap: () => setState(() => _filter = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: isSelected ? activeColor : Colors.transparent),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 13),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    String label;
    if (status == 'pending') {
      color = Colors.amber;
      label = 'pending';
    } else if (status == 'in-progress') {
      color = Colors.blue;
      label = 'in-progress';
    } else {
      color = Colors.green;
      label = 'completed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5))),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  // --- TASK DETAILS MODAL (Screenshot 3) ---
  void _showTaskDetails(DemoTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return StatefulBuilder(builder: (context, setModalState) {
            final theme = Theme.of(context).colorScheme;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(24),
                children: [
                  // Handle
                  Center(
                      child: Container(
                          width: 40,
                          height: 4,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.only(bottom: 20))),

                  // Header
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context)),
                      const Expanded(
                          child: Center(
                              child: Text("Task Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)))),
                      const SizedBox(width: 48), // Balance
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Task Info
                  NeonGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.onSurface)),
                        const SizedBox(height: 8),
                        Text(task.subtitle,
                            style: TextStyle(
                                color: AppTheme.primaryPurple, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Status Switcher
                  Text("Status",
                      style: TextStyle(
                          color: theme.onSurface.withOpacity(0.6),
                          fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.2))),
                    child: Row(
                      children: [
                        _statusOption(
                            "pending", Colors.purple, task, setModalState),
                        _statusOption(
                            "in-progress", Colors.blue, task, setModalState),
                        _statusOption(
                            "completed", Colors.green, task, setModalState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.lock_outline, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Text("Editable by Manager & Boss",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Fields
                  _detailField("Due Date", "📅 ${task.date}", theme),
                  _detailField("Notes", "Bring product samples", theme),
                  _detailField("Attachments", "No attachments", theme,
                      isAttachment: true),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _statusOption(
      String status, Color color, DemoTask task, StateSetter setModalState) {
    bool isSelected = task.status == status;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setModalState(() {
            setState(() {
              task.status = status;
            });
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [color, color.withOpacity(0.7)])
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _detailField(String label, String value, ColorScheme theme,
      {bool isAttachment = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: AppTheme.secondaryCyan, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (isAttachment)
                Icon(Icons.attach_file,
                    size: 16, color: theme.onSurface.withOpacity(0.6)),
              if (isAttachment) const SizedBox(width: 8),
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: theme.onSurface)),
            ],
          ),
        ],
      ),
    );
  }
}
