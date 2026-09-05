import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import '../services/activity_log_service.dart';
import 'dashboard_screen.dart';

class EmployeeProfilePanel extends StatefulWidget {
  final EmployeeData employee;
  final VoidCallback onClose;

  const EmployeeProfilePanel({
    super.key,
    required this.employee,
    required this.onClose,
  });

  @override
  State<EmployeeProfilePanel> createState() => _EmployeeProfilePanelState();
}

class _EmployeeProfilePanelState extends State<EmployeeProfilePanel> {
  final DateTime _now = DateTime.now();

  late final List<_PanelTask> _todaysTasks = [
    _PanelTask(
      'Sign Employment Contract',
      _now.subtract(const Duration(days: 4)),
      true,
    ),
    _PanelTask('Set up Slack Account', _now.add(const Duration(days: 1)), false),
    _PanelTask(
      'Complete IT Security Training',
      _now.subtract(const Duration(days: 1)),
      false,
    ),
  ];

  late final List<_PanelTask> _upcomingTasks = [
    _PanelTask('Submit Tax Information', _now.add(const Duration(days: 4)), false),
    _PanelTask('Read Employee Handbook', _now.add(const Duration(days: 3)), false),
  ];

  EmployeeData get employee => widget.employee;

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
                      onPressed: widget.onClose,
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
                          '${_todaysTasks.where((t) => t.isCompleted).length + _upcomingTasks.where((t) => t.isCompleted).length} of ${_todaysTasks.length + _upcomingTasks.length} tasks completed',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Today\'s Tasks', [
                        for (int i = 0; i < _todaysTasks.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _buildTaskItem(_todaysTasks[i], (value) {
                            final completed = value ?? false;
                            setState(
                              () => _todaysTasks[i].isCompleted = completed,
                            );
                            if (completed) {
                              ActivityLogService.logTaskCompletion(
                                employeeName: employee.name,
                                taskTitle: _todaysTasks[i].title,
                              );
                            }
                          }),
                        ],
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Upcoming Tasks', [
                        for (int i = 0; i < _upcomingTasks.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _buildTaskItem(_upcomingTasks[i], (value) {
                            final completed = value ?? false;
                            setState(
                              () => _upcomingTasks[i].isCompleted = completed,
                            );
                            if (completed) {
                              ActivityLogService.logTaskCompletion(
                                employeeName: employee.name,
                                taskTitle: _upcomingTasks[i].title,
                              );
                            }
                          }),
                        ],
                      ]),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _exportCompletionReport,
                          icon: const Icon(Icons.description_outlined, size: 18),
                          label: const Text('Export Completion Report'),
                        ),
                      ),
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

  void _exportCompletionReport() {
    final completedTasks = [
      ..._todaysTasks,
      ..._upcomingTasks,
    ].where((task) => task.isCompleted).toList();

    final rows = completedTasks.isEmpty
        ? '<tr><td colspan="2">No tasks completed yet</td></tr>'
        : completedTasks
              .map(
                (task) =>
                    '<tr><td>${task.title}</td><td>${_formatTaskDate(task.dueDate)}</td></tr>',
              )
              .join('\n');

    final html =
        '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Onboarding Completion Report - ${employee.name}</title>
<style>
  body { font-family: Arial, sans-serif; padding: 32px; color: #1F2937; }
  h1 { color: #6B46C1; margin-bottom: 4px; }
  .meta { color: #6B7280; margin-bottom: 24px; }
  table { width: 100%; border-collapse: collapse; }
  th, td { border: 1px solid #E5E7EB; padding: 8px 12px; text-align: left; }
  th { background: #F9FAFB; }
</style>
</head>
<body>
  <h1>Onboarding Completion Report</h1>
  <p class="meta">
    <strong>${employee.name}</strong> &middot; ${employee.department}<br>
    Progress: ${employee.progress}% &middot; Generated ${_formatTaskDate(DateTime.now())}
  </p>
  <table>
    <tr><th>Completed Task</th><th>Due Date</th></tr>
    $rows
  </table>
</body>
</html>
''';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Completion Report (HTML)'),
        content: SizedBox(
          width: 480,
          height: 360,
          child: SingleChildScrollView(
            child: SelectableText(
              html,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: html));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('HTML copied to clipboard')),
              );
            },
            child: const Text('Copy HTML'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
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

  Widget _buildTaskItem(_PanelTask task, ValueChanged<bool?> onChanged) {
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
            value: task.isCompleted,
            onChanged: onChanged,
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
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: task.isCompleted
                        ? Colors.grey[500]
                        : const Color(0xFF1F2937),
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.isOverdue
                      ? 'Overdue — was due ${_formatTaskDate(task.dueDate)}'
                      : 'Due: ${_formatTaskDate(task.dueDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: task.isOverdue ? FontWeight.w600 : null,
                    color: task.isOverdue ? Colors.red : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelTask {
  final String title;
  final DateTime dueDate;
  bool isCompleted;

  _PanelTask(this.title, this.dueDate, this.isCompleted);

  bool get isOverdue => !isCompleted && DateTime.now().isAfter(dueDate);
}

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String _formatTaskDate(DateTime date) {
  return '${_monthNames[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
}
