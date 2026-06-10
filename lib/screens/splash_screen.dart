import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Logo
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.textBeige,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'A',
                    style: GoogleFonts.poppins(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'ALU Stride',
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBeige,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Do Hard Things.. the easy way.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              // Get started button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/onboarding'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.burgundy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Get started',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Already have account
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  child: Text(
                    'I already have an account',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'By continuing, you agree to our African Leadership\nUniversity community guidelines.',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.white30,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
