import 'package:flutter/material.dart';

import '../services/activity_log_service.dart';
import 'dashboard_screen.dart';

class TaskDetailsSection extends StatefulWidget {
  final EmployeeData? selectedEmployee;

  const TaskDetailsSection({super.key, this.selectedEmployee});

  @override
  State<TaskDetailsSection> createState() => _TaskDetailsSectionState();
}

class _TaskDetailsSectionState extends State<TaskDetailsSection> {
  final DateTime _now = DateTime.now();

  late final List<TaskData> _tasks = [
    TaskData(
      title: 'Set up Slack Account',
      dueDate: _now.subtract(const Duration(days: 6)),
      isCompleted: true,
      completedDate: 'Yesterday',
    ),
    TaskData(
      title: 'Sign Employment Contract',
      dueDate: _now.subtract(const Duration(days: 2)),
      isCompleted: false,
    ),
    TaskData(
      title: 'Complete IT Security Training',
      dueDate: _now.add(const Duration(days: 3)),
      isCompleted: false,
    ),
    TaskData(
      title: 'Read Employee Handbook',
      dueDate: _now.add(const Duration(days: 6)),
      isCompleted: false,
    ),
  ];

  Future<void> _markDone(TaskData task) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark "${task.title}" complete'),
        content: TextField(
          controller: noteController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Note (optional)',
            hintText: 'e.g., Laptop received, serial number: 123',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mark Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        task.isCompleted = true;
        task.completedDate = 'Today';
        task.note = noteController.text.isEmpty ? null : noteController.text;
      });
      ActivityLogService.logTaskCompletion(
        employeeName: widget.selectedEmployee!.name,
        taskTitle: task.title,
        note: task.note,
      );
    }
  }

  void _viewDetails(TaskData task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.isCompleted
                  ? 'Completed on ${task.completedDate}'
                  : 'Due: ${_formatTaskDate(task.dueDate)}',
              style: TextStyle(
                color: task.isOverdue ? Colors.red : null,
                fontWeight: task.isOverdue ? FontWeight.w600 : null,
              ),
            ),
            if (task.isOverdue) ...[
              const SizedBox(height: 4),
              const Text(
                'Overdue',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            if (task.note != null) ...[
              const SizedBox(height: 12),
              Text('Note: ${task.note}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(TaskData task) {
    setState(() => _tasks.remove(task));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedEmployee == null) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 1200
        ? 300.0
        : screenWidth > 800
        ? 250.0
        : (screenWidth - 64).clamp(220.0, 260.0);

    final tasks = _tasks;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tasks for ${widget.selectedEmployee!.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${tasks.where((t) => t.isCompleted).length}/${tasks.length} Complete',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: tasks
                .map(
                  (task) => SizedBox(
                    width: cardWidth,
                    child: TaskCard(
                      task: task,
                      employeeName: widget.selectedEmployee!.name,
                      onMarkDone: () => _markDone(task),
                      onViewDetails: () => _viewDetails(task),
                      onDelete: () => _deleteTask(task),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// Task Card Widget
class TaskCard extends StatelessWidget {
  final TaskData task;
  final String employeeName;
  final VoidCallback onMarkDone;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.employeeName,
    required this.onMarkDone,
    required this.onViewDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: task.isCompleted ? Colors.green[300]! : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator and title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted
                      ? Colors.green
                      : const Color(0xFF6B46C1),
                ),
                child: Icon(
                  task.isCompleted ? Icons.check : Icons.pending,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.isCompleted
                          ? 'Completed on ${task.completedDate}'
                          : task.isOverdue
                          ? 'Overdue — was due ${_formatTaskDate(task.dueDate)}'
                          : 'Due: ${_formatTaskDate(task.dueDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: task.isOverdue ? FontWeight.w700 : null,
                        color: task.isCompleted
                            ? Colors.green
                            : task.isOverdue
                            ? Colors.red
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              if (!task.isCompleted)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B46C1),
                      side: const BorderSide(color: Color(0xFF6B46C1)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: onMarkDone,
                    child: const Text(
                      'Mark Done',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              else
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: onViewDetails,
                    child: const Text(
                      'View Details',
                      style: TextStyle(fontSize: 12),
                    ),
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
                    if (value == 'details') {
                      onViewDetails();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'details', child: Text('View Details')),
                    PopupMenuItem(value: 'delete', child: Text('Remove Task')),
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

// Task Data Model
class TaskData {
  final String title;
  final DateTime dueDate;
  bool isCompleted;
  String? completedDate;
  String? note;

  TaskData({
    required this.title,
    required this.dueDate,
    required this.isCompleted,
    this.completedDate,
    this.note,
  });

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
