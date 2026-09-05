import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_template_dialog.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  static const _prefsKey = 'templates_data';

  late List<TemplateData> templates;

  @override
  void initState() {
    super.initState();
    // Seed data shown immediately; overwritten by persisted data if present.
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
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored == null) {
      // First run: persist the seed data so it's there on next load.
      await _saveTemplates();
      return;
    }
    if (!mounted) return;
    final decoded = jsonDecode(stored) as List<dynamic>;
    setState(() {
      templates = decoded
          .map((json) => TemplateData.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _saveTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(templates.map((t) => t.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
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
          _saveTemplates();
        },
      ),
    );
  }

  void _editTemplate(TemplateData template) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditTemplateDialog(
        template: template,
        onTemplateUpdated: (updated) {
          setState(() {
            final index = templates.indexWhere((t) => t.id == updated.id);
            if (index != -1) templates[index] = updated;
          });
          _saveTemplates();
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 760;

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Onboarding Templates',
                      style: Theme.of(context).textTheme.headlineSmall
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
                          style: Theme.of(context).textTheme.headlineSmall
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
                      onEdit: () => _editTemplate(template),
                      onDelete: () {
                        setState(() {
                          templates.removeWhere((t) => t.id == template.id);
                        });
                        _saveTemplates();
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
                onPressed: onEdit,
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

  TemplateData copyWith({String? name, String? department, String? description}) {
    return TemplateData(
      id: id,
      name: name ?? this.name,
      department: department ?? this.department,
      description: description ?? this.description,
      taskCount: taskCount,
      createdDate: createdDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'department': department,
    'description': description,
    'taskCount': taskCount,
    'createdDate': createdDate,
  };

  factory TemplateData.fromJson(Map<String, dynamic> json) {
    return TemplateData(
      id: json['id'] as String,
      name: json['name'] as String,
      department: json['department'] as String,
      description: json['description'] as String,
      taskCount: json['taskCount'] as int,
      createdDate: json['createdDate'] as String,
    );
  }
}

// Edit Template Dialog
class EditTemplateDialog extends StatefulWidget {
  final TemplateData template;
  final Function(TemplateData) onTemplateUpdated;

  const EditTemplateDialog({
    super.key,
    required this.template,
    required this.onTemplateUpdated,
  });

  @override
  State<EditTemplateDialog> createState() => _EditTemplateDialogState();
}

class _EditTemplateDialogState extends State<EditTemplateDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _selectedDepartment;

  final List<String> _departments = ['Engineering', 'Marketing', 'Sales', 'HR'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template.name);
    _descriptionController = TextEditingController(
      text: widget.template.description,
    );
    _selectedDepartment = widget.template.department;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Template name is required')));
      return;
    }

    widget.onTemplateUpdated(
      widget.template.copyWith(
        name: _nameController.text,
        department: _selectedDepartment,
        description: _descriptionController.text,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Template'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Template Name *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedDepartment,
              decoration: InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _departments
                  .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedDepartment = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B46C1),
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
