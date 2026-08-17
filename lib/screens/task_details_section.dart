import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class TaskDetailsSection extends StatelessWidget {
  final EmployeeData? selectedEmployee;

  const TaskDetailsSection({super.key, this.selectedEmployee});

  @override
  Widget build(BuildContext context) {
    if (selectedEmployee == null) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 1200
        ? 300.0
        : screenWidth > 800
        ? 250.0
        : (screenWidth - 64).clamp(220.0, 260.0);

    final tasks = [
      TaskData(
        title: 'Set up Slack Account',
        dueDate: 'May 02, 2024',
        isCompleted: true,
        completedDate: 'May 01, 2024',
      ),
      TaskData(
        title: 'Sign Employment Contract',
        dueDate: 'May 02, 2024',
        isCompleted: false,
        completedDate: null,
      ),
      TaskData(
        title: 'Complete IT Security Training',
        dueDate: 'May 03, 2024',
        isCompleted: false,
        completedDate: null,
      ),
      TaskData(
        title: 'Read Employee Handbook',
        dueDate: 'May 04, 2024',
        isCompleted: false,
        completedDate: null,
      ),
    ];

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
                  'Tasks for ${selectedEmployee!.name}',
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
                      employeeName: selectedEmployee!.name,
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

  const TaskCard({super.key, required this.task, required this.employeeName});

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
                          : 'Due: ${task.dueDate}',
                      style: TextStyle(
                        fontSize: 12,
                        color: task.isCompleted
                            ? Colors.green
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
                      side: const BorderSide(color: Color(0xFF6B46C1)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Mark Done',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B46C1)),
                    ),
                  ),
                )
              else
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'View Details',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_vert, size: 18),
                  onPressed: () {},
                  iconSize: 20,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: EdgeInsets.zero,
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
  final String dueDate;
  final bool isCompleted;
  final String? completedDate;

  TaskData({
    required this.title,
    required this.dueDate,
    required this.isCompleted,
    this.completedDate,
  });
}
