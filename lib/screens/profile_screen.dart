import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/rsvp_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> _interests = [
    {'label': 'Student Leadership', 'color': Color(0xFF4A5A28), 'bg': Color(0xFFA8A848)},
    {'label': 'Pan-Africanism', 'color': Color(0xFF6A0A40), 'bg': Color(0xFFF4C0D0)},
    {'label': 'Entrepreneurship', 'color': Color(0xFF3A3A3A), 'bg': Color(0xFFD8D8D0)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildProfileHeader()),
            SliverToBoxAdapter(child: _buildStats()),
            SliverToBoxAdapter(child: _buildInterests()),
            SliverToBoxAdapter(child: _buildMenuItems()),
            SliverToBoxAdapter(child: _buildSignOut()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ALUConnect',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          Row(
            children: [
              const Icon(Icons.notifications_outlined,
                  color: Colors.white60, size: 24),
              const SizedBox(width: 16),
              const Icon(Icons.settings_outlined,
                  color: Colors.white60, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.burgundy,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('AM',
                      style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2018),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.backgroundDark, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Amara Mensah',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.white38),
              const SizedBox(width: 4),
              Text('Kigali Campus',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.white38)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A3A),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppColors.navyLight),
            ),
            child: Text('amara.mensah@alueducation.com',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.white54)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final eventsAttending = context.watch<RsvpProvider>().rsvpedIds.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('$eventsAttending', 'Events'),
          Container(width: 1, height: 32, color: Colors.white12),
          _statItem('5', 'Communities'),
          Container(width: 1, height: 32, color: Colors.white12),
          _statItem('87', 'Connections'),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.burgundy,
            )),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.white38)),
      ],
    );
  }

  Widget _buildInterests() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Interests',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._interests.map((i) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: (i['bg'] as Color).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                          color: (i['bg'] as Color).withOpacity(0.5)),
                    ),
                    child: Text(
                      i['label'] as String,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: i['bg'] as Color,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text('+ Add New',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white38)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    final items = [
      {'icon': Icons.calendar_today_outlined, 'label': 'My RSVPs', 'route': '/my-rsvps'},
      {'icon': Icons.bookmark_border, 'label': 'Saved events', 'route': null},
      {'icon': Icons.star_border, 'label': 'My reviews', 'route': null},
      {'icon': Icons.manage_accounts_outlined, 'label': 'Account settings', 'route': null},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return GestureDetector(
            onTap: () {
              if (item['route'] != null) {
                Navigator.pushNamed(context, item['route'] as String);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: i < items.length - 1
                    ? const Border(
                        bottom: BorderSide(color: Color(0xFF2A2018), width: 0.5))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.burgundy.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item['icon'] as IconData,
                        color: AppColors.burgundy, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item['label'] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.white)),
                  ),
                  const Icon(Icons.chevron_right,
                      color: Colors.white24, size: 22),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSignOut() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: () =>
            Navigator.pushReplacementNamed(context, '/splash'),
        title: Center(
          child: Text('Sign Out',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.burgundy,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
