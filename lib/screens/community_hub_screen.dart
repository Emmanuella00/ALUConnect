import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/club.dart';
import '../models/event.dart';
import '../providers/club_provider.dart';
import '../providers/opportunity_provider.dart';
import '../widgets/empty_state_widget.dart';
import 'chat_list_screen.dart';

class CommunityHubScreen extends StatefulWidget {
  final String clubId;

  const CommunityHubScreen({super.key, required this.clubId});

  @override
  State<CommunityHubScreen> createState() => _CommunityHubScreenState();
}

class _CommunityHubScreenState extends State<CommunityHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _memberSearchController = TextEditingController();
  String _memberQuery = '';

  Club get _club => MockClubs.findById(widget.clubId)!;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _memberSearchController.dispose();
    super.dispose();
  }

  List<Event> _clubEvents(BuildContext context) {
    final all = context.read<OpportunityProvider>().getAllEvents();
    return all.where((event) {
      final organizer = event.organizer.toLowerCase();
      return _club.organizerKeywords
          .any((kw) => organizer.contains(kw.toLowerCase()));
    }).toList();
  }

  List<Announcement> get _announcements =>
      MockClubs.announcements.where((a) => a.clubId == widget.clubId).toList();

  List<ClubMember> get _filteredMembers {
    if (_memberQuery.isEmpty) return MockClubs.defaultMembers;
    return MockClubs.defaultMembers
        .where((m) => m.name.toLowerCase().contains(_memberQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final clubProvider = context.watch<ClubProvider>();
    final isJoined = clubProvider.isJoined(widget.clubId);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white70),
                tooltip: 'Open club chat',
                onPressed: () => _openChat(isJoined),
              ),
            ],
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(isJoined, clubProvider),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.burgundy,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white38,
              labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Events'),
                Tab(text: 'Members'),
                Tab(text: 'News'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAboutTab(isJoined, clubProvider),
            _buildEventsTab(),
            _buildMembersTab(),
            _buildAnnouncementsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isJoined, ClubProvider clubProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_club.color.withOpacity(0.6), AppColors.backgroundDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _club.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_club.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _club.name,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.people_outline, size: 12, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text(
                          '${_club.memberCount} members',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              _club.campus,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(bool isJoined, ClubProvider clubProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leaderCard(),
          const SizedBox(height: 16),
          Text(
            'About',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _club.description,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white60, height: 1.5),
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.flag_outlined, 'Mission', _club.mission),
          const SizedBox(height: 10),
          _infoRow(Icons.schedule, 'Meetings', _club.meetingCadence),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _toggleJoin(clubProvider, isJoined),
              style: ElevatedButton.styleFrom(
                backgroundColor: isJoined ? Colors.transparent : AppColors.burgundy,
                foregroundColor: Colors.white,
                side: isJoined ? const BorderSide(color: Colors.white24) : null,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: Text(
                isJoined ? 'Leave community' : 'Join community',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _openChat(isJoined),
            icon: const Icon(Icons.chat, size: 18),
            label: Text('Open club chat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.burgundy.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _club.color,
            child: Text(
              _club.leaderName.split(' ').map((w) => w[0]).take(2).join(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leadership spotlight',
                  style: GoogleFonts.poppins(fontSize: 10, color: AppColors.burgundy),
                ),
                Text(
                  _club.leaderName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _club.leaderRole,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.burgundy),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              Text(value,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    final events = _clubEvents(context);
    if (events.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.event_busy,
        title: 'No events yet',
        subtitle: 'Check back soon or ask the club leader to post an opportunity.',
        actionLabel: 'Post an opportunity',
        onAction: () => Navigator.pushNamed(context, '/create-opportunity'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (_, i) {
        final event = events[i];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/event-detail', arguments: event),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBeige,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${event.date} • ${event.location}',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMembersTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _memberSearchController,
            onChanged: (v) => setState(() => _memberQuery = v),
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search members',
              hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF2A2018),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredMembers.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.person_off,
                  title: 'No members found',
                  subtitle: 'Try a different search term.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredMembers.length,
                  itemBuilder: (_, i) {
                    final member = _filteredMembers[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1510),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: member.color,
                            child: Text(
                              member.initials,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  member.role,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsTab() {
    final clubProvider = context.watch<ClubProvider>();
    if (_announcements.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.campaign_outlined,
        title: 'No announcements yet',
        subtitle: 'Club leaders can post updates here for members.',
      );
    }

    final sorted = [..._announcements]
      ..sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (_, i) {
        final announcement = sorted[i];
        final helpful = clubProvider.helpfulCount(announcement.id);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1510),
            borderRadius: BorderRadius.circular(14),
            border: announcement.isPinned
                ? Border.all(color: AppColors.burgundy.withOpacity(0.4))
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (announcement.isPinned)
                Text(
                  'PINNED',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.burgundy,
                    letterSpacing: 0.8,
                  ),
                ),
              Text(
                announcement.title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                announcement.body,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white60,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    announcement.time,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white38),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => clubProvider.markHelpful(announcement.id),
                    child: Row(
                      children: [
                        Icon(
                          helpful > 0 ? Icons.thumb_up : Icons.thumb_up_outlined,
                          size: 16,
                          color: helpful > 0 ? AppColors.burgundy : Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          helpful > 0 ? '$helpful Helpful' : 'Helpful',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: helpful > 0 ? AppColors.burgundy : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openChat(bool isJoined) {
    if (!isJoined) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Join ${_club.name} first to access the chat.',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationScreen(chat: _club.toChatMap()),
      ),
    );
  }

  Future<void> _toggleJoin(ClubProvider provider, bool isJoined) async {
    if (isJoined) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1A1510),
          title: Text('Leave community?',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
          content: Text(
            'You will lose access to ${_club.name} chat and updates.',
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Leave', style: GoogleFonts.poppins(color: AppColors.burgundy)),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    await provider.toggleJoin(widget.clubId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isJoined ? 'You left ${_club.name}' : 'Welcome to ${_club.name}!',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: AppColors.navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
