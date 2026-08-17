import 'package:flutter/material.dart';

import 'employee_profile_panel.dart';
import 'task_details_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  EmployeeData? _selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System Maintenance Banner
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD), // Light yellow
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFFE69C)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info,
                        color: Color(0xFF856404),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'System Maintenance on Sunday, 2:00 AM - 4:00 AM UTC. Some features may be unavailable.',
                          style: TextStyle(
                            color: const Color(0xFF856404),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFF856404),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Stats Cards Row
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    StatCard(
                      title: 'Total New Hires',
                      value: '24',
                      subtitle: 'Active',
                      icon: Icons.person_add,
                      color: const Color(0xFF6B46C1),
                    ),
                    StatCard(
                      title: 'Completed Onboarding',
                      value: '7',
                      subtitle: 'This Month',
                      icon: Icons.check_circle,
                      color: const Color(0xFF10B981),
                    ),
                    StatCard(
                      title: 'Average Progress',
                      value: '68%',
                      subtitle: 'Across all',
                      icon: Icons.trending_up,
                      color: const Color(0xFF3B82F6),
                    ),
                    StatCard(
                      title: 'Overdue Tasks',
                      value: '5',
                      subtitle: 'Require attention',
                      icon: Icons.schedule,
                      color: const Color(0xFFEF4444),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Employee Table Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 700;

                            if (isCompact) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'All Departments',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search employees...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.grey[400],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 12,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Departments',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search employees...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey[400],
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      // Employee List
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Employee')),
                            DataColumn(label: Text('Department')),
                            DataColumn(label: Text('Hire Date')),
                            DataColumn(label: Text('Progress')),
                            DataColumn(label: Text('Overdue')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: _generateEmployeeRows(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Task Details Section
                TaskDetailsSection(selectedEmployee: _selectedEmployee),
              ],
            ),
          ),
        ),
        // Employee Profile Panel
        if (_selectedEmployee != null)
          EmployeeProfilePanel(
            employee: _selectedEmployee!,
            onClose: () {
              setState(() => _selectedEmployee = null);
            },
          ),
      ],
    );
  }

  List<DataRow> _generateEmployeeRows(BuildContext context) {
    final employees = [
      EmployeeData(
        name: 'Alex Morgan',
        department: 'Engineering',
        hireDate: 'May 01, 2024',
        progress: 80,
        overdueTasks: 1,
        avatar: 'A',
      ),
      EmployeeData(
        name: 'Jamie Lee',
        department: 'Marketing',
        hireDate: 'May 05, 2024',
        progress: 40,
        overdueTasks: 2,
        avatar: 'J',
      ),
      EmployeeData(
        name: 'Taylor Smith',
        department: 'Sales',
        hireDate: 'May 10, 2024',
        progress: 100,
        overdueTasks: 0,
        avatar: 'T',
      ),
      EmployeeData(
        name: 'Jordan Kim',
        department: 'HR',
        hireDate: 'May 12, 2024',
        progress: 60,
        overdueTasks: 1,
        avatar: 'J',
      ),
      EmployeeData(
        name: 'Casey Brown',
        department: 'Engineering',
        hireDate: 'May 15, 2024',
        progress: 20,
        overdueTasks: 3,
        avatar: 'C',
      ),
    ];

    return employees
        .map(
          (employee) => DataRow(
            onSelectChanged: (selected) {
              if (selected ?? false) {
                setState(() => _selectedEmployee = employee);
              }
            },
            cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF6B46C1),
                      child: Text(
                        employee.avatar,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          employee.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    employee.department,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              DataCell(Text(employee.hireDate)),
              DataCell(
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: employee.progress / 100,
                          minHeight: 6,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            employee.progress == 100
                                ? Colors.green
                                : const Color(0xFF6B46C1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${employee.progress}%',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                Text(
                  employee.overdueTasks.toString(),
                  style: TextStyle(
                    color: employee.overdueTasks > 0
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B46C1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Nudge',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }
}

// Stat Card Widget
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 1200
        ? 250.0
        : screenWidth > 800
        ? 220.0
        : (screenWidth - 72).clamp(140.0, 220.0);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Employee Data Model
class EmployeeData {
  final String name;
  final String department;
  final String hireDate;
  final int progress;
  final int overdueTasks;
  final String avatar;

  EmployeeData({
    required this.name,
    required this.department,
    required this.hireDate,
    required this.progress,
    required this.overdueTasks,
    required this.avatar,
  });
}
