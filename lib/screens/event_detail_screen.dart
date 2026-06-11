import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/event.dart';
import '../providers/rsvp_provider.dart';
import '../widgets/network_image_box.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final rsvp = Provider.of<RsvpProvider>(context);
    final isGoing = rsvp.isGoing(event.id);
    final isInterested = rsvp.isInterested(event.id);
    final isSaved = rsvp.isSaved(event.id);

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navy,
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.share_outlined,
                              color: Colors.white60, size: 22),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => rsvp.toggleSave(event.id),
                            child: Icon(
                              isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color:
                                  isSaved ? AppColors.burgundy : Colors.white60,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _categoryTag(event.category),
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
                  const SizedBox(height: 6),
                  Text(
                    'Organized by ${event.organizer}',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Hero(
              tag: 'event-image-${event.id}',
              child: NetworkImageBox(imageUrl: event.imageUrl, height: 200),
            ),
          ),
          // Details body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  _infoRow(Icons.calendar_today_outlined,
                      '${event.date}\n${event.time}'),
                  const SizedBox(height: 12),
                  // Location
                  _infoRow(Icons.location_on_outlined,
                      '${event.location}\n${event.campus}'),
                  const SizedBox(height: 20),
                  // Attendees
                  Row(
                    children: [
                      _attendeeCircle('AM', AppColors.burgundy),
                      _attendeeCircle('JK', const Color(0xFF4A6A38)),
                      _attendeeCircle('TN', AppColors.navy),
                      const SizedBox(width: 8),
                      Text(
                        '${event.goingCount} are going',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About the Event',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF3A3020),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: event.tags
                        .map((t) => _tagChip(t))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  // Map placeholder
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAD8CC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.map_outlined,
                          size: 40, color: Colors.black26),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom RSVP bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: const BoxDecoration(
          color: AppColors.backgroundBeige,
          border: Border(
              top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isGoing
              ? _goingConfirmation(context)
              : Row(
                  key: const ValueKey('rsvp-actions'),
                  children: [
                  // Interested button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        rsvp.markInterested(event.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Marked as interested!',
                                style: GoogleFonts.poppins(
                                    color: Colors.white)),
                            backgroundColor: AppColors.navy,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isInterested
                              ? AppColors.burgundy
                              : Colors.black26,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          isInterested ? '✓ Interested' : 'Interested',
                          key: ValueKey(isInterested),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isInterested
                                ? AppColors.burgundy
                                : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // RSVP button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        rsvp.rsvp(event.id);
                        Navigator.pushNamed(context, '/rsvp-confirmed',
                            arguments: event);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.burgundy,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99)),
                        elevation: 0,
                      ),
                      child: Text(
                        "RSVP — I'm going",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Widget _goingConfirmation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            "You're going!",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.burgundy, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textDark, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendeeCircle(String initials, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      widthFactor: 0.75,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.backgroundBeige, width: 2),
        ),
        child: Center(
          child: Text(
            initials,
            style: GoogleFonts.poppins(
                fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _categoryTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.tagGreenBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tag,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _tagChip(String tag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE0DED2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        tag,
        style: GoogleFonts.poppins(
            fontSize: 12, color: AppColors.textDark),
      ),
    );
  }
}
