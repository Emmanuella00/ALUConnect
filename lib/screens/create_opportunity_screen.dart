import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../constants/colors.dart';
import '../models/event.dart';
import '../providers/opportunity_provider.dart';
import '../widgets/opportunity_preview_card.dart';
import '../widgets/step_progress_bar.dart';

class CreateOpportunityScreen extends StatefulWidget {
  const CreateOpportunityScreen({super.key});

  @override
  State<CreateOpportunityScreen> createState() => _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizerController = TextEditingController();
  final _tagsController = TextEditingController();

  int _currentStep = 0;
  bool _isPublishing = false;
  String? _selectedType;
  String _selectedCampus = 'Kigali Campus';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _stepLabels = ['Choose type', 'Add details', 'Preview & publish'];

  final List<Map<String, String>> _opportunityTypes = [
    {'label': 'Events', 'category': 'Events'},
    {'label': 'Workshops', 'category': 'Workshops'},
    {'label': 'Internships', 'category': 'Internships'},
    {'label': 'Hackathons', 'category': 'Hackathons'},
    {'label': 'Leadership', 'category': 'Workshops'},
    {'label': 'Startup', 'category': 'Events'},
    {'label': 'Announcement', 'category': 'Events'},
  ];

  @override
  void initState() {
    super.initState();
    _loadOrganizerName();
  }

