// Dummy data for AmgoLink Demo matching Client Video
// Hardcoded data with EGP currency and specific Arabic names

import 'package:flutter/material.dart';

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

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String address;
  final String phone;
  final String time;
  final String revenue; // New for Boss View
  final String growth; // New for Boss View
  bool isVisited;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.address,
    required this.phone,
    required this.revenue,
    required this.growth,
    required this.time,
    this.isVisited = false,
  });
}

class SalesRep {
  final String id;
  final String code; // New: REP001
  final String name;
  final String territory;
  final String status; // New: Pending Tasks
  final int visitsCompleted;
  final int totalVisits; // Pending Tasks Count
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

class WeeklySales {
  final String week;
  final double sales;
  final double target;

  WeeklySales({
    required this.week,
    required this.sales,
    required this.target,
  });
}

class Task {
  final String title;
  final String priority; // High, Medium
  final bool isCompleted;

  Task({required this.title, required this.priority, this.isCompleted = false});
}

// ============ DUMMY DATA ============

// B. Patient Meds (Video: 0:05)
final List<Medicine> dummyMedicines = [
  Medicine(
    id: '1',
    name: 'CardioMax',
    dosage: '10mg',
    time: '8:00 AM',
    icon: '❤️',
    isTaken: true,
  ),
  Medicine(
    id: '2',
    name: 'CardioMax',
    dosage: '10mg',
    time: '8:00 PM',
    icon: '❤️',
    isTaken: false,
  ),
  Medicine(
    id: '3',
    name: 'DiabeticCare',
    dosage: '500mg',
    time: '9:00 PM',
    icon: '💊',
    isTaken: false,
  ),
];

// C. Doctor Performance (Video: 0:41) & Rep View
final List<Doctor> dummyDoctors = [
  Doctor(
    id: '1',
    name: 'Dr. Ahmed Ibrahim',
    specialty: 'Cardiologist',
    hospital: 'Cairo Clinic',
    address: 'Cairo North',
    phone: '+20 100 1234567',
    revenue: 'EGP 180K',
    growth: '+12%',
    time: '10:00 AM',
  ),
  Doctor(
    id: '2',
    name: 'Dr. Fatima Hassan',
    specialty: 'Endocrinologist',
    hospital: 'Alexandria Med Center',
    address: 'Alexandria',
    phone: '+20 100 7654321',
    revenue: 'EGP 165K',
    growth: '+8%',
    time: '11:30 AM',
  ),
  Doctor(
    id: '3',
    name: 'Dr. Sarah Mitchell',
    specialty: 'Cardiologist',
    hospital: 'Nasr City Hospital',
    address: 'Cairo North',
    phone: '+20 111 5551234',
    revenue: 'EGP 140K',
    growth: '+5%',
    time: '02:00 PM', // For Rep View
  ),
  Doctor(
    id: '4',
    name: 'Dr. Ibrahim Ali',
    specialty: 'Neurologist',
    hospital: 'Giza Specialized',
    address: 'Giza',
    phone: '+20 122 9876543',
    revenue: 'EGP 120K',
    growth: '+4%',
    time: '04:15 PM',
  ),
];

// A. Reps List (Video: 0:27)
final List<SalesRep> dummySalesReps = [
  SalesRep(
    id: '1',
    code: 'REP001',
    name: 'Ahmed Hassan',
    territory: 'Cairo North',
    status: 'Pending Tasks',
    visitsCompleted: 156, // Tasks Done
    totalVisits: 200,    // Total Goals
    performance: 92.5,
  ),
  SalesRep(
    id: '2',
    code: 'REP002',
    name: 'Fatima Mohamed',
    territory: 'Alexandria',
    status: 'On Track',
    visitsCompleted: 180,
    totalVisits: 190,
    performance: 95.0,
  ),
  SalesRep(
    id: '3',
    code: 'REP003',
    name: 'Mahmoud Ali',
    territory: 'Giza',
    status: 'Needs Review',
    visitsCompleted: 120,
    totalVisits: 180,
    performance: 75.5,
  ),
];

final List<WeeklySales> dummyWeeklySales = [
  WeeklySales(week: 'Jan', sales: 1.8, target: 2.0),
  WeeklySales(week: 'Feb', sales: 2.1, target: 2.0),
  WeeklySales(week: 'Mar', sales: 2.4, target: 2.2), // EGP 2.4M
  WeeklySales(week: 'Apr', sales: 2.3, target: 2.4),
];

// D. Stock Data (Video: 1:00)
final Map<String, double> stockData = {
  'Product A': 450,
  'Product B': 320,
};

final List<Task> repTasks = [
  Task(title: 'Follow up with Dr. Smith', priority: 'High'),
  Task(title: 'Deliver Samples to Clinic', priority: 'Medium'),
  Task(title: 'Update Patient Records', priority: 'Low'),
];

final List<String> regions = [
  'All Regions',
  'Cairo North',
  'Alexandria',
  'Giza',
  'Mansoura',
];
