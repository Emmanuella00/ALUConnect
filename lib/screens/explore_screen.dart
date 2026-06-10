import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _tabIndex = 0;
  final Set<String> _joinedClubs = {'2'};

  final List<Map<String, dynamic>> _clubs = [
    {'id': '1', 'name': 'Data Science Guild', 'members': '892', 'icon': Icons.code, 'color': Color(0xFF8A1A30)},
    {'id': '2', 'name': 'Sustainability Hub', 'members': '1.2k', 'icon': Icons.eco, 'color': Color(0xFF2A4A1A)},
    {'id': '3', 'name': 'Creative Arts Collective', 'members': '456', 'icon': Icons.palette, 'color': Color(0xFF1A2A6A)},
    {'id': '4', 'name': 'Global Politics Forum', 'members': '328', 'icon': Icons.account_balance, 'color': Color(0xFF3A3A3A)},
    {'id': '5', 'name': 'AI Innovation Lab', 'members': '240', 'icon': Icons.psychology, 'color': Color(0xFF4A1A5A)},
    {'id': '6', 'name': 'Entrepreneurship Club', 'members': '342', 'icon': Icons.rocket_launch, 'color': Color(0xFF5A3A1A)},
  ];

  List<Map<String, dynamic>> get _displayedClubs {
    if (_tabIndex == 1) {
      return _clubs.where((c) => _joinedClubs.contains(c['id'])).toList();
    }
    return _clubs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildTabs()),
            SliverToBoxAdapter(child: _buildTrendingCard()),
            SliverToBoxAdapter(child: _buildStartupWeekend()),
            SliverToBoxAdapter(child: _buildRecommendedHeader()),
            if (_displayedClubs.isEmpty)
              SliverToBoxAdapter(child: _buildEmptyClubs())
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _buildClubItem(_displayedClubs[i]),
                  childCount: _displayedClubs.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.burgundy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.burgundy,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'ALUConnect',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.burgundy,
            ),
          ),
          const Spacer(),
          const Icon(Icons.notifications_outlined,
              color: Colors.white60, size: 24),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2018),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search communities, skills, or members',
            hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.white38),
            prefixIcon: const Icon(Icons.search, color: Colors.white38),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _tab('All clubs', 0),
          const SizedBox(width: 20),
          _tab('My clubs', 1),
        ],
      ),
    );
  }

  Widget _tab(String label, int index) {
    final isActive = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.white : Colors.white38,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            decoration: BoxDecoration(
              color: isActive ? AppColors.burgundy : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: const Color(0xFF2A2018),
              child: const Center(
                child: Icon(Icons.science, size: 60, color: Colors.white12),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.burgundy,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('TRENDING',
                  style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.8)),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The AI Innovation Lab',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Building the next generation of pan-African tech solutions. Join 240+ members today.',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.burgundy,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    elevation: 0,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Explore Lab',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartupWeekend() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.rocket_launch, color: AppColors.burgundy, size: 24),
          const SizedBox(height: 8),
          Text('Startup Weekend',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text('Pitch your idea and build a team in 48 hours. Registration closing soon!',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
          const SizedBox(height: 10),
          Row(
            children: [
              _stackAvatar('AM', AppColors.burgundy),
              _stackAvatar('JK', const Color(0xFF4A6A38)),
              _stackAvatar('TN', AppColors.navy),
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(left: -8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2018),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFF1A1510), width: 1.5),
                ),
                child: Center(
                  child: Text('+45',
                      style: GoogleFonts.poppins(
                          fontSize: 8,
                          color: Colors.white54,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text('Learn More',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.white54)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recommended for you',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text('View All',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.burgundy)),
            ],
          ),
          Text('Based on your interests in Engineering & Leadership',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildClubItem(Map<String, dynamic> club) {
    final isJoined = _joinedClubs.contains(club['id']);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: club['color'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(club['icon'] as IconData,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club['name'] as String,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Row(children: [
                  const Icon(Icons.people_outline,
                      size: 12, color: Colors.white38),
                  const SizedBox(width: 4),
                  Text('${club['members']} members',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: Colors.white38)),
                ]),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (isJoined) {
                  _joinedClubs.remove(club['id']);
                } else {
                  _joinedClubs.add(club['id'] as String);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('You joined ${club['name']}!',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    backgroundColor: AppColors.navy,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isJoined
                    ? Colors.transparent
                    : AppColors.burgundy,
                border: isJoined
                    ? Border.all(color: Colors.white24)
                    : null,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                isJoined ? '✓ Joined' : 'Join',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isJoined ? Colors.white54 : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyClubs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        children: [
          const Icon(Icons.group_off, size: 56, color: Colors.white12),
          const SizedBox(height: 16),
          Text('You haven\'t joined any clubs yet',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38)),
          const SizedBox(height: 8),
          Text('Explore communities and tap Join to get started.',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: Colors.white24),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _stackAvatar(String initials, Color color) {
    return Container(
      width: 28,
      height: 28,
      margin: EdgeInsets.only(left: initials == 'AM' ? 0 : -8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF1A1510), width: 1.5),
      ),
      child: Center(
        child: Text(initials,
            style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ),
    );
  }
}
