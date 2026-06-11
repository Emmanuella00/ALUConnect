import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_group_provider.dart';
import '../models/study_group.dart';
import 'package:uuid/uuid.dart';

class CreateStudyGroupScreen extends StatefulWidget {
  const CreateStudyGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateStudyGroupScreenState createState() => _CreateStudyGroupScreenState();
}

class _CreateStudyGroupScreenState extends State<CreateStudyGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _courseController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hostController = TextEditingController();
  DateTime? _selectedDate;
  final List<String> _members = [];

  void _saveForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final group = StudyGroup(
        id: const Uuid().v4(),
        topic: _topicController.text,
        course: _courseController.text,
        description: _descriptionController.text,
        host: _hostController.text,
        members: _members,
        schedule: _selectedDate!,
      );

      context.read<StudyGroupProvider>().addGroup(group);
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Study Group")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(labelText: "Topic"),
                validator: (value) => value!.isEmpty ? "Enter topic" : null,
              ),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: "Course"),
                validator: (value) => value!.isEmpty ? "Enter course" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) => value!.isEmpty ? "Enter description" : null,
              ),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(labelText: "Host"),
                validator: (value) => value!.isEmpty ? "Enter host name" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "No date selected"
                          : "Scheduled: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text("Create Group"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}