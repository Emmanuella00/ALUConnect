import 'package:flutter/material.dart';
import '../models/study_group.dart';

class StudyGroupDetailScreen extends StatelessWidget {
  final StudyGroup group;

  const StudyGroupDetailScreen({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.topic)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Course: ${group.course}", style: const TextStyle(fontSize: 16)),
            Text("Host: ${group.host}", style: const TextStyle(fontSize: 16)),
            Text("Scheduled: ${group.schedule.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Description:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(group.description),
            const SizedBox(height: 10),
            Text("Members:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...group.members.map((m) => Text(m)).toList(),
          ],
        ),
      ),
    );
  }
}