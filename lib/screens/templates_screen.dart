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
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => CreateTemplateDialog(
        onTemplateCreated: (template) {
          setState(() {
            templates.add(template);
          });
        },
      ),
    );
  }

  // ===========================================================================
  // Brinto's Contribution: Template Management Modal Dialog
  // Handles editing template titles and descriptions with live state updates.
  // ===========================================================================
  void _editTemplate(TemplateData template) {
    final nameController = TextEditingController(text: template.name);
    final descriptionController = TextEditingController(text: template.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Template — ${template.department}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Template Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final idx = templates.indexWhere((t) => t.id == template.id);
                if (idx != -1) {
                  templates[idx] = TemplateData(
                    id: template.id,
                    name: nameController.text,
                    department: template.department,
                    description: descriptionController.text,
                    taskCount: template.taskCount,
                    createdDate: template.createdDate,
                  );
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Brinto's Contribution: Template Task Management Viewer
  // Displays structured onboarding task workflows assigned to a template.
  // ===========================================================================
  void _manageTemplateTasks(TemplateData template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.65,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${template.name} (${template.taskCount} Tasks)',
                    style: Theme.of(ctx).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              template.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: template.taskCount,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFEAE6F8),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Color(0xFF6B46C1), fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text('Standard Onboarding Task #${index + 1}'),
                    subtitle: Text('Default required action step for ${template.department} team new hires.'),
                    trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                  );
                },
              ),
            ),
          ],
        ),
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 760;

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Onboarding Templates',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create and manage universal onboarding workflows for each department',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _createNewTemplate,
                        icon: const Icon(Icons.add),
                        label: const Text('Create Template'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B46C1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Onboarding Templates',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create and manage universal onboarding workflows for each department',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _createNewTemplate,
                    icon: const Icon(Icons.add),
                    label: const Text('Create Template'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B46C1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
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
                      // =======================================================
                      // Brinto's Contribution: Implemented edit popup handler
                      // =======================================================
                      onEdit: () => _editTemplate(template),
                      onDelete: () {
                        setState(() {
                          templates.removeWhere((t) => t.id == template.id);
                        });
                      },
                      // =======================================================
                      // Brinto's Contribution: Implemented manage template navigation
                      // =======================================================
                      onManage: () => _manageTemplateTasks(template),
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
  final VoidCallback onManage; // Brinto's Contribution: Manage Callback

  const TemplateCard({
    super.key,
    required this.template,
    required this.onEdit,
    required this.onDelete,
    required this.onManage,
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
                // =============================================================
                // Brinto's Contribution: Invokes task workflow management modal
                // =============================================================
                onPressed: onManage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B46C1),
                  foregroundColor: Colors.white,
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