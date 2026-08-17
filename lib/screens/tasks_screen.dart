import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      TaskBoardGroup(
        title: 'Due today',
        accent: const Color(0xFF6B46C1),
        items: [
          TaskItem('Set up laptop and equipment', 'Alex Morgan'),
          TaskItem('Complete device security checklist', 'Jamie Lee'),
        ],
      ),
      TaskBoardGroup(
        title: 'In progress',
        accent: const Color(0xFF3B82F6),
        items: [
          TaskItem('Review employment documents', 'Taylor Smith'),
          TaskItem('Complete HR orientation', 'Jordan Kim'),
        ],
      ),
      TaskBoardGroup(
        title: 'Needs attention',
        accent: const Color(0xFFF59E0B),
        items: [
          TaskItem('IT security training overdue', 'Casey Brown'),
          TaskItem('New hire handbook acknowledgment', 'Jamie Lee'),
        ],
      ),
      TaskBoardGroup(
        title: 'Completed',
        accent: const Color(0xFF10B981),
        items: [
          TaskItem('Welcome email sent', 'Alex Morgan'),
          TaskItem('Slack access provisioned', 'Taylor Smith'),
        ],
      ),
    ];

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
                children: tasks
                    .map(
                      (group) => SizedBox(
                        width: itemWidth.clamp(220.0, 320.0),
                        child: _TaskGroupCard(group: group),
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
  final TaskBoardGroup group;

  const _TaskGroupCard({required this.group});

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
                decoration: BoxDecoration(
                  color: group.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                group.title,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...group.items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
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
          ),
        ],
      ),
    );
  }
}

class TaskBoardGroup {
  final String title;
  final Color accent;
  final List<TaskItem> items;

  TaskBoardGroup({
    required this.title,
    required this.accent,
    required this.items,
  });
}

class TaskItem {
  final String title;
  final String assignee;

  TaskItem(this.title, this.assignee);
}
