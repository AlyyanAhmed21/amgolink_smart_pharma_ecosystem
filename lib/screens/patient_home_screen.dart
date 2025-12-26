import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_glass_card.dart';
import '../main.dart'; // For ThemeHelper

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- REALISTIC STATE DATA ---

  // 1. Reminders Data
  List<Map<String, dynamic>> schedule = [
    {
      'id': 1,
      'name': 'CardioMax',
      'dose': '10mg',
      'caretaker': false,
      'times': [
        {'label': '8:00 AM', 'taken': false},
        {'label': '8:00 PM', 'taken': false}
      ]
    },
    {
      'id': 2,
      'name': 'DiabetoCare',
      'dose': '500mg',
      'caretaker': true,
      'times': [
        {'label': '9:00 AM', 'taken': true}, // Pre-marked as taken for demo
        {'label': '9:00 PM', 'taken': false}
      ]
    },
  ];

  // 2. Next Doses Data
  List<Map<String, dynamic>> nextDoses = [
    {'name': 'CardioMax 10mg', 'time': 'In 45 minutes', 'checked': true},
    {
      'name': 'DiabetoCare 500mg',
      'time': 'In 1 hour 45 minutes',
      'checked': false
    },
  ];

  // 3. Medical Database (For "Learn More")
  final Map<String, Map<String, dynamic>> medicalData = {
    "Hypertension": {
      "overview":
          "High blood pressure is a common condition where the long-term force of the blood against your artery walls is high enough that it may eventually cause health problems.",
      "simple":
          "Think of your blood vessels like garden hoses. When pressure is too high, it can damage the hoses over time.",
      "symptoms": [
        "Severe headaches",
        "Nosebleed",
        "Fatigue or confusion",
        "Vision problems",
        "Chest pain"
      ],
      "treatment": [
        "Healthy diet with less salt",
        "Regular physical activity",
        "Maintaining a healthy weight",
        "Limiting alcohol",
        "Medication (ACE inhibitors)"
      ]
    },
    "Type 2 Diabetes": {
      "overview":
          "A chronic condition that affects the way your body processes blood sugar (glucose).",
      "simple":
          "Your body has trouble using sugar properly, like a lock that doesn't work well with its key.",
      "symptoms": [
        "Increased thirst",
        "Frequent urination",
        "Increased hunger",
        "Unintended weight loss",
        "Fatigue"
      ],
      "treatment": [
        "Healthy eating",
        "Regular exercise",
        "Weight loss",
        "Diabetes medication or insulin therapy",
        "Blood sugar monitoring"
      ]
    },
    "Asthma": {
      "overview":
          "A condition in which your airways narrow and swell and may produce extra mucus.",
      "simple":
          "It's like trying to breathe through a straw that keeps getting pinched shut.",
      "symptoms": [
        "Shortness of breath",
        "Chest tightness or pain",
        "Wheezing when exhaling",
        "Trouble sleeping caused by shortness of breath"
      ],
      "treatment": [
        "Inhaled corticosteroids",
        "Leukotriene modifiers",
        "Combination inhalers",
        "Theophylline"
      ]
    }
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AmgoLink',
                style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold)),
            Text('Patient Portal',
                style: TextStyle(
                    fontSize: 14, color: theme.onSurface.withOpacity(0.6))),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                color: AppTheme.primaryPurple),
            onPressed: () => ThemeHelper.toggleTheme(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- FIXED TAB BAR (Segmented Control Style) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Container(
              height: 40, // Sleeker height
              decoration: BoxDecoration(
                color:
                    isDark ? Colors.white.withOpacity(0.08) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize:
                    TabBarIndicatorSize.tab, // Fills the slot completely
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.all(4), // Creates the "Floating" look
                indicator: BoxDecoration(
                    gradient: AppTheme.neonGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ]),
                labelColor: Colors.white,
                unselectedLabelColor:
                    isDark ? Colors.grey[400] : Colors.grey[600],
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                tabs: const [
                  Tab(text: "Reminders"),
                  Tab(text: "Treatment"),
                  Tab(text: "Education"),
                  Tab(text: "Data"),
                ],
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRemindersTab(isDark, theme),
                _buildTreatmentTab(isDark, theme),
                _buildEducationTab(isDark, theme),
                _buildDataTab(isDark, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 1: REMINDERS =================
  Widget _buildRemindersTab(bool isDark, ColorScheme theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_filled,
                    color: AppTheme.primaryPurple),
                const SizedBox(width: 8),
                Text("Today's Schedule",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.onSurface)),
              ],
            ),
            IconButton(
              onPressed: _showAddMedicineDialog,
              icon: const Icon(Icons.add_circle,
                  color: AppTheme.primaryPurple, size: 28),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Dynamic Schedule List
        ...schedule.map((med) => FadeInUp(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeonGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(med['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: theme.onSurface)),
                              Text(med['dose'],
                                  style: TextStyle(
                                      color: AppTheme.primaryPurple,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: Colors.red[300], size: 20),
                            onPressed: () {
                              setState(() {
                                schedule.removeWhere(
                                    (item) => item['id'] == med['id']);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Time Pills
                      Row(
                        children:
                            (med['times'] as List).map<Widget>((timeSlot) {
                          bool isTaken = timeSlot['taken'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                timeSlot['taken'] = !timeSlot['taken'];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isTaken
                                    ? AppTheme.primaryPurple
                                    : AppTheme.primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppTheme.primaryPurple
                                        .withOpacity(0.3)),
                                boxShadow: isTaken
                                    ? AppTheme.neonGlow(
                                        color: AppTheme.primaryPurple)
                                    : null,
                              ),
                              child: Text(
                                timeSlot['label'],
                                style: TextStyle(
                                    color: isTaken
                                        ? Colors.white
                                        : AppTheme.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(Icons.person_outline,
                                size: 16,
                                color: theme.onSurface.withOpacity(0.6)),
                            const SizedBox(width: 4),
                            Text("Caretaker alerts",
                                style: TextStyle(
                                    color: theme.onSurface.withOpacity(0.6)))
                          ]),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: med['caretaker'],
                              onChanged: (v) =>
                                  setState(() => med['caretaker'] = v),
                              activeColor: AppTheme.success,
                              inactiveTrackColor:
                                  isDark ? Colors.grey[800] : Colors.grey[300],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),

        const SizedBox(height: 24),
        Text("Next Doses",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.primaryPink)),
        const SizedBox(height: 12),

        // Next Doses List
        ...nextDoses.map((dose) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: NeonGlassCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dose['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.onSurface)),
                        Text(dose['time'],
                            style: TextStyle(
                                fontSize: 12,
                                color: theme.onSurface.withOpacity(0.6))),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          dose['checked'] = !dose['checked'];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: dose['checked']
                                  ? AppTheme.success
                                  : Colors.grey,
                              width: 2),
                          color: dose['checked']
                              ? AppTheme.success
                              : Colors.transparent,
                        ),
                        child: Icon(Icons.check,
                            size: 16,
                            color: dose['checked']
                                ? Colors.white
                                : Colors.transparent),
                      ),
                    )
                  ],
                ),
              ),
            )),

        const SizedBox(height: 24),
        // Cycle Button
        FadeInUp(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Text("Cycle-based Reminders",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("For chemotherapy and oncology treatments",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppTheme.primaryPurple.withOpacity(0.2),
                        AppTheme.primaryPurple.withOpacity(0.1)
                      ]),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.primaryPurple.withOpacity(0.3))),
                  child: TextButton.icon(
                    onPressed: _showCycleDialog,
                    icon: const Icon(Icons.sync, color: AppTheme.primaryPurple),
                    label: const Text("+ Set up treatment cycle",
                        style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  // ================= TAB 2: TREATMENT =================
  Widget _buildTreatmentTab(bool isDark, ColorScheme theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("Your Medications",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.onSurface)),
        const SizedBox(height: 12),

        // Medication Info Card
        NeonGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("DiabetoCare",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppTheme.primaryPurple)),
              const SizedBox(height: 8),
              Text(
                "Patient-friendly explanation: This medicine helps manage your condition by regulating important body functions.",
                style: TextStyle(
                    color: theme.onSurface.withOpacity(0.7), height: 1.5),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _showDiseaseDetails("Type 2 Diabetes"),
                child: const Text("Learn more",
                    style: TextStyle(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Side Effects (Common)
        Text("Side Effect Management",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.primaryPink)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(isDark ? 0.1 : 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Common Side Effects",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: theme.onSurface)),
              const SizedBox(height: 8),
              _bulletPoint("Mild headache - drink plenty of water", theme),
              _bulletPoint("Nausea - take with food", theme),
              _bulletPoint("Drowsiness - avoid driving", theme),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Side Effects (Serious)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(isDark ? 0.1 : 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Serious Side Effects",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red[400])),
              const SizedBox(height: 4),
              Text("Contact doctor immediately if you experience:",
                  style: TextStyle(fontSize: 12, color: Colors.red[300])),
              const SizedBox(height: 8),
              _bulletPoint("Severe allergic reaction", theme),
              _bulletPoint("Difficulty breathing", theme),
              _bulletPoint("Chest pain", theme),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Text("Emergency Contacts",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.onSurface)),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Calling 911..."))),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFF1744), Color(0xFFD50000)]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: const Center(
                child: Text("🚨 Emergency Hotline: 911",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))),
          ),
        ),
        const SizedBox(height: 12),
        _contactButton(Icons.call, "Your Doctor: (555) 123-4567",
            AppTheme.primaryPurple, theme),
        const SizedBox(height: 8),
        _contactButton(Icons.local_hospital, "Nearest Hospital: City General",
            AppTheme.primaryPink, theme),
      ],
    );
  }

  // ================= TAB 3: EDUCATION =================
  Widget _buildEducationTab(bool isDark, ColorScheme theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Intro Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppTheme.primaryPurple.withOpacity(0.2),
              AppTheme.secondaryCyan.withOpacity(0.2)
            ]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.menu_book,
                  color: AppTheme.primaryPurple, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Patient Education",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: theme.onSurface)),
                    Text("Learn about diseases & treatments",
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.onSurface.withOpacity(0.7))),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Disease Cards
        _eduCard(
            isDark,
            "Hypertension",
            "High blood pressure is a common condition...",
            Icons.favorite,
            Colors.red,
            theme),
        _eduCard(
            isDark,
            "Type 2 Diabetes",
            "A chronic condition affecting blood sugar...",
            FontAwesomeIcons.dna,
            Colors.blue,
            theme),
        _eduCard(
            isDark,
            "Asthma",
            "A respiratory condition marked by spasms...",
            FontAwesomeIcons.lungs,
            Colors.orange,
            theme),
      ],
    );
  }

  // ================= TAB 4: DATA =================
  Widget _buildDataTab(bool isDark, ColorScheme theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("Disease Statistics",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.primaryPurple)),
        Text("Market data and trends",
            style: TextStyle(
                fontSize: 12, color: theme.onSurface.withOpacity(0.6))),
        const SizedBox(height: 20),
        NeonGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8),
                Text("Hypertension",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.onSurface))
              ]),
              const SizedBox(height: 16),
              Text("📍 High Incidence Areas",
                  style: TextStyle(
                      fontSize: 12, color: theme.onSurface.withOpacity(0.6))),
              const SizedBox(height: 12),
              _dataRow("Cairo North", 0.28, Colors.red, theme),
              _dataRow("Alexandria", 0.24, Colors.purple, theme),
              _dataRow("Giza West", 0.19, Colors.orange, theme),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _trendBox("Prescribing Trend", "+15%", Colors.green, isDark),
                  _trendBox("Product Demand", "85%", Colors.blue, isDark),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        NeonGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(FontAwesomeIcons.dna, color: Colors.blue),
                SizedBox(width: 8),
                Text("Type 2 Diabetes",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.onSurface))
              ]),
              const SizedBox(height: 16),
              Text("📍 High Incidence Areas",
                  style: TextStyle(
                      fontSize: 12, color: theme.onSurface.withOpacity(0.6))),
              const SizedBox(height: 12),
              _dataRow("Cairo East", 0.32, Colors.blue, theme),
              _dataRow("Giza West", 0.26, Colors.purple, theme),
              _dataRow("Alexandria", 0.22, Colors.teal, theme),
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  Widget _bulletPoint(String text, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(color: theme.onSurface.withOpacity(0.5))),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      color: theme.onSurface.withOpacity(0.8), fontSize: 13))),
        ],
      ),
    );
  }

  Widget _contactButton(
      IconData icon, String text, Color color, ColorScheme theme) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _eduCard(bool isDark, String title, String sub, IconData icon,
      Color color, ColorScheme theme) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showDiseaseDetails(title),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: theme.onSurface)),
                            Text(sub,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: theme.onSurface.withOpacity(0.6))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Learn more →",
                          style: TextStyle(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Icon(Icons.share,
                          size: 18, color: theme.onSurface.withOpacity(0.4)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataRow(String label, double pct, Color color, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 13, color: theme.onSurface)),
              Text("${(pct * 100).toInt()}%",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.onSurface)),
            ],
          ),
          const SizedBox(height: 6),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: pct,
            backgroundColor: theme.onSurface.withOpacity(0.1),
            progressColor: color,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
            animation: true,
          ),
        ],
      ),
    );
  }

  Widget _trendBox(String label, String val, Color color, bool isDark) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 8),
          Text(val,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }

  // --- DIALOGS & BOTTOM SHEETS ---

  void _showAddMedicineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Add Medicine"),
        content: const TextField(
          decoration: InputDecoration(
              hintText: "Medicine Name...", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Medicine Added!")));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white),
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  void _showCycleDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Oncology Treatment Cycle",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(
                decoration: InputDecoration(
                    labelText: "Days On", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(
                decoration: InputDecoration(
                    labelText: "Days Off", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text("Save Cycle",
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDiseaseDetails(String diseaseName) {
    final data = medicalData[diseaseName] ?? {};
    final theme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, color: Colors.grey[400]),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(diseaseName,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.primary)),
                  const SizedBox(height: 24),
                  _detailSection("📋 Overview", data['overview'], theme),
                  _detailSection(
                      "💡 Simple Explanation", data['simple'], theme),
                  const Text("🩺 Symptoms",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (data['symptoms'] as List)
                        .map<Widget>((s) => Chip(
                              label: Text(s),
                              backgroundColor: theme.primary.withOpacity(0.1),
                              labelStyle: TextStyle(color: theme.primary),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _detailSection("💊 Treatment",
                      (data['treatment'] as List).join("\n• "), theme),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text("Share PDF with Family",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailSection(String title, String content, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.onSurface)),
          const SizedBox(height: 8),
          Text(content,
              style: TextStyle(
                  fontSize: 16,
                  color: theme.onSurface.withOpacity(0.7),
                  height: 1.5)),
        ],
      ),
    );
  }
}
