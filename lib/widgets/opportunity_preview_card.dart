import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/event.dart';

class OpportunityPreviewCard extends StatelessWidget {
  final Event event;

  const OpportunityPreviewCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBeige,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.burgundy.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              event.category.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.burgundy,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title.isEmpty ? 'Opportunity title' : event.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 12, color: Colors.black45),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${event.location.isEmpty ? 'Location' : event.location} • ${event.campus}',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.black45),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            event.date.isEmpty ? 'Date TBD' : '${event.date} • ${event.time}',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.black45),
          ),
          if (event.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: event.tags
                  .map(
                    (tag) => Container(
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
