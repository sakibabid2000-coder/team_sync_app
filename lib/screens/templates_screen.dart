import 'package:flutter/material.dart';

import 'create_template_dialog.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  late List<TemplateData> templates;

  @override
  void initState() {
    super.initState();
    templates = [
      TemplateData(
        id: '1',
        name: 'Engineering Onboarding',
        department: 'Engineering',
        description: 'Complete onboarding workflow for new engineers',
        taskCount: 8,
        createdDate: 'May 01, 2024',
      ),
      TemplateData(
        id: '2',
        name: 'Marketing Onboarding',
        department: 'Marketing',
        description: 'Onboarding for marketing team members',
        taskCount: 6,
        createdDate: 'April 15, 2024',
      ),
      TemplateData(
        id: '3',
        name: 'Sales Onboarding',
        department: 'Sales',
        description: 'Complete sales team onboarding process',
        taskCount: 7,
        createdDate: 'April 10, 2024',
      ),
      TemplateData(
        id: '4',
        name: 'HR Onboarding',
        department: 'HR',
        description: 'HR department specific onboarding',
        taskCount: 5,
        createdDate: 'March 20, 2024',
      ),
    ];
  }

  void _createNewTemplate() {
    showDialog(
      context: context,
      builder: (context) => CreateTemplateDialog(
        onTemplateCreated: (template) {
          setState(() {
            templates.add(template);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 1200
        ? 350.0
        : screenWidth > 800
        ? 300.0
        : double.infinity;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Create Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Onboarding Templates',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create and manage universal onboarding workflows for each department',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _createNewTemplate,
                icon: const Icon(Icons.add),
                label: const Text('Create Template'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B46C1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Templates Grid
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: templates
                .map(
                  (template) => SizedBox(
                    width: cardWidth,
                    child: TemplateCard(
                      template: template,
                      onEdit: () {
                        // TODO: Implement edit functionality
                      },
                      onDelete: () {
                        setState(() {
                          templates.removeWhere((t) => t.id == template.id);
                        });
                      },
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

// Template Card Widget
class TemplateCard extends StatelessWidget {
  final TemplateData template;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with department badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getDepartmentColor(template.department)
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        template.department,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getDepartmentColor(template.department),
                        ),
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Task count and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.task_alt, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 6),
                        Text(
                          '${template.taskCount} Tasks',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      template.createdDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to template details/edit page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B46C1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Manage Template'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDepartmentColor(String department) {
    switch (department) {
      case 'Engineering':
        return const Color(0xFF3B82F6);
      case 'Marketing':
        return const Color(0xFFEC4899);
      case 'Sales':
        return const Color(0xFF10B981);
      case 'HR':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B46C1);
    }
  }
}

// Template Data Model
class TemplateData {
  final String id;
  final String name;
  final String department;
  final String description;
  final int taskCount;
  final String createdDate;

  TemplateData({
    required this.id,
    required this.name,
    required this.department,
    required this.description,
    required this.taskCount,
    required this.createdDate,
  });
}
