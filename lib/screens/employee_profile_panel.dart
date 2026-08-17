import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class EmployeeProfilePanel extends StatelessWidget {
  final EmployeeData employee;
  final VoidCallback onClose;

  const EmployeeProfilePanel({
    super.key,
    required this.employee,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelWidth = constraints.maxWidth > 350
            ? 350.0
            : constraints.maxWidth;

        return Container(
          width: panelWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Onboarding Details',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFF6B46C1),
                              child: Text(
                                employee.avatar,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              employee.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              employee.department,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSection('Your Onboarding Progress', [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${employee.progress}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B46C1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: employee.progress / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              employee.progress == 100
                                  ? Colors.green
                                  : const Color(0xFF6B46C1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '8 of 10 tasks completed',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Today\'s Tasks', [
                        _buildTaskItem(
                          'Sign Employment Contract',
                          'Due: May 02, 2024',
                          true,
                          context,
                        ),
                        const SizedBox(height: 12),
                        _buildTaskItem(
                          'Set up Slack Account',
                          'Due: May 02, 2024',
                          false,
                          context,
                        ),
                        const SizedBox(height: 12),
                        _buildTaskItem(
                          'Complete IT Security Training',
                          'Due: May 03, 2024',
                          false,
                          context,
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Upcoming Tasks', [
                        _buildTaskItem(
                          'Submit Tax Information',
                          'Due: May 05, 2024',
                          false,
                          context,
                        ),
                        const SizedBox(height: 12),
                        _buildTaskItem(
                          'Read Employee Handbook',
                          'Due: May 04, 2024',
                          false,
                          context,
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildTaskItem(
    String title,
    String dueDate,
    bool isCompleted,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (value) {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isCompleted
                        ? Colors.grey[500]
                        : const Color(0xFF1F2937),
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dueDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
