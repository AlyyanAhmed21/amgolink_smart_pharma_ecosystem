import 'package:flutter/material.dart';

// --- MODELS ---

class User {
  final String id;
  final String name;
  final String role;
  final String avatar;

  User(
      {required this.id,
      required this.name,
      required this.role,
      required this.avatar});
}

class Task {
  final String id;
  final String title;
  final String subtitle;
  final String priority; // High, Medium, Low
  final String dueDate;
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.priority,
      required this.dueDate,
      this.isCompleted = false});
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String address; // Added for compatibility
  final String phone; // Added for compatibility
  final String revenue; // Added for compatibility
  final String growth; // Added for compatibility
  final String time; // Added for compatibility
  final int visits;
  final String lastVisit;
  final int engagementScore; // 0-100
  final List<double> trends; // For the chart

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    this.address = '',
    this.phone = '',
    this.revenue = '',
    this.growth = '',
    this.time = '',
    required this.visits,
    required this.lastVisit,
    required this.engagementScore,
    required this.trends,
  });
}

class SaleRecord {
  final String id;
  final String date;
  final String product;
  final String doctorName;
  final double amount;
  final int units;

  SaleRecord(
      {required this.id,
      required this.date,
      required this.product,
      required this.doctorName,
      required this.amount,
      required this.units});
}

class Visit {
  final String id;
  final String doctorName;
  final String hospital;
  final String date;
  final String time;
  final String status; // Scheduled, Completed
  final int rating;

  Visit(
      {required this.id,
      required this.doctorName,
      required this.hospital,
      required this.date,
      required this.time,
      required this.status,
      this.rating = 0});
}

// Medicine Model (For Patient Screen)
class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String icon;
  bool isTaken;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.icon,
    this.isTaken = false,
  });
}

class SalesRep {
  final String id;
  final String code;
  final String name;
  final String territory;
  final String status;
  final int visitsCompleted;
  final int totalVisits;
  final double performance;

  SalesRep({
    required this.id,
    required this.code,
    required this.name,
    required this.territory,
    required this.status,
    required this.visitsCompleted,
    required this.totalVisits,
    required this.performance,
  });
}

// --- MOCK DATABASE ---

class MockData {
  // Current Logged In User (Demo)
  static final currentUser =
      User(id: 'u1', name: 'Ahmed Hassan', role: 'Sales Rep', avatar: 'AH');

  // Dashboard KPIs
  static const Map<String, String> kpis = {
    "Reps": "24",
    "Growth": "+18.5%",
    "Target": "92%",
    "Tasks": "156/200"
  };

  // Stock Data (Shared)
  static final Map<String, double> stock = {
    'Product A': 450,
    'Product B': 320,
    'Product C': 180,
    'Product D': 240,
  };

  // Tasks (Rep View)
  static final List<Task> tasks = [
    Task(
        id: 't1',
        title: 'Follow up with Dr. Smith',
        subtitle: 'City Hospital',
        priority: 'High',
        dueDate: 'Dec 3'),
    Task(
        id: 't2',
        title: 'Deliver samples',
        subtitle: 'Wellness Clinic',
        priority: 'Medium',
        dueDate: 'Dec 4'),
    Task(
        id: 't3',
        title: 'Schedule meeting',
        subtitle: 'Dr. Johnson',
        priority: 'High',
        dueDate: 'Dec 3'),
    Task(
        id: 't4',
        title: 'Territory report',
        subtitle: 'Admin',
        priority: 'Low',
        dueDate: 'Dec 5'),
  ];

  // Doctors List (Merged Data)
  static final List<Doctor> doctors = [
    Doctor(
        id: 'd1',
        name: 'Dr. Ahmed Ibrahim',
        specialty: 'Cardiologist',
        hospital: 'Cairo Clinic',
        visits: 24,
        lastVisit: 'Nov 28',
        engagementScore: 92,
        trends: [3, 4, 3.5, 5, 4.5, 6],
        revenue: 'EGP 180K',
        growth: '+12%'),
    Doctor(
        id: 'd2',
        name: 'Dr. Fatima Hassan',
        specialty: 'Endocrinologist',
        hospital: 'Alexandria Med',
        visits: 18,
        lastVisit: 'Nov 25',
        engagementScore: 78,
        trends: [2, 2.5, 3, 3, 3.5, 3.5],
        revenue: 'EGP 165K',
        growth: '+8%'),
    Doctor(
        id: 'd3',
        name: 'Dr. Sarah Mitchell',
        specialty: 'Cardiologist',
        hospital: 'City General',
        visits: 21,
        lastVisit: 'Nov 30',
        engagementScore: 85,
        trends: [4, 4.5, 5, 4, 5, 5.5],
        revenue: 'EGP 140K',
        growth: '+5%'),
    Doctor(
        id: 'd4',
        name: 'Dr. Michael Brown',
        specialty: 'Cardiologist',
        hospital: 'Heart Institute',
        visits: 28,
        lastVisit: 'Dec 01',
        engagementScore: 95,
        trends: [5, 5.5, 6, 6.5, 7, 7.5],
        revenue: 'EGP 120K',
        growth: '+4%'),
  ];

