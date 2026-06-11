class StudyGroup {
  final String id;
  final String topic;
  final String course;
  final String description;
  final List<String> members;
  final DateTime schedule;
  final String host;

  StudyGroup({
    required this.id,
    required this.topic,
    required this.course,
    required this.description,
    required this.members,
    required this.schedule,
    required this.host,
  });
}