import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final List<EmployeeDirectoryItem> _employees = [
    EmployeeDirectoryItem(
      name: 'Alex Morgan',
      role: 'Senior Frontend Engineer',
      department: 'Engineering',
      progress: 82,
      status: 'In Progress',
      dueToday: 2,
      avatar: 'A',
    ),
    EmployeeDirectoryItem(
      name: 'Jamie Lee',
      role: 'Brand Strategist',
      department: 'Marketing',
      progress: 41,
      status: 'At Risk',
      dueToday: 4,
      avatar: 'J',
    ),
    EmployeeDirectoryItem(
      name: 'Taylor Smith',
      role: 'Account Executive',
      department: 'Sales',
      progress: 100,
      status: 'Completed',
      dueToday: 0,
      avatar: 'T',
    ),
    EmployeeDirectoryItem(
      name: 'Jordan Kim',
      role: 'People Operations Partner',
      department: 'HR',
      progress: 64,
      status: 'In Progress',
      dueToday: 1,
      avatar: 'J',
    ),
    EmployeeDirectoryItem(
      name: 'Casey Brown',
      role: 'Support Specialist',
      department: 'Engineering',
      progress: 28,
      status: 'At Risk',
      dueToday: 3,
      avatar: 'C',
    ),
  ];

  String _selectedFilter = 'All';

  List<EmployeeDirectoryItem> get _filteredEmployees {
    if (_selectedFilter == 'All') {
      return _employees;
    }

    return _employees
        .where((employee) => employee.status == _selectedFilter)
        .toList();
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
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['All', 'In Progress', 'At Risk', 'Completed']
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
                    child: _EmployeeCard(employee: employee),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeDirectoryItem employee;

  const _EmployeeCard({required this.employee});

  Color get _statusColor {
    switch (employee.status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'At Risk':
        return const Color(0xFFF59E0B);
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('View profile'),
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeDirectoryItem {
  final String name;
  final String role;
  final String department;
  final int progress;
  final String status;
  final int dueToday;
  final String avatar;

  EmployeeDirectoryItem({
    required this.name,
    required this.role,
    required this.department,
    required this.progress,
    required this.status,
    required this.dueToday,
    required this.avatar,
  });
}
