import 'package:flutter/material.dart';

class Employee {
  final String id;
  String name;
  String jobTitle;
  String department;
  DateTime hireDate;
  String status; // 'In Progress', 'Completed', 'Archived'

  Employee({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.department,
    required this.hireDate,
    this.status = 'In Progress',
  });
}

class OnboardingTask {
  final String id;
  final String employeeId;
  final String title;
  final String description;
  final int relativeDueDays;
  final String department;
  final String? documentLink;
  bool isCompleted;
  String? completionNote;
  DateTime? completedAt;

  OnboardingTask({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.description,
    required this.relativeDueDays,
    required this.department,
    this.documentLink,
    this.isCompleted = false,
    this.completionNote,
    this.completedAt,
  });

  bool isOverdue(DateTime hireDate) {
    if (isCompleted) return false;
    final dueDate = hireDate.add(Duration(days: relativeDueDays));
    return DateTime.now().isAfter(dueDate);
  }
}

class ActivityLogItem {
  final String id;
  final String actor;
  final String action;
  final String details;
  final DateTime timestamp;

  ActivityLogItem({
    required this.id,
    required this.actor,
    required this.action,
    required this.details,
    required this.timestamp,
  });
}

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal() {
    _seedData();
  }

  final List<Employee> _employees = [];
  final List<OnboardingTask> _tasks = [];
  final List<ActivityLogItem> _activityLogs = [];
  String _selectedDepartmentFilter = 'All';

  List<Employee> get employees => _employees;
  List<OnboardingTask> get tasks => _tasks;
  List<ActivityLogItem> get activityLogs => List.unmodifiable(_activityLogs);
  String get selectedDepartmentFilter => _selectedDepartmentFilter;

  void setDepartmentFilter(String dept) {
    _selectedDepartmentFilter = dept;
    notifyListeners();
  }

  void logActivity(String action, String details, {String actor = 'Sarah Johnson'}) {
    _activityLogs.insert(
      0,
      ActivityLogItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        actor: actor,
        action: action,
        details: details,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void completeTask(String taskId, String note) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      _tasks[idx].isCompleted = true;
      _tasks[idx].completionNote = note;
      _tasks[idx].completedAt = DateTime.now();
      
      final emp = _employees.firstWhere((e) => e.id == _tasks[idx].employeeId);
      logActivity(
        'Task Completed',
        'Task "${_tasks[idx].title}" marked complete for ${emp.name}. Note: "$note"',
      );
      _checkAndUpdateEmployeeStatus(emp.id);
      notifyListeners();
    }
  }

  void archiveEmployee(String employeeId) {
    final idx = _employees.indexWhere((e) => e.id == employeeId);
    if (idx != -1) {
      _employees[idx].status = 'Archived';
      logActivity('Employee Archived', '${_employees[idx].name} moved to Archived status.');
      notifyListeners();
    }
  }

  void _checkAndUpdateEmployeeStatus(String employeeId) {
    final empTasks = _tasks.where((t) => t.employeeId == employeeId).toList();
    if (empTasks.isNotEmpty && empTasks.every((t) => t.isCompleted)) {
      final idx = _employees.indexWhere((e) => e.id == employeeId);
      if (idx != -1 && _employees[idx].status != 'Archived') {
        _employees[idx].status = 'Completed';
      }
    }
  }

  void _seedData() {
    final emp1 = Employee(
      id: 'e1',
      name: 'Alex Morgan',
      jobTitle: 'Software Engineer',
      department: 'Engineering',
      hireDate: DateTime.now().subtract(const Duration(days: 5)),
    );
    final emp2 = Employee(
      id: 'e2',
      name: 'Jordan Lee',
      jobTitle: 'Marketing Specialist',
      department: 'Marketing',
      hireDate: DateTime.now().subtract(const Duration(days: 2)),
    );

    _employees.addAll([emp1, emp2]);

    _tasks.addAll([
      OnboardingTask(
        id: 't1',
        employeeId: 'e1',
        title: 'Submit Tax & Payroll Forms',
        description: 'Complete tax documentation on portal.',
        relativeDueDays: 2, // Overdue relative to hire date
        department: 'Engineering',
        documentLink: 'https://internal.portal/tax',
      ),
      OnboardingTask(
        id: 't2',
        employeeId: 'e1',
        title: 'Setup Development Environment',
        description: 'Install IDE, clone repos, setup SSH key.',
        relativeDueDays: 7,
        department: 'Engineering',
      ),
      OnboardingTask(
        id: 't3',
        employeeId: 'e2',
        title: 'Brand Orientation Meeting',
        description: 'Attend sync with Marketing Lead.',
        relativeDueDays: 3,
        department: 'Marketing',
      ),
    ]);

    logActivity('System Startup', 'App initialized with default seed state.');
  }
}