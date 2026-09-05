import 'package:flutter/material.dart';

class ApprovalWorkflowScreen extends StatefulWidget {
  const ApprovalWorkflowScreen({super.key});

  /// Read-only view of the approval queue, for other screens (e.g. Reports)
  /// to compute real metrics from. This list is `static` so it also
  /// survives navigating away from and back to this screen.
  static List<ApprovalItem> get allItems =>
      List.unmodifiable(_ApprovalWorkflowScreenState._items);

  @override
  State<ApprovalWorkflowScreen> createState() => _ApprovalWorkflowScreenState();
}

class _ApprovalWorkflowScreenState extends State<ApprovalWorkflowScreen> {
  String _selectedFilter = 'All';

  static final List<ApprovalItem> _items = [
    ApprovalItem(
      id: '001',
      employeeName: 'Alex Morgan',
      itemType: 'Equipment Setup',
      status: 'Pending',
      dueDate: 'Today',
      priority: 'High',
      description: 'Laptop, monitor, and keyboard allocation confirmed',
    ),
    ApprovalItem(
      id: '002',
      employeeName: 'Jamie Lee',
      itemType: 'Security Clearance',
      status: 'In Review',
      dueDate: 'Tomorrow',
      priority: 'High',
      description: 'Background check and security badge approval',
    ),
    ApprovalItem(
      id: '003',
      employeeName: 'Taylor Smith',
      itemType: 'Policy Acknowledgement',
      status: 'Pending',
      dueDate: '3 days',
      priority: 'Medium',
      description: 'Confirm receipt and understanding of all company policies',
    ),
    ApprovalItem(
      id: '004',
      employeeName: 'Casey Brown',
      itemType: 'Manager Handoff',
      status: 'Pending',
      dueDate: '5 days',
      priority: 'Medium',
      description: 'Initial 1:1 meeting and team introduction session',
    ),
    ApprovalItem(
      id: '005',
      employeeName: 'Morgan Davis',
      itemType: 'System Access',
      status: 'Approved',
      dueDate: 'Completed',
      priority: 'Low',
      description: 'All development and collaboration tools provisioned',
    ),
  ];

  void _approve(ApprovalItem item) {
    setState(() => item.status = 'Approved');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Approved ${item.itemType} for ${item.employeeName}'),
      ),
    );
  }

  void _showDetails(ApprovalItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${item.employeeName} · ${item.itemType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 14),
            Text('Status: ${item.status}'),
            const SizedBox(height: 4),
            Text('Due: ${item.dueDate}'),
            const SizedBox(height: 4),
            Text('Priority: ${item.priority}'),
          ],
        ),
        actions: [
          if (item.status != 'Approved')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _approve(item);
              },
              child: const Text('Approve'),
            ),
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
    final filtered = _selectedFilter == 'All'
        ? _items
        : _items.where((item) => item.status == _selectedFilter).toList();

    final pendingCount = _items.where((i) => i.status == 'Pending').length;
    final inReviewCount = _items.where((i) => i.status == 'In Review').length;
    final approvedCount = _items.where((i) => i.status == 'Approved').length;
    // Items that are High priority and not yet resolved are the ones that
    // actually need someone's attention right now.
    final needsActionCount = _items
        .where((i) => i.status != 'Approved' && i.priority == 'High')
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Approval Workflow',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Review and approve onboarding tasks across your team.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          // Quick stats
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 1000
                  ? (constraints.maxWidth - 40) / 4
                  : (constraints.maxWidth - 24) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: cardWidth.clamp(140.0, 220.0),
                    child: _QuickStatCard(
                      label: 'Pending',
                      value: pendingCount.toString().padLeft(2, '0'),
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140.0, 220.0),
                    child: _QuickStatCard(
                      label: 'In Review',
                      value: inReviewCount.toString().padLeft(2, '0'),
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140.0, 220.0),
                    child: _QuickStatCard(
                      label: 'Approved',
                      value: approvedCount.toString().padLeft(2, '0'),
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140.0, 220.0),
                    child: _QuickStatCard(
                      label: 'Needs Action',
                      value: needsActionCount.toString().padLeft(2, '0'),
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          // Filters
          Wrap(
            spacing: 8,
            children: ['All', 'Pending', 'In Review', 'Approved'].map((filter) {
              return ChoiceChip(
                label: Text(filter),
                selected: _selectedFilter == filter,
                onSelected: (selected) {
                  setState(() => _selectedFilter = selected ? filter : 'All');
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Approval items list
          ...filtered.map(
            (item) => _ApprovalItemCard(
              item: item,
              onApprove: () => _approve(item),
              onDetails: () => _showDetails(item),
            ),
          ),
          if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No items to display',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalItemCard extends StatelessWidget {
  final ApprovalItem item;
  final VoidCallback onApprove;
  final VoidCallback onDetails;

  const _ApprovalItemCard({
    required this.item,
    required this.onApprove,
    required this.onDetails,
  });

  Color get _statusColor {
    switch (item.status) {
      case 'Approved':
        return const Color(0xFF10B981);
      case 'In Review':
        return const Color(0xFF3B82F6);
      case 'Pending':
        return const Color(0xFFF59E0B);
      case 'Rejected':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.employeeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.itemType,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 500;

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Due: ${item.dueDate}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _priorityColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(4),
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onDetails,
                            child: const Text('Details'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: item.status == 'Approved'
                                ? null
                                : onApprove,
                            child: Text(
                              item.status == 'Approved' ? 'Approved' : 'Approve',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Due: ${item.dueDate}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _priorityColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
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
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: onDetails,
                          child: const Text('Details'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: item.status == 'Approved'
                              ? null
                              : onApprove,
                          child: Text(
                            item.status == 'Approved' ? 'Approved' : 'Approve',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class ApprovalItem {
  final String id;
  final String employeeName;
  final String itemType;
  String status;
  final String dueDate;
  final String priority;
  final String description;

  ApprovalItem({
    required this.id,
    required this.employeeName,
    required this.itemType,
    required this.status,
    required this.dueDate,
    required this.priority,
    required this.description,
  });
}