  // Visits
  static final List<Visit> visits = [
    Visit(
        id: 'v1',
        doctorName: 'Dr. Lisa Anderson',
        hospital: 'City General Hospital',
        date: '2025-12-03',
        time: '9:00 AM',
        status: 'Scheduled'),
    Visit(
        id: 'v2',
        doctorName: 'Dr. Robert Taylor',
        hospital: 'Prime Healthcare',
        date: '2025-12-03',
        time: '2:30 PM',
        status: 'Scheduled'),
    Visit(
        id: 'v3',
        doctorName: 'Dr. Sarah Mitchell',
        hospital: 'City General Hospital',
        date: '2025-12-02',
        time: '10:45 AM',
        status: 'Completed',
        rating: 5),
    Visit(
        id: 'v4',
        doctorName: 'Dr. James Wilson',
        hospital: 'Metro Medical Center',
        date: '2025-12-02',
        time: '12:00 PM',
        status: 'Completed',
        rating: 4),
  ];

  // Sales Ledger
  static final List<SaleRecord> sales = [
    SaleRecord(
        id: 's1',
        date: 'Today',
        product: 'CardioMax 10mg',
        doctorName: 'Dr. Ibrahim Clinic',
        amount: 2250,
        units: 50),
    SaleRecord(
        id: 's2',
        date: 'Today',
        product: 'DiabetoCare 500mg',
        doctorName: 'Dr. Fatima Medical',
        amount: 1950,
        units: 30),
    SaleRecord(
        id: 's3',
        date: 'Yesterday',
        product: 'RespiClear Inhaler',
        doctorName: 'City Hospital',
        amount: 3000,
        units: 25),
    SaleRecord(
        id: 's4',
        date: 'Yesterday',
        product: 'CardioMax 10mg',
        doctorName: 'Dr. Ahmed Hospital',
        amount: 1800,
        units: 40),
  ];

  // For Patient View
  static final List<Medicine> dummyMedicines = [
    Medicine(
        id: '1',
        name: 'CardioMax',
        dosage: '10mg',
        time: '8:00 AM',
        icon: '❤️',
        isTaken: true),
    Medicine(
        id: '2',
        name: 'CardioMax',
        dosage: '10mg',
        time: '8:00 PM',
        icon: '❤️',
        isTaken: false),
    Medicine(
        id: '3',
        name: 'DiabetoCare',
        dosage: '500mg',
        time: '9:00 PM',
        icon: '💊',
        isTaken: false),
  ];

  static const List<Map<String, dynamic>> diseases = [
    {"name": "Hypertension", "area": "Cairo North", "val": "28%"},
    {"name": "Type 2 Diabetes", "area": "Alexandria", "val": "24%"},
  ];

  // For Manager View (Backwards compatibility)
  static final List<SalesRep> dummySalesReps = [
    SalesRep(
        id: '1',
        code: 'REP001',
        name: 'Ahmed Hassan',
        territory: 'Cairo North',
        status: 'Pending Tasks',
        visitsCompleted: 156,
        totalVisits: 200,
        performance: 92.5),
    SalesRep(
        id: '2',
        code: 'REP002',
        name: 'Fatima Mohamed',
        territory: 'Alexandria',
        status: 'On Track',
        visitsCompleted: 180,
        totalVisits: 190,
        performance: 95.0),
  ];
}

// Aliases for compatibility with other files using old names
final List<Doctor> dummyDoctors = MockData.doctors;
final Map<String, double> stockData = MockData.stock;
final List<Task> repTasks = MockData.tasks;
final List<Medicine> dummyMedicines = MockData.dummyMedicines;
final List<SalesRep> dummySalesReps = MockData.dummySalesReps;
