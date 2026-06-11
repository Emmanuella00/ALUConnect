import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/club.dart';
import '../providers/club_provider.dart';
import '../widgets/network_image_box.dart';
import '../widgets/user_avatar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _tabIndex = 0;

  List<Club> get _displayedClubs {
    final clubProvider = context.watch<ClubProvider>();
    if (_tabIndex == 1) {
      return clubProvider.joinedClubs;
    }
    return MockClubs.all;
  }

  @override
  Widget build(BuildContext context) {
    final clubProvider = context.watch<ClubProvider>();

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
                  (_, i) => _buildClubItem(_displayedClubs[i], clubProvider),
                  childCount: _displayedClubs.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-opportunity'),
        backgroundColor: AppColors.burgundy,
        tooltip: 'Post opportunity',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const UserAvatar(size: 36),
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
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/community-hub', arguments: '5'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1510),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            NetworkImageBox(
              imageUrl: 'https://picsum.photos/seed/ai-innovation-lab/800/450',
              height: 160,
              borderRadius: BorderRadius.circular(16),
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
                    onPressed: () =>
                        Navigator.pushNamed(context, '/community-hub', arguments: '5'),
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
              Align(
                alignment: Alignment.centerRight,
                widthFactor: 5 / 7,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2018),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFF1A1510), width: 1.5),
                  ),
                  child: Center(
                    child: Text('+45',
                        style: GoogleFonts.poppins(
                            fontSize: 8,
                            color: Colors.white54,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/community-hub', arguments: '6'),
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

  Widget _buildClubItem(Club club, ClubProvider clubProvider) {
    final isJoined = clubProvider.isJoined(club.id);
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/community-hub', arguments: club.id),
      child: Container(
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
                color: club.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(club.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(club.name,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Row(children: [
                    const Icon(Icons.people_outline,
                        size: 12, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text('${club.memberCount} members',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: Colors.white38)),
                  ]),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (isJoined) {
                  await clubProvider.toggleJoin(club.id);
                } else {
                  await clubProvider.toggleJoin(club.id);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You joined ${club.name}!',
                          style: GoogleFonts.poppins(color: Colors.white)),
                      backgroundColor: AppColors.navy,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isJoined ? Colors.transparent : AppColors.burgundy,
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
    final circle = Container(
      width: 28,
      height: 28,
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
    if (initials == 'AM') return circle;
    return Align(
      alignment: Alignment.centerRight,
      widthFactor: 5 / 7,
      child: circle,
    );
  }
}
