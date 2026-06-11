import 'package:flutter/material.dart';
import '../models/study_group.dart';

class StudyGroupProvider with ChangeNotifier {
  final List<StudyGroup> _groups = [];

  List<StudyGroup> get groups => _groups;

  void addGroup(StudyGroup group) {
    _groups.add(group);
    notifyListeners();
  }

  void removeGroup(String id) {
    _groups.removeWhere((group) => group.id == id);
    notifyListeners();
  }

  void loadDummyGroups() {
    _groups.addAll([
      StudyGroup(
        id: '1',
        topic: 'Flutter Dev',
        course: 'Mobile Apps',
        host: 'Amara',
        description: 'Learn Flutter together',
        schedule: DateTime.now().add(const Duration(days: 1)),
        members: ['12'],
      ),
      StudyGroup(
        id: '2',
        topic: 'AI Study',
        course: 'Machine Learning',
        host: 'Prem',
        description: 'AI and ML discussions',
        schedule: DateTime.now().add(const Duration(days: 3)),
        members: ['8'],
      ),
    ]);
    notifyListeners();
  }
}