import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/event.dart';
import '../providers/rsvp_provider.dart';

class MyRsvpsScreen extends StatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen> {
  int _tabIndex = 0;

  final List<String> _tabs = ['Going', 'Interested', 'Past'];

  final List<Event> _pastEvents = [
    Event(
      id: 'past1',
      title: 'Advanced Data Analytics Seminar',
      organizer: 'ALU Data Science Guild',
      date: 'Thursday, Oct 24',
      time: '14:00 PM',
      location: 'Leadership Hall, West Wing',
      campus: 'Kigali Campus',
      description: '',
      tags: [],
      category: 'Workshop',
      goingCount: 33,
    ),
    Event(
      id: 'past2',
      title: 'Pan-African FinTech Challenge',
      organizer: 'ALU Finance Club',
      date: 'Sat, Oct 26 - Sun, Oct 27',
      time: 'All day',
      location: 'Innovation Hub, Level 2',
      campus: 'Kigali Campus',
      description: '',
      tags: [],
      category: 'Hackathon',
      goingCount: 78,
    ),
    Event(
      id: 'past3',
      title: "Founder's Networking Mixer",
      organizer: 'ALU Entrepreneurship Hub',
      date: 'Friday, Nov 1',
      time: '18:00 PM',
      location: 'The Sky Lounge, Rooftop',
      campus: 'Kigali Campus',
      description: '',
      tags: [],
      category: 'Social',
      goingCount: 120,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rsvp = Provider.of<RsvpProvider>(context);
    final goingEvents = MockEvents.all
        .where((e) => rsvp.isGoing(e.id))
        .toList();
    final interestedEvents = MockEvents.all
        .where((e) => rsvp.isInterested(e.id))
        .toList();

    List<Event> currentList;
    switch (_tabIndex) {
      case 0:
        currentList = goingEvents;
        break;
      case 1:
        currentList = interestedEvents;
        break;
      default:
        currentList = _pastEvents;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My RSVPs',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        actions: [
          const Icon(Icons.search, color: Colors.white60),
          const SizedBox(width: 8),
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: AppColors.burgundy,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 16),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xFF2A2018), width: 0.5)),
            ),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final isActive = _tabIndex == entry.key;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _tabIndex = entry.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isActive
                              ? AppColors.burgundy
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isActive
                            ? AppColors.burgundy
                            : Colors.white38,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Content
          Expanded(
            child: currentList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentList.length,
                    itemBuilder: (_, i) =>
                        _buildRsvpCard(currentList[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRsvpCard(Event event) {
    final isGoing = _tabIndex == 0 || _tabIndex == 2;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 140,
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2018),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined,
                      size: 40, color: Colors.white12),
                ),
              ),
              // Tags overlay
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  children: [
                    _overlayTag(event.category,
                        const Color(0xFFE8D898), const Color(0xFF4A4A18)),
                    const SizedBox(width: 8),
                    if (isGoing)
                      _overlayTag('⊙ Going', AppColors.burgundy, Colors.white),
                  ],
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: Colors.white38),
                  const SizedBox(width: 6),
                  Text('${event.date} • ${event.time}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white38)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: Colors.white38),
                  const SizedBox(width: 6),
                  Text(event.location,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white38)),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('View Ticket',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.white54)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _overlayTag(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor)),
    );
  }

  Widget _buildEmptyState() {
    final labels = [
      'Nothing here yet.\nStart exploring events to RSVP!',
      'No events marked as interested.\nBrowse events to mark interest.',
      'No past events yet.\nAttend events to see them here.',
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 56, color: Colors.white12),
            const SizedBox(height: 16),
            Text(
              labels[_tabIndex],
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.white38, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
