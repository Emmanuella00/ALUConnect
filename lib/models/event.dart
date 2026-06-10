class Event {
  final String id;
  final String title;
  final String organizer;
  final String date;
  final String time;
  final String location;
  final String campus;
  final String description;
  final List<String> tags;
  final String category;
  final int goingCount;
  final bool isFeatured;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.organizer,
    required this.date,
    required this.time,
    required this.location,
    required this.campus,
    required this.description,
    required this.tags,
    required this.category,
    required this.goingCount,
    this.isFeatured = false,
    this.imageUrl = '',
  });
}

class MockEvents {
  static List<Event> all = [
    Event(
      id: '1',
      title: 'ALU Startup Pitch Night',
      organizer: 'ALU Entrepreneurship Hub',
      date: 'Friday, Nov 1',
      time: '6:00 PM — 9:00 PM CAT',
      location: 'Innovation Hub, Level 2',
      campus: 'Kigali Campus',
      description:
          'Join the ecosystem of innovators. Pitch your idea to venture capitalists and win seed funding. This is your chance to showcase your startup idea to a panel of investors and mentors.',
      tags: ['Entrepreneurship', 'Innovation'],
      category: 'Events',
      goingCount: 89,
      isFeatured: true,
    ),
    Event(
      id: '2',
      title: 'Global Leadership Workshop',
      organizer: 'ALU Leadership Institute',
      date: 'Thursday, Oct 24',
      time: '2:00 PM — 5:00 PM CAT',
      location: 'Main Hall',
      campus: 'Mauritius Campus',
      description:
          'An immersive workshop designed to develop the next generation of African leaders. Featuring interactive sessions, case studies, and mentorship opportunities.',
      tags: ['Leadership', 'Workshop'],
      category: 'Workshops',
      goingCount: 54,
    ),
    Event(
      id: '3',
      title: 'Pan-African Tech Summit',
      organizer: 'ALU Tech Club',
      date: 'Monday, Oct 28',
      time: '9:00 AM — 6:00 PM CAT',
      location: 'Hybrid Event',
      campus: 'Zoom',
      description:
          'A summit bringing together tech innovators from across Africa to discuss the future of technology on the continent.',
      tags: ['Technology', 'Internships'],
      category: 'Events',
      goingCount: 210,
    ),
    Event(
      id: '4',
      title: 'Social Impact Hackathon',
      organizer: 'ALU Social Innovation Lab',
      date: 'Friday, Nov 2',
      time: '8:00 AM — 8:00 PM CAT',
      location: "Innovator's Space",
      campus: 'Kigali Campus',
      description:
          'Build solutions to Africa\'s most pressing challenges in 12 hours. Teams will work on problems in healthcare, education, and financial inclusion.',
      tags: ['Innovation', 'Hackathon'],
      category: 'Hackathons',
      goingCount: 67,
    ),
    Event(
      id: '5',
      title: 'AI for Social Impact',
      organizer: 'ALU AI Student Hub',
      date: 'Friday, October 24',
      time: '4:00 PM — 6:30 PM CAT',
      location: 'Innovation Hub, Level 2',
      campus: 'Kigali Campus',
      description:
          'Join us for an intensive workshop exploring how Artificial Intelligence can be leveraged to solve Africa\'s most pressing social challenges. We will delve into case studies from healthcare, agriculture, and financial inclusion, followed by a hands-on ideation session.',
      tags: ['Leadership', 'Technology', 'Innovation'],
      category: 'Workshops',
      goingCount: 48,
    ),
    Event(
      id: '6',
      title: 'Advanced Data Analytics Seminar',
      organizer: 'ALU Data Science Guild',
      date: 'Thursday, Oct 24',
      time: '14:00 PM CAT',
      location: 'Leadership Hall, West Wing',
      campus: 'Kigali Campus',
      description:
          'Deep dive into advanced data analytics techniques with industry practitioners. Hands-on sessions using real-world African datasets.',
      tags: ['Technology', 'Workshop'],
      category: 'Workshops',
      goingCount: 33,
    ),
    Event(
      id: '7',
      title: 'Pan-African FinTech Challenge',
      organizer: 'ALU Finance Club',
      date: 'Sat, Oct 26 - Sun, Oct 27',
      time: 'All day',
      location: 'Innovation Hub, Level 2',
      campus: 'Kigali Campus',
      description:
          'A two-day hackathon focused on building fintech solutions for the African market. Win funding and mentorship to launch your product.',
      tags: ['Technology', 'Innovation'],
      category: 'Hackathons',
      goingCount: 78,
    ),
    Event(
      id: '8',
      title: "Founder's Networking Mixer",
      organizer: 'ALU Entrepreneurship Hub',
      date: 'Friday, Nov 1',
      time: '18:00 PM',
      location: 'The Sky Lounge, Rooftop',
      campus: 'Kigali Campus',
      description:
          'Connect with fellow founders, investors, and mentors in a relaxed rooftop setting. Build your network and explore collaboration opportunities.',
      tags: ['Entrepreneurship', 'Networking'],
      category: 'Events',
      goingCount: 120,
    ),
  ];
}
