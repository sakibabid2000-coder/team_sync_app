import 'package:flutter/material.dart';

import 'employees_screen.dart';

class AddEmployeeDialog extends StatefulWidget {
  final List<String> departments;
  final Function(EmployeeDirectoryItem) onEmployeeCreated;

  const AddEmployeeDialog({
    super.key,
    required this.departments,
    required this.onEmployeeCreated,
  });

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  late String _selectedDepartment;
  DateTime _hireDate = DateTime.now();

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDepartment = widget.departments.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  Future<void> _pickHireDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _hireDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(() => _hireDate = picked);
    }
  }

  void _createEmployee() {
    final name = _nameController.text.trim();
    final role = _roleController.text.trim();

    if (name.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and job title are required')),
      );
      return;
    }

    final employee = EmployeeDirectoryItem(
      name: name,
      role: role,
      department: _selectedDepartment,
      hireDate: _formatDate(_hireDate),
      progress: 0,
      status: 'In Progress',
      dueToday: 0,
      avatar: name[0].toUpperCase(),
    );

    widget.onEmployeeCreated(employee);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Employee'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'e.g., Morgan Reyes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: 'Job Title *',
                hintText: 'e.g., Software Engineer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedDepartment,
              decoration: InputDecoration(
                labelText: 'Department *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: widget.departments
                  .map(
                    (dept) => DropdownMenuItem(value: dept, child: Text(dept)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDepartment = value);
                }
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickHireDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Hire Date *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today, size: 18),
                ),
                child: Text(_formatDate(_hireDate)),
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
          onPressed: _createEmployee,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B46C1),
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Employee'),
        ),
      ],
    );
  }
}
