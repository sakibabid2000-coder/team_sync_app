import 'package:flutter/material.dart';

import '../services/activity_log_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  static const _columns = [
    'Due today',
    'In progress',
    'Needs attention',
    'Completed',
  ];

  static const _columnColors = {
    'Due today': Color(0xFF6B46C1),
    'In progress': Color(0xFF3B82F6),
    'Needs attention': Color(0xFFF59E0B),
    'Completed': Color(0xFF10B981),
  };

  final List<TaskItem> _tasks = [
    TaskItem(
      title: 'Set up laptop and equipment',
      assignee: 'Alex Morgan',
      status: 'Due today',
    ),
    TaskItem(
      title: 'Complete device security checklist',
      assignee: 'Jamie Lee',
      status: 'Due today',
    ),
    TaskItem(
      title: 'Review employment documents',
      assignee: 'Taylor Smith',
      status: 'In progress',
    ),
    TaskItem(
      title: 'Complete HR orientation',
      assignee: 'Jordan Kim',
      status: 'In progress',
    ),
    TaskItem(
      title: 'IT security training overdue',
      assignee: 'Casey Brown',
      status: 'Needs attention',
    ),
    TaskItem(
      title: 'New hire handbook acknowledgment',
      assignee: 'Jamie Lee',
      status: 'Needs attention',
    ),
    TaskItem(
      title: 'Welcome email sent',
      assignee: 'Alex Morgan',
      status: 'Completed',
    ),
    TaskItem(
      title: 'Slack access provisioned',
      assignee: 'Taylor Smith',
      status: 'Completed',
    ),
  ];

  void _moveTask(TaskItem task, String newStatus) {
    setState(() => task.status = newStatus);
    if (newStatus == 'Completed') {
      ActivityLogService.logTaskCompletion(
        employeeName: task.assignee,
        taskTitle: task.title,
      );
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Moved "${task.title}" to $newStatus')));
  }

  void _removeTask(TaskItem task) {
    setState(() => _tasks.remove(task));
  }

  void _addTask(String status) {
    final titleController = TextEditingController();
    final assigneeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add task to "$status"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: assigneeController,
              decoration: const InputDecoration(labelText: 'Assignee'),
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
              if (titleController.text.trim().isEmpty ||
                  assigneeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task title and assignee are required'),
                  ),
                );
                return;
              }
              setState(() {
                _tasks.add(
                  TaskItem(
                    title: titleController.text.trim(),
                    assignee: assigneeController.text.trim(),
                    status: status,
                  ),
                );
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Center',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep the onboarding flow moving across teams and responsibilities.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount = constraints.maxWidth > 1000 ? 4 : 2;
              final itemWidth =
                  (constraints.maxWidth - ((columnCount - 1) * 16)) /
                  columnCount;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _columns
                    .map(
                      (status) => SizedBox(
                        width: itemWidth.clamp(220.0, 320.0),
                        child: _TaskGroupCard(
                          status: status,
                          accent: _columnColors[status]!,
                          items: _tasks
                              .where((task) => task.status == status)
                              .toList(),
                          otherStatuses: _columns
                              .where((c) => c != status)
                              .toList(),
                          onAddTask: () => _addTask(status),
                          onMoveTask: _moveTask,
                          onRemoveTask: _removeTask,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TaskGroupCard extends StatelessWidget {
  final String status;
  final Color accent;
  final List<TaskItem> items;
  final List<String> otherStatuses;
  final VoidCallback onAddTask;
  final void Function(TaskItem task, String newStatus) onMoveTask;
  final void Function(TaskItem task) onRemoveTask;

  const _TaskGroupCard({
    required this.status,
    required this.accent,
    required this.items,
    required this.otherStatuses,
    required this.onAddTask,
    required this.onMoveTask,
    required this.onRemoveTask,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$status (${items.length})',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: onAddTask,
                tooltip: 'Add task',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No tasks here',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.assignee,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18),
                    tooltip: 'Task actions',
                    onSelected: (value) {
                      if (value == 'remove') {
                        onRemoveTask(item);
                      } else {
                        onMoveTask(item, value);
                      }
                    },
                    itemBuilder: (context) => [
                      ...otherStatuses.map(
                        (target) => PopupMenuItem(
                          value: target,
                          child: Text('Move to $target'),
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove task'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskItem {
  final String title;
  final String assignee;
  String status;

  TaskItem({required this.title, required this.assignee, required this.status});
}
