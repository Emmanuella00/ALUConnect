import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/user_provider.dart';
import '../widgets/network_image_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _selectedCampus;
  double _passwordStrength = 0;

  final List<String> _campuses = ['Kigali Campus', 'Mauritius Campus'];

  void _updatePasswordStrength(String value) {
    double strength = 0;
    if (value.length >= 6) strength += 0.25;
    if (value.length >= 10) strength += 0.25;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (value.contains(RegExp(r'[0-9!@#\$%^&*]'))) strength += 0.25;
    setState(() => _passwordStrength = strength);
  }

  Color get _strengthColor {
    if (_passwordStrength <= 0.25) return Colors.red;
    if (_passwordStrength <= 0.5) return Colors.orange;
    if (_passwordStrength <= 0.75) return Colors.yellow;
    return Colors.green;
  }

  String get _strengthLabel {
    if (_passwordStrength == 0) return 'Enter password';
    if (_passwordStrength <= 0.25) return 'Weak';
    if (_passwordStrength <= 0.5) return 'Fair';
    if (_passwordStrength <= 0.75) return 'Good';
    return 'Strong';
  }

 void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      // Save user data with SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_first_name', _firstNameController.text);
      await prefs.setString('user_last_name', _lastNameController.text);
      await prefs.setString('user_email', _emailController.text);
      await prefs.setString('user_campus', _selectedCampus!);

      if (mounted) {
        await context.read<UserProvider>().load();
      }

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  InputDecoration _fieldDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          GoogleFonts.poppins(color: Colors.white30, fontSize: 13),
      prefixIcon: prefix,
      filled: true,
      fillColor: const Color(0xFF2A2018),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.burgundy, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: GoogleFonts.poppins(fontSize: 11, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero image
              const NetworkImageBox(
                imageUrl: 'https://picsum.photos/seed/alu-campus/800/450',
                height: 160,
              ),
              // Form card
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1510),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Create account',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Join the ALU community',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // First + Last name
                        _label('First name'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _firstNameController,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                          decoration: _fieldDecoration('John'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'First name is required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _label('Last name'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _lastNameController,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                          decoration: _fieldDecoration('Doe'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Last name is required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _label('Student email'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                          decoration: _fieldDecoration(
                            'j.doe@alustudent.com',
                            prefix: const Icon(Icons.mail_outline,
                                color: Colors.white38, size: 20),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Email is required';
                            }
                            if (!v.endsWith('@alustudent.com') &&
                                !v.endsWith('@alueducation.com')) {
                              return 'Must be an ALU student email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _label('Campus'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCampus,
                          dropdownColor: const Color(0xFF2A2018),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                          decoration: _fieldDecoration(
                            '',
                            prefix: const Icon(Icons.location_on_outlined,
                                color: Colors.white38, size: 20),
                          ),
                          hint: Text(
                            'Select your campus',
                            style: GoogleFonts.poppins(
                                color: Colors.white30, fontSize: 13),
                          ),
                          items: _campuses
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCampus = v),
                          validator: (v) =>
                              v == null ? 'Please select your campus' : null,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.white54),
                        ),
                        const SizedBox(height: 12),
                        _label('Password'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onChanged: _updatePasswordStrength,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                          decoration: _fieldDecoration(
                            '••••••••',
                            prefix: const Icon(Icons.lock_outline,
                                color: Colors.white38, size: 20),
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white38,
                                size: 20,
                              ),
                              onPressed: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password is required';
                            }
                            if (v.length < 6) {
                              return 'Must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        // Password strength bar
                        LinearProgressIndicator(
                          value: _passwordStrength,
                          backgroundColor: Colors.white12,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(_strengthColor),
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Security level: $_strengthLabel',
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: Colors.white38),
                        ),
                        const SizedBox(height: 24),
                        // Create account button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _createAccount,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 18),
                            label: Text(
                              'Create account',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.burgundy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.white54),
                                children: [
                                  TextSpan(
                                    text: 'Sign in',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: AppColors.burgundy,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Trust badges
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _trustBadge(
                        Icons.shield_outlined,
                        'Secure Hub',
                        'End-to-end encryption',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _trustBadge(
                        Icons.school_outlined,
                        'Verified Access',
                        'ALU Students Only',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    );
  }

  Widget _trustBadge(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1510),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.burgundy.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.burgundy, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
