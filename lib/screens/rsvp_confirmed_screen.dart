// ─── rsvp_confirmed_screen.dart ───────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/event.dart';

class RsvpConfirmedScreen extends StatelessWidget {
  final Event event;
  const RsvpConfirmedScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        leading: const Icon(Icons.person, color: Colors.white60, size: 28),
        title: Text('ALUConnect',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.burgundy)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_outlined, color: Colors.white60),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              // Checkmark circle
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                "You're going!",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your spot for the event has been secured.\nWe\'ve sent a confirmation to your student email.',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.white54, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              // Event card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBeige,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2018),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.image_outlined,
                            size: 40, color: Colors.white12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0DED2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.category,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: Colors.black45),
                      const SizedBox(width: 6),
                      Text('${event.date} • ${event.time}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.black54)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.black45),
                      const SizedBox(width: 6),
                      Text('${event.campus}, ${event.location}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.black54)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Add to calendar
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today,
                      color: Colors.white, size: 18),
                  label: Text('Add to calendar',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.burgundy,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/main', (_) => false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                  ),
                  child: Text('Back to feed',
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.white54)),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: 'Need to cancel or update your RSVP? ',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white38),
                    children: [
                      TextSpan(
                        text: 'Manage Registration',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.burgundy,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
