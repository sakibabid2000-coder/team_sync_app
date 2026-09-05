import 'package:flutter/material.dart';

import '../services/activity_log_service.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      MetricCardData(
        title: 'Completion rate',
        value: '78%',
        delta: '+8% vs last month',
        color: const Color(0xFF10B981),
      ),
      MetricCardData(
        title: 'Pending approvals',
        value: '14',
        delta: '4 need action today',
        color: const Color(0xFFF59E0B),
      ),
      MetricCardData(
        title: 'Nudge activity',
        value: '27',
        delta: '5 above target',
        color: const Color(0xFF3B82F6),
      ),
      MetricCardData(
        title: 'At-risk hires',
        value: '05',
        delta: '2 in critical path',
        color: const Color(0xFFEF4444),
      ),
    ];

    final activities = [
      ...ActivityLogService.entries.map(
        (entry) => ActivityItem(entry.description, entry.relativeTime),
      ),
      // Historical seed activity, shown below anything logged this session.
      ActivityItem('Alex Morgan completed payroll setup', '2 hours ago'),
      ActivityItem('Jamie Lee missed security review reminder', '5 hours ago'),
      ActivityItem('Taylor Smith passed compliance check', 'Yesterday'),
      ActivityItem('New manager review scheduled', 'Yesterday'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports & Insights',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Monitor onboarding health across the business.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 1000 ? 4 : 2;
              final totalSpacing = (columns - 1) * 16;
              final cardWidth = (constraints.maxWidth - totalSpacing) / columns;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: metrics
                    .map(
                      (metric) => SizedBox(
                        width: cardWidth.clamp(220.0, 320.0),
                        child: _MetricCard(metric: metric),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent activity',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                ...activities.map(
                  (activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 7, right: 10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6B46C1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activity.time,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class _MetricCard extends StatelessWidget {
  final MetricCardData metric;

  const _MetricCard({required this.metric});

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
          Text(
            metric.title,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metric.delta,
            style: TextStyle(
              color: metric.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCardData {
  final String title;
  final String value;
  final String delta;
  final Color color;

  MetricCardData({
    required this.title,
    required this.value,
    required this.delta,
    required this.color,
  });
}

class ActivityItem {
  final String text;
  final String time;

  ActivityItem(this.text, this.time);
}