  Future<void> _loadOrganizerName() async {
    final prefs = await SharedPreferences.getInstance();
    final first = prefs.getString('user_first_name') ?? '';
    final last = prefs.getString('user_last_name') ?? '';
    final campus = prefs.getString('user_campus');
    if (mounted) {
      setState(() {
        if (first.isNotEmpty || last.isNotEmpty) {
          _organizerController.text = '$first $last'.trim();
        }
        if (campus != null) {
          _selectedCampus = campus.contains('Mauritius')
              ? 'Mauritius Campus'
              : 'Kigali Campus';
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Event get _previewEvent {
    final type = _opportunityTypes.firstWhere(
      (t) => t['label'] == _selectedType,
      orElse: () => {'label': 'Events', 'category': 'Events'},
    );
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    return Event(
      id: 'preview',
      title: _titleController.text,
      organizer: _organizerController.text,
      date: _formatDate(_selectedDate),
      time: _formatTime(_selectedTime),
      location: _locationController.text,
      campus: _selectedCampus,
      description: _descriptionController.text,
      tags: tags,
      category: type['category']!,
      goingCount: 0,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  bool get _canGoNext {
    if (_currentStep == 0) return _selectedType != null;
    if (_currentStep == 1) return _formKey.currentState?.validate() ?? false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Post opportunity',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: StepProgressBar(
              currentStep: _currentStep,
              totalSteps: 3,
              labels: _stepLabels,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildStepContent(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildTypeStep();
      case 1:
        return _buildDetailsStep();
      default:
        return _buildPreviewStep();
    }
  }

  Widget _buildTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are you posting?',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Select the type of opportunity for ALU students.',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _opportunityTypes.map((type) {
            final label = type['label']!;
            final isSelected = _selectedType == label;
            return Semantics(
              label: 'Opportunity type $label',
              button: true,
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.burgundy : const Color(0xFF2A2018),
                    borderRadius: BorderRadius.circular(99),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.white60,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedType == null) ...[
          const SizedBox(height: 16),
          Text(
            'Please select a type to continue.',
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.burgundy),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field(
            controller: _titleController,
            label: 'Title',
            hint: 'e.g. ALU Startup Pitch Night',
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Title is required' : null,
          ),
          _field(
            controller: _organizerController,
            label: 'Organizer',
            hint: 'Your name or club name',
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Organizer is required' : null,
          ),
          _field(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Tell students what this opportunity is about...',
            maxLines: 4,
            validator: (v) => v == null || v.trim().length < 20
                ? 'Description must be at least 20 characters'
                : null,
          ),
          _field(
            controller: _locationController,
            label: 'Location',
            hint: 'e.g. Innovation Hub, Level 2',
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Location is required' : null,
          ),
          const SizedBox(height: 8),
          Text('Campus',
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70)),
          const SizedBox(height: 8),
          Row(
            children: [
              _campusChip('Kigali Campus'),
              const SizedBox(width: 10),
              _campusChip('Mauritius Campus'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _datePickerField()),
              const SizedBox(width: 12),
              Expanded(child: _timePickerField()),
            ],
          ),
          const SizedBox(height: 16),
          _field(
            controller: _tagsController,
            label: 'Tags (comma-separated)',
            hint: 'Entrepreneurship, Innovation',
          ),
        ],
      ),
    );
  }

  Widget _campusChip(String campus) {
    final isSelected = _selectedCampus == campus;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCampus = campus),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.navy : const Color(0xFF2A2018),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.burgundy : Colors.white12,
            ),
          ),
          child: Center(
            child: Text(
              campus.replaceAll(' Campus', ''),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _datePickerField() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.burgundy,
                surface: Color(0xFF1A1510),
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: _pickerBox(
        label: 'Date',
        value: _selectedDate == null ? 'Select date' : _formatDate(_selectedDate),
        hasError: _selectedDate == null,
      ),
    );
  }

  Widget _timePickerField() {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 14, minute: 0),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.burgundy,
                surface: Color(0xFF1A1510),
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedTime = picked);
      },
      child: _pickerBox(
        label: 'Time',
        value: _selectedTime == null ? 'Select time' : _formatTime(_selectedTime),
        hasError: _selectedTime == null,
      ),
    );
  }

  Widget _pickerBox({
    required String label,
    required String value,
    bool hasError = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2018),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? AppColors.burgundy.withOpacity(0.5) : Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white38)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: value.startsWith('Select') ? Colors.white38 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
          hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF2A2018),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorStyle: GoogleFonts.poppins(fontSize: 11, color: AppColors.burgundy),
        ),
      ),
    );
  }

  Widget _buildPreviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview your post',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'This is how your opportunity will appear in the feed.',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54),
        ),
        const SizedBox(height: 20),
        OpportunityPreviewCard(event: _previewEvent),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1510),
        border: Border(top: BorderSide(color: Color(0xFF2A2018))),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _isPublishing
                  ? null
                  : () => setState(() => _currentStep--),
              child: Text(
                'Back',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            ),
          const Spacer(),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: !_canGoNext || _isPublishing ? null : _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.burgundy,
                disabledBackgroundColor: AppColors.burgundy.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28),
                elevation: 0,
              ),
              child: _isPublishing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == 2 ? 'Publish' : 'Next',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    if (_currentStep == 0) {
      setState(() => _currentStep++);
      return;
    }

    if (_currentStep == 1) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please select a date and time.',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: AppColors.navy,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep++);
      }
      return;
    }

    await _publish();
  }

  Future<void> _publish() async {
    setState(() => _isPublishing = true);

    final type = _opportunityTypes.firstWhere((t) => t['label'] == _selectedType);
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (_selectedType != null && !tags.contains(_selectedType)) {
      tags.insert(0, _selectedType!);
    }

    final event = Event(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      organizer: _organizerController.text.trim(),
      date: _formatDate(_selectedDate),
      time: _formatTime(_selectedTime),
      location: _locationController.text.trim(),
      campus: _selectedCampus,
      description: _descriptionController.text.trim(),
      tags: tags,
      category: type['category']!,
      goingCount: 0,
    );

    final success = await context.read<OpportunityProvider>().addOpportunity(event);
    if (!mounted) return;
    setState(() => _isPublishing = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to publish. Please try again.',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _publish,
          ),
        ),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1510),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.burgundy, size: 56),
            const SizedBox(height: 16),
            Text(
              'Opportunity published!',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Students can now discover and RSVP to your post.',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.burgundy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Back to feed',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
