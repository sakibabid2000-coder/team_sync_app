import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  /// Shared static list so an Admin posting here also drives the
  /// site-wide banner rendered in main.dart (Phase 5).
  static final List<AnnouncementItem> _announcements = [
    AnnouncementItem(
      title: 'Product rollout: Team workspace update',
      audience: 'All employees',
      date: 'Today • 9:30 AM',
      summary: 'New workspace templates and onboarding checklists will be enabled for all new hires this week.',
      priority: 'High',
    ),
    AnnouncementItem(
      title: 'Town hall recap and feedback survey',
      audience: 'Engineering & HR',
      date: 'Tomorrow • 2:00 PM',
      summary: 'Leadership will share onboarding findings from Q3 and collect feedback on the manager workflow.',
      priority: 'Medium',
    ),
    AnnouncementItem(
      title: 'Benefits enrollment reminder',
      audience: 'New hires only',
      date: 'Fri • 9:00 AM',
      summary: 'Please complete benefits enrollment and payroll documentation before your first Friday review.',
      priority: 'Medium',
    ),
  ];

  static List<AnnouncementItem> get all => List.unmodifiable(_announcements);

  /// Most recent announcement — read by main.dart for the top-of-every-page banner.
  static AnnouncementItem? get latest =>
      _announcements.isEmpty ? null : _announcements.first;

  static void post(AnnouncementItem item) => _announcements.insert(0, item);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  void _showNewAnnouncementDialog() {
    final titleController = TextEditingController();
    final audienceController = TextEditingController();
    final summaryController = TextEditingController();
    String priority = 'Medium';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New Announcement'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: audienceController,
                  decoration: const InputDecoration(labelText: 'Audience'),
                ),
                TextField(
                  controller: summaryController,
                  decoration: const InputDecoration(labelText: 'Message'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: ['High', 'Medium', 'Low']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => priority = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;
                AnnouncementsScreen.post(
                  AnnouncementItem(
                    title: titleController.text,
                    audience: audienceController.text.isEmpty
                        ? 'All employees'
                        : audienceController.text,
                    date: 'Just now',
                    summary: summaryController.text,
                    priority: priority,
                  ),
                );
                Navigator.pop(dialogContext);
                setState(() {});
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final announcements = AnnouncementsScreen.all;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Announcements',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share updates that keep the team aligned and informed.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showNewAnnouncementDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Announcement'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth > 1000
                  ? 320.0
                  : constraints.maxWidth > 700
                  ? 280.0
                  : constraints.maxWidth - 24;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: announcements
                    .map(
                      (item) => SizedBox(
                        width: width,
                        child: _AnnouncementCard(item: item),
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

class _AnnouncementCard extends StatelessWidget {
  final AnnouncementItem item;

  const _AnnouncementCard({required this.item});

  Color get _priorityColor {
    switch (item.priority) {
      case 'High':
        return const Color(0xFFEF4444);
      case 'Medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _priorityColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${item.priority} priority',
                    style: TextStyle(
                      color: _priorityColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.date,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              'Audience: ${item.audience}',
              style: const TextStyle(
                color: Color(0xFF6B46C1),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),
            Text(item.summary, style: const TextStyle(height: 1.5)),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _priorityColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.priority,
                  style: TextStyle(
                    color: _priorityColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.date,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            item.audience,
            style: TextStyle(
              color: const Color(0xFF6B46C1),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.summary,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showDetails(context),
              child: const Text('Open details'),
            ),
          ),
        ],
      ),
    );
  }
}

class AnnouncementItem {
  final String title;
  final String audience;
  final String date;
  final String summary;
  final String priority;

  AnnouncementItem({
    required this.title,
    required this.audience,
    required this.date,
    required this.summary,
    required this.priority,
  });
}
