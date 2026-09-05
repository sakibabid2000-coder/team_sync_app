import 'package:flutter/material.dart';

import 'add_employee_dialog.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  static const _departments = ['Engineering', 'Marketing', 'Sales', 'HR'];

  final List<EmployeeDirectoryItem> _employees = [
    EmployeeDirectoryItem(
      name: 'Alex Morgan',
      role: 'Senior Frontend Engineer',
      department: 'Engineering',
      hireDate: 'May 01, 2024',
      progress: 82,
      status: 'In Progress',
      dueToday: 2,
      avatar: 'A',
    ),
    EmployeeDirectoryItem(
      name: 'Jamie Lee',
      role: 'Brand Strategist',
      department: 'Marketing',
      hireDate: 'May 05, 2024',
      progress: 41,
      status: 'At Risk',
      dueToday: 4,
      avatar: 'J',
    ),
    EmployeeDirectoryItem(
      name: 'Taylor Smith',
      role: 'Account Executive',
      department: 'Sales',
      hireDate: 'May 10, 2024',
      progress: 100,
      status: 'Completed',
      dueToday: 0,
      avatar: 'T',
    ),
    EmployeeDirectoryItem(
      name: 'Jordan Kim',
      role: 'People Operations Partner',
      department: 'HR',
      hireDate: 'May 12, 2024',
      progress: 64,
      status: 'In Progress',
      dueToday: 1,
      avatar: 'J',
    ),
    EmployeeDirectoryItem(
      name: 'Casey Brown',
      role: 'Support Specialist',
      department: 'Engineering',
      hireDate: 'May 15, 2024',
      progress: 28,
      status: 'At Risk',
      dueToday: 3,
      avatar: 'C',
    ),
  ];

  String _selectedFilter = 'All';

  List<EmployeeDirectoryItem> get _filteredEmployees {
    if (_selectedFilter == 'All') {
      // Archived ("Onboarded") employees are hidden from the active pool by
      // default - pick the "Onboarded" filter to see them.
      return _employees.where((employee) => employee.status != 'Onboarded').toList();
    }

    return _employees
        .where((employee) => employee.status == _selectedFilter)
        .toList();
  }

  void _archiveEmployee(EmployeeDirectoryItem employee) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archive employee?'),
        content: Text(
          '${employee.name} will be moved to "Onboarded" and hidden from the active dashboard pool.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => employee.status = 'Onboarded');
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${employee.name} archived')),
              );
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _restoreEmployee(EmployeeDirectoryItem employee) {
    setState(() => employee.status = 'In Progress');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${employee.name} restored to active')));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 1200
        ? 320.0
        : screenWidth > 800
        ? 280.0
        : (screenWidth - 64).clamp(260.0, 320.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 640;
              final header = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Directory',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track each new hire across their onboarding journey.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              );
              final addButton = ElevatedButton.icon(
                onPressed: _showAddEmployeeDialog,
                icon: const Icon(Icons.person_add),
                label: const Text('Add Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B46C1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header,
                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: addButton),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: header),
                  const SizedBox(width: 16),
                  addButton,
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['All', 'In Progress', 'At Risk', 'Completed', 'Onboarded']
                .map(
                  (filter) => ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    selectedColor: const Color(0xFF6B46C1).withAlpha(26),
                    onSelected: (_) {
                      setState(() => _selectedFilter = filter);
                    },
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter
                          ? const Color(0xFF6B46C1)
                          : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: _selectedFilter == filter
                          ? const Color(0xFF6B46C1)
                          : Colors.grey[300]!,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: _filteredEmployees
                .map(
                  (employee) => SizedBox(
                    width: cardWidth,
                    child: _EmployeeCard(
                      employee: employee,
                      onViewProfile: () => _showProfile(employee),
                      onArchive: () => _archiveEmployee(employee),
                      onRestore: () => _restoreEmployee(employee),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showProfile(EmployeeDirectoryItem employee) {
    String role = employee.role;
    String department = employee.department;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(employee.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${employee.status} · ${employee.progress}% complete',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Hired: ${employee.hireDate}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: role,
                decoration: const InputDecoration(labelText: 'Job Title'),
                onChanged: (value) => role = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: department,
                decoration: const InputDecoration(labelText: 'Department'),
                items: _departments
                    .map(
                      (dept) => DropdownMenuItem(value: dept, child: Text(dept)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setDialogState(() => department = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  employee.role = role;
                  employee.department = department;
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated ${employee.name}\'s profile')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AddEmployeeDialog(
        departments: _departments,
        onEmployeeCreated: (employee) {
          setState(() => _employees.add(employee));
        },
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeDirectoryItem employee;
  final VoidCallback onViewProfile;
  final VoidCallback onArchive;
  final VoidCallback onRestore;

  const _EmployeeCard({
    required this.employee,
    required this.onViewProfile,
    required this.onArchive,
    required this.onRestore,
  });

  Color get _statusColor {
    switch (employee.status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'At Risk':
        return const Color(0xFFF59E0B);
      case 'Onboarded':
        return Colors.grey;
      default:
        return const Color(0xFF6B46C1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF6B46C1),
                child: Text(
                  employee.avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      employee.role,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hired: ${employee.hireDate}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                employee.department,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  employee.status,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Onboarding progress',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: employee.progress / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${employee.progress}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '${employee.dueToday} tasks due today',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewProfile,
                  child: const Text('View profile'),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  onSelected: (value) {
                    if (value == 'archive') {
                      onArchive();
                    } else if (value == 'restore') {
                      onRestore();
                    }
                  },
                  itemBuilder: (context) => [
                    if (employee.status == 'Onboarded')
                      const PopupMenuItem(
                        value: 'restore',
                        child: Text('Restore to active'),
                      )
                    else
                      const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive employee'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmployeeDirectoryItem {
  final String name;
  String role;
  String department;
  final String hireDate;
  final int progress;
  String status;
  final int dueToday;
  final String avatar;

  EmployeeDirectoryItem({
    required this.name,
    required this.role,
    required this.department,
    required this.hireDate,
    required this.progress,
    required this.status,
    required this.dueToday,
    required this.avatar,
  });
}
