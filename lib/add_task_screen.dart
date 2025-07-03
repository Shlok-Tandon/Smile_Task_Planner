import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final VoidCallback onSave;

  const AddTaskScreen({super.key, required this.onSave});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedType = 'task';
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> saveTask() async {
    if (_titleController.text.trim().isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both Title and Date/Time are required.")),
      );
      return;
    }

    final box = Hive.box('tasksBox');
    await box.add({
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'timestamp': _selectedDateTime.toString(),
      'type': _selectedType,
    });

    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = _selectedDateTime == null
        ? "Pick Date & Time"
        : DateFormat('EEE, dd MMM yyyy – hh:mm a').format(_selectedDateTime!);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                hintText: "Enter title...",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Optional description...",
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'task', child: Text('Task')),
                DropdownMenuItem(value: 'note', child: Text('Note')),
                DropdownMenuItem(value: 'event', child: Text('Event')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formattedDateTime,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickDateTime,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Select Date"),
                )
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveTask,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}