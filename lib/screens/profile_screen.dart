import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';

/// Tiimo‑style Profile Screen — soft gradient header, clean form.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Dara Student');
  final _emailCtrl = TextEditingController(text: 'dara@university.edu');
  final _phoneCtrl = TextEditingController(text: '+855 12 345 678');
  bool _isEditing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppConstants.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close_rounded : Icons.edit_rounded,
              color: AppConstants.primaryColor,
            ),
            tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            // ── Avatar with gradient circle ──
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 116,
                    height: 116,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          AppConstants.primaryLight,
                          AppConstants.accentPink,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryColor.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: 54,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=12',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Camera feature coming soon!'),
                            ),
                          );
                        },
                        constraints: const BoxConstraints(
                          minWidth: 34,
                          minHeight: 34,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Dara Student',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Computer Science — Year 4',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: 28),

            // ── Form ──
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameCtrl,
                    label: 'Full Name',
                    prefixIcon: Icons.person_rounded,
                    validator: Validators.required,
                  ),
                  CustomTextField(
                    controller: _emailCtrl,
                    label: 'Email',
                    prefixIcon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  CustomTextField(
                    controller: _phoneCtrl,
                    label: 'Phone',
                    prefixIcon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    validator: Validators.required,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_isEditing) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Changes'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isEditing = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Profile updated successfully!'),
                          backgroundColor: AppConstants.successColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _isEditing = false),
                child: Text(
                  'Discard Changes',
                  style: GoogleFonts.poppins(color: AppConstants.textSecondary),
                ),
              ),
            ] else ...[
              _InfoCard(
                emoji: '🏫',
                title: 'University',
                subtitle: 'Royal University of Phnom Penh',
              ),
              _InfoCard(
                emoji: '📱',
                title: 'Course',
                subtitle: 'CS361 — Mobile App Development',
              ),
              _InfoCard(
                emoji: '📅',
                title: 'Semester',
                subtitle: 'Spring 2026',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppConstants.accentLavender.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppConstants.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppConstants.textSecondary,
          ),
        ),
      ),
    );
  }
}
