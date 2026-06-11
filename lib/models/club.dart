import 'package:flutter/material.dart';

class ClubMember {
  final String name;
  final String initials;
  final String role;
  final Color color;

  const ClubMember({
    required this.name,
    required this.initials,
    required this.role,
    required this.color,
  });
}

class Announcement {
  final String id;
  final String clubId;
  final String title;
  final String body;
  final String time;
  final bool isPinned;

  const Announcement({
    required this.id,
    required this.clubId,
    required this.title,
    required this.body,
    required this.time,
    this.isPinned = false,
  });
}

class Club {
  final String id;
  final String name;
  final String memberCount;
  final String campus;
  final String description;
  final String mission;
  final String meetingCadence;
  final String leaderName;
  final String leaderRole;
  final IconData icon;
  final Color color;
  final String chatId;
  final List<String> organizerKeywords;

  const Club({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.campus,
    required this.description,
    required this.mission,
    required this.meetingCadence,
    required this.leaderName,
    required this.leaderRole,
    required this.icon,
    required this.color,
    required this.chatId,
    required this.organizerKeywords,
  });

  Map<String, dynamic> toChatMap() => {
        'id': chatId,
        'name': name,
        'preview': 'Tap to open club chat',
        'time': 'Now',
        'unread': 0,
        'initials': name.split(' ').map((w) => w[0]).take(2).join(),
        'color': color,
        'isOnline': true,
        'isGroup': true,
      };
}

class MockClubs {
  static const List<Club> all = [
    Club(
      id: '1',
      name: 'Data Science Guild',
      memberCount: '892',
      campus: 'Kigali Campus',
      description:
          'A community of data enthusiasts building analytical skills through projects, seminars, and peer learning.',
      mission: 'Democratize data literacy across ALU and empower students to solve real problems with evidence.',
      meetingCadence: 'Every Thursday, 4:00 PM',
      leaderName: 'Grace Niyonsaba',
      leaderRole: 'Club President',
      icon: Icons.code,
      color: Color(0xFF8A1A30),
      chatId: 'club_ds',
      organizerKeywords: ['Data Science', 'Data'],
    ),
    Club(
      id: '2',
      name: 'Sustainability Hub',
      memberCount: '1.2k',
      campus: 'Kigali Campus',
      description:
          'Students driving climate action, green entrepreneurship, and sustainable campus initiatives.',
      mission: 'Build a generation of leaders who put planetary health at the centre of every decision.',
      meetingCadence: 'Bi-weekly Wednesdays, 5:30 PM',
      leaderName: 'Jean-Paul Mugisha',
      leaderRole: 'Community Lead',
      icon: Icons.eco,
      color: Color(0xFF2A4A1A),
      chatId: 'club_sus',
      organizerKeywords: ['Social Innovation', 'Sustainability'],
    ),
    Club(
      id: '3',
      name: 'Creative Arts Collective',
      memberCount: '456',
      campus: 'Mauritius Campus',
      description:
          'A space for writers, designers, filmmakers, and performers to collaborate on creative projects.',
      mission: 'Celebrate African stories and creative expression through collaborative art.',
      meetingCadence: 'Every Friday, 6:00 PM',
      leaderName: 'Aisha Diallo',
      leaderRole: 'Creative Director',
      icon: Icons.palette,
      color: Color(0xFF1A2A6A),
      chatId: 'club_art',
      organizerKeywords: ['Creative', 'Arts'],
    ),
    Club(
      id: '4',
      name: 'Global Politics Forum',
      memberCount: '328',
      campus: 'Kigali Campus',
      description:
          'Debate, policy analysis, and dialogue on governance, diplomacy, and pan-African affairs.',
      mission: 'Develop informed citizens who engage constructively with Africa\'s political landscape.',
      meetingCadence: 'Monthly, first Tuesday 7:00 PM',
      leaderName: 'David Okafor',
      leaderRole: 'Forum Chair',
      icon: Icons.account_balance,
      color: Color(0xFF3A3A3A),
      chatId: 'club_pol',
      organizerKeywords: ['Politics', 'Leadership'],
    ),
    Club(
      id: '5',
      name: 'AI Innovation Lab',
      memberCount: '240',
      campus: 'Kigali Campus',
      description:
          'Building the next generation of pan-African tech solutions through AI research and hackathons.',
      mission: 'Apply AI ethically to solve Africa\'s most pressing challenges.',
      meetingCadence: 'Every Monday, 3:00 PM',
      leaderName: 'Fatima Hassan',
      leaderRole: 'Lab Director',
      icon: Icons.psychology,
      color: Color(0xFF4A1A5A),
      chatId: 'club_ai',
      organizerKeywords: ['AI', 'Tech'],
    ),
    Club(
      id: '6',
      name: 'Entrepreneurship Club',
      memberCount: '342',
      campus: 'Kigali Campus',
      description:
          'Founders, builders, and dreamers connecting to launch startups and pitch to investors.',
      mission: 'Turn bold ideas into ventures that create jobs and impact across the continent.',
      meetingCadence: 'Every Saturday, 10:00 AM',
      leaderName: 'Kwame Asante',
      leaderRole: 'Club President',
      icon: Icons.rocket_launch,
      color: Color(0xFF5A3A1A),
      chatId: '1',
      organizerKeywords: ['Entrepreneurship', 'Startup'],
    ),
  ];

  static const List<ClubMember> defaultMembers = [
    ClubMember(name: 'Amara Mensah', initials: 'AM', role: 'Member', color: Color(0xFF8A1A30)),
    ClubMember(name: 'James Kamau', initials: 'JK', role: 'Member', color: Color(0xFF4A6A38)),
    ClubMember(name: 'Sarah Mensah', initials: 'SM', role: 'Member', color: Color(0xFF4A3A2A)),
    ClubMember(name: 'David K.', initials: 'DK', role: 'Member', color: Color(0xFF3A3A3A)),
    ClubMember(name: 'Nneka Kalu', initials: 'NK', role: 'Member', color: Color(0xFF2A3A4A)),
  ];

  static const List<Announcement> announcements = [
    Announcement(
      id: 'a1',
      clubId: '5',
      title: 'Hackathon team forming',
      body: 'We need 2 more developers for the Climate Action Hackathon. DM in chat if interested!',
      time: '2h ago',
      isPinned: true,
    ),
    Announcement(
      id: 'a2',
      clubId: '5',
      title: 'Workshop moved to Room B',
      body: 'Today\'s AI workshop has been relocated to Innovation Hub, Room B due to maintenance.',
      time: 'Yesterday',
    ),
    Announcement(
      id: 'a3',
      clubId: '6',
      title: 'Pitch Night judges announced',
      body: 'Three venture partners from Kigali Innovation City will judge this Friday\'s pitch session.',
      time: 'Monday',
      isPinned: true,
    ),
    Announcement(
      id: 'a4',
      clubId: '1',
      title: 'New dataset challenge',
      body: 'This week\'s challenge uses real agricultural data from East Africa. Submit by Sunday.',
      time: 'Wed',
    ),
    Announcement(
      id: 'a5',
      clubId: '2',
      title: 'Campus clean-up this Saturday',
      body: 'Join us at 8 AM at the central courtyard. Gloves and bags provided.',
      time: 'Thu',
    ),
  ];

  static Club? findById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
