import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/colors.dart';
import '../models/event.dart';
import '../providers/rsvp_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/network_image_box.dart';
import '../widgets/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _searchQuery = '';

  final List<String> _filters = [
    'All', 'Events', 'Workshops', 'Internships', 'Hackathons'
  ];

  @override
  void initState() {
    super.initState();
    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  List<Event> get _filteredEvents {
    List<Event> events = MockEvents.all.where((e) => !e.isFeatured).toList();
    if (_selectedFilter != 'All') {
      events = events.where((e) => e.category == _selectedFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      events = events
          .where((e) =>
              e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.tags.any((t) =>
                  t.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }
    return events;
  }

  Event get _featuredEvent =>
      MockEvents.all.firstWhere((e) => e.isFeatured);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildFilterPills()),
            SliverToBoxAdapter(
              child: _isLoading
                  ? _buildShimmerFeatured()
                  : _buildFeaturedCard(),
            ),
            SliverToBoxAdapter(child: _buildSectionHeader()),
            if (_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => _buildShimmerCard(),
                  childCount: 3,
                ),
              )
            else if (_filteredEvents.isEmpty)
              SliverToBoxAdapter(child: _buildEmptyState())
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _buildEventCard(_filteredEvents[i]),
                  childCount: _filteredEvents.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final firstName = context.watch<UserProvider>().firstName;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const UserAvatar(size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $firstName 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              const Icon(Icons.notifications_outlined,
                  color: Colors.white60, size: 26),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.burgundy,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2018),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search opportunities, events, or clubs',
            hintStyle:
                GoogleFonts.poppins(fontSize: 13, color: Colors.white38),
            prefixIcon: const Icon(Icons.search, color: Colors.white38),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (_, i) {
          final filter = _filters[i];
          final isActive = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.burgundy
                    : const Color(0xFF2A2018),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                filter,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? Colors.white : Colors.white60,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCard() {
    final event = _featuredEvent;
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/event-detail', arguments: event),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            NetworkImageBox(
              imageUrl: event.imageUrl,
              height: 220,
              borderRadius: BorderRadius.circular(16),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'FEATURED EVENT',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white60, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/event-detail',
                          arguments: event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.burgundy,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        elevation: 0,
                      ),
                      child: Text(
                        'View details',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Latest opportunities',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            'See all',
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.burgundy,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final rsvp = Provider.of<RsvpProvider>(context);
    final isGoing = rsvp.isGoing(event.id);
    final isSaved = rsvp.isSaved(event.id);

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/event-detail', arguments: event),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBeige,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            SizedBox(
              width: 64,
              height: 64,
              child: NetworkImageBox(
                imageUrl: event.imageUrl,
                height: 64,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 10),
            // Date badge
            _dateBadge(event.date),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => rsvp.toggleSave(event.id),
                        child: Icon(
                          isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: isSaved
                              ? AppColors.burgundy
                              : Colors.black38,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.black45),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${event.location} • ${event.campus}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      ...event.tags.map((tag) => _tagChip(tag)),
                      if (isGoing)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.burgundy,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '✓ Going',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateBadge(String dateStr) {
    final parts = dateStr.split(' ');
    String day = '';
    String month = '';
    Color bgColor = const Color(0xFF1A1510);
    Color textColor = AppColors.burgundy;

    if (parts.length >= 2) {
      for (final p in parts) {
        if (int.tryParse(p) != null) day = p;
        if (['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
            .contains(p.substring(0, p.length > 3 ? 3 : p.length))) {
          month = p.substring(0, p.length > 3 ? 3 : p.length).toUpperCase();
        }
      }
    }

    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            day.isEmpty ? '—' : day,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
              height: 1,
            ),
          ),
          Text(
            month.isEmpty ? '' : month,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6DA),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        tag,
        style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.white12),
          const SizedBox(height: 16),
          Text(
            'No opportunities found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different filter or check back later.',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white24),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerFeatured() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2018),
      highlightColor: const Color(0xFF3A3028),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2018),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2018),
      highlightColor: const Color(0xFF3A3028),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2018),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}