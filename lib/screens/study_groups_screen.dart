import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_group_provider.dart';
import 'create_study_group_screen.dart';
import 'study_group_detail_screen.dart';

class StudyGroupsScreen extends StatelessWidget {
  const StudyGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<StudyGroupProvider>().groups;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Groups"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to CreateStudyGroupScreen when the + icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateStudyGroupScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: groups.isEmpty
          ? const Center(child: Text("No study groups yet"))
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  title: Text(group.topic),
                  subtitle: Text(group.course),
                  trailing: Text("${group.members.length} members"),
                  onTap: () {
                    // Navigate to StudyGroupDetailScreen when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudyGroupDetailScreen(group: group),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}