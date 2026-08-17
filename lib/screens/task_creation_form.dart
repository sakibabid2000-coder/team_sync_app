import 'package:flutter/material.dart';

class TaskCreationForm extends StatefulWidget {
  final Function(TaskTemplate) onTaskCreated;

  const TaskCreationForm({super.key, required this.onTaskCreated});

  @override
  State<TaskCreationForm> createState() => _TaskCreationFormState();
}

class _TaskCreationFormState extends State<TaskCreationForm> {
  final _titleController = TextEditingController();
  final _documentLinkController = TextEditingController();
  int _dueDaysAfterHire = 1;
  bool _isForAllDepartments = false;
  List<String> _selectedDepartments = [];

  final List<String> _allDepartments = [
    'Engineering',
    'Marketing',
    'Sales',
    'HR',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _documentLinkController.dispose();
    super.dispose();
  }

  void _createTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task title is required')));
      return;
    }

    if (!_isForAllDepartments && _selectedDepartments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one department')),
      );
      return;
    }

    final task = TaskTemplate(
      id: DateTime.now().toString(),
      title: _titleController.text,
      dueDaysAfterHire: _dueDaysAfterHire,
      documentLink: _documentLinkController.text.isEmpty
          ? null
          : _documentLinkController.text,
      isForAllDepartments: _isForAllDepartments,
      departmentSpecific: _isForAllDepartments ? [] : _selectedDepartments,
    );

    widget.onTaskCreated(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width > 800
            ? 600
            : MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title
                    Text(
                      'Task Details',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title *',
                        hintText: 'e.g., Set up Slack Account',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Due Date (Relative to Hire Date)
                    Text(
                      'Due Date',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due in ${_dueDaysAfterHire} day${_dueDaysAfterHire != 1 ? 's' : ''} after hire date',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _dueDaysAfterHire.toDouble(),
                                  min: 1,
                                  max: 90,
                                  divisions: 89,
                                  label: _dueDaysAfterHire.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      _dueDaysAfterHire = value.toInt();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                    text: _dueDaysAfterHire.toString(),
                                  ),
                                  onChanged: (value) {
                                    final parsedValue = int.tryParse(value);
                                    if (parsedValue != null &&
                                        parsedValue >= 1 &&
                                        parsedValue <= 90) {
                                      setState(() {
                                        _dueDaysAfterHire = parsedValue;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Example: If hired on May 1, task is due on May ${1 + _dueDaysAfterHire}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Document Link
                    Text(
                      'Document Link (Optional)',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _documentLinkController,
                      decoration: InputDecoration(
                        labelText: 'URL',
                        hintText:
                            'https://docs.company.com/onboarding/slack-setup',
                        prefixIcon: const Icon(Icons.link),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Department Selection
                    Text(
                      'Department Assignment',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    // All Departments Toggle
                    CheckboxListTile(
                      value: _isForAllDepartments,
                      onChanged: (value) {
                        setState(() {
                          _isForAllDepartments = value ?? false;
                          if (_isForAllDepartments) {
                            _selectedDepartments = [];
                          }
                        });
                      },
                      title: const Text('Apply to All Departments'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 12),
                    // Department List (if not all departments)
                    if (!_isForAllDepartments)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: _allDepartments
                              .map(
                                (dept) => CheckboxListTile(
                                  value: _selectedDepartments.contains(dept),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value ?? false) {
                                        _selectedDepartments.add(dept);
                                      } else {
                                        _selectedDepartments.remove(dept);
                                      }
                                    });
                                  },
                                  title: Text(dept),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _createTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B46C1),
                    ),
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Task Template Model
class TaskTemplate {
  final String id;
  final String title;
  final int dueDaysAfterHire;
  final String? documentLink;
  final bool isForAllDepartments;
  final List<String> departmentSpecific;

  TaskTemplate({
    required this.id,
    required this.title,
    required this.dueDaysAfterHire,
    this.documentLink,
    required this.isForAllDepartments,
    required this.departmentSpecific,
  });
}
