import 'package:flutter/material.dart';

class EmployeeJourneyScreen extends StatefulWidget {
  final String? employeeId;

  const EmployeeJourneyScreen({super.key, this.employeeId});

  @override
  State<EmployeeJourneyScreen> createState() => _EmployeeJourneyScreenState();
}

class _EmployeeJourneyScreenState extends State<EmployeeJourneyScreen> {
  String _selectedEmployee = 'alex-morgan';

  @override
  Widget build(BuildContext context) {
    final employees = [
      EmployeeOption(
        id: 'alex-morgan',
        name: 'Alex Morgan',
        role: 'Software Engineer',
      ),
      EmployeeOption(
        id: 'jamie-lee',
        name: 'Jamie Lee',
        role: 'Product Manager',
      ),
      EmployeeOption(
        id: 'taylor-smith',
        name: 'Taylor Smith',
        role: 'Designer',
      ),
    ];

    final journeySteps = [
      JourneyStep(
        phase: 'Pre-onboarding',
        title: 'Welcome Package Sent',
        subtitle: 'All welcome materials sent to personal email',
        date: '2026-08-10',
        status: 'Completed',
        icon: Icons.mail_outline,
      ),
      JourneyStep(
        phase: 'Pre-onboarding',
        title: 'Background Check',
        subtitle: 'Verification in progress with third party',
        date: '2026-08-12',
        status: 'Completed',
        icon: Icons.verified_user,
      ),
      JourneyStep(
        phase: 'Day 1',
        title: 'System Access Granted',
        subtitle: 'Email, Slack, GitHub, and Dev tools provisioned',
        date: '2026-08-18',
        status: 'In Progress',
        icon: Icons.vpn_key,
      ),
      JourneyStep(
        phase: 'Day 1',
        title: 'Team Introduction',
        subtitle: '1:1 with manager and team kickoff meeting',
        date: '2026-08-18',
        status: 'Pending',
        icon: Icons.people,
      ),
      JourneyStep(
        phase: 'Week 1',
        title: 'Codebase Onboarding',
        subtitle: 'Architecture overview and setup walkthrough',
        date: '2026-08-20',
        status: 'Pending',
        icon: Icons.code,
      ),
      JourneyStep(
        phase: 'Week 2',
        title: 'First Task Assignment',
        subtitle: 'Paired with senior engineer for first feature',
        date: '2026-08-25',
        status: 'Pending',
        icon: Icons.assignment,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Onboarding Journey',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Track individual employee progress through their onboarding timeline.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          // Employee selector dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedEmployee,
              isExpanded: true,
              underline: const SizedBox(),
              items: employees
                  .map(
                    (emp) => DropdownMenuItem(
                      value: emp.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            emp.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            emp.role,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedEmployee = value);
                }
              },
            ),
          ),
          const SizedBox(height: 28),
          // Progress overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress Overview',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${((journeySteps.where((s) => s.status == 'Completed').length) / journeySteps.length * 100).toStringAsFixed(0)}% Complete',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value:
                        journeySteps
                            .where((s) => s.status == 'Completed')
                            .length /
                        journeySteps.length,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = constraints.maxWidth > 900
                        ? (constraints.maxWidth - 32) / 3
                        : (constraints.maxWidth - 16) / 2;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: itemWidth.clamp(140.0, 220.0),
                          child: _ProgressMetric(
                            label: 'Completed',
                            value: journeySteps
                                .where((s) => s.status == 'Completed')
                                .length
                                .toString(),
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth.clamp(140.0, 220.0),
                          child: _ProgressMetric(
                            label: 'In Progress',
                            value: journeySteps
                                .where((s) => s.status == 'In Progress')
                                .length
                                .toString(),
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth.clamp(140.0, 220.0),
                          child: _ProgressMetric(
                            label: 'Pending',
                            value: journeySteps
                                .where((s) => s.status == 'Pending')
                                .length
                                .toString(),
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Journey timeline
          Text(
            'Journey Timeline',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          ...journeySteps.asMap().entries.map((entry) {
            final step = entry.value;
            final isLast = entry.key == journeySteps.length - 1;
            return _JourneyStepCard(step: step, isLast: isLast);
          }),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _JourneyStepCard extends StatelessWidget {
  final JourneyStep step;
  final bool isLast;

  const _JourneyStepCard({required this.step, required this.isLast});

  Color get _statusColor {
    switch (step.status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'In Progress':
        return const Color(0xFF3B82F6);
      case 'Pending':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline column
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _statusColor.withAlpha(26),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(step.icon, size: 20, color: _statusColor),
            ),
            if (!isLast)
              Container(width: 2, height: 60, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 20),
        // Content column
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
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
                          step.phase,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        step.status,
                        style: TextStyle(
                          color: _statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  step.subtitle,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
                const SizedBox(height: 12),
                Text(
                  step.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class JourneyStep {
  final String phase;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final IconData icon;

  JourneyStep({
    required this.phase,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.icon,
  });
}

class EmployeeOption {
  final String id;
  final String name;
  final String role;

  EmployeeOption({required this.id, required this.name, required this.role});
}
