import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

/// Settings Screen — Tiimo‑style settings with soft cards, emoji icons,
/// toggles, dialogs, and various button types.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _biometrics = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppConstants.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // ── Appearance ──
          const _SectionHeader(emoji: '🎨', title: 'APPEARANCE'),
          _SettingsCard(
            children: [
              SwitchListTile(
                secondary: const Text('🌙', style: TextStyle(fontSize: 22)),
                title: Text(
                  'Dark Mode',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Use dark theme',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppConstants.textSecondary,
                  ),
                ),
                value: _darkMode,
                activeTrackColor: AppConstants.primaryColor,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              Divider(
                height: 1,
                color: AppConstants.primaryLight.withValues(alpha: 0.2),
              ),
              ListTile(
                leading: const Text('🌐', style: TextStyle(fontSize: 22)),
                title: Text(
                  'Language',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: _language,
                  underline: const SizedBox(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppConstants.textPrimary,
                  ),
                  items: ['English', 'Khmer', 'French']
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) => setState(() => _language = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Notifications ──
          const _SectionHeader(emoji: '🔔', title: 'NOTIFICATIONS'),
          _SettingsCard(
            children: [
              SwitchListTile(
                secondary: const Text('📬', style: TextStyle(fontSize: 22)),
                title: Text(
                  'Push Notifications',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                ),
                value: _notifications,
                activeTrackColor: AppConstants.primaryColor,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              Divider(
                height: 1,
                color: AppConstants.primaryLight.withValues(alpha: 0.2),
              ),
              SwitchListTile(
                secondary: const Text('🔒', style: TextStyle(fontSize: 22)),
                title: Text(
                  'Biometric Login',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                ),
                value: _biometrics,
                activeTrackColor: AppConstants.primaryColor,
                onChanged: (v) => setState(() => _biometrics = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Account ──
          const _SectionHeader(emoji: '👤', title: 'ACCOUNT'),
          _SettingsCard(
            children: [
              ListTile(
                leading: const Text('🔑', style: TextStyle(fontSize: 22)),
                title: Text(
                  'Change Password',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppConstants.textLight,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password change coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppConstants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
              Divider(
                height: 1,
                color: AppConstants.primaryLight.withValues(alpha: 0.2),
              ),
              ListTile(
                leading: const Text('🛡️', style: TextStyle(fontSize: 22)),
                title: Text(
                  'Privacy Policy',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimary,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppConstants.textLight,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardRadius,
                        ),
                      ),
                      title: Text(
                        '🛡️  Privacy Policy',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                      content: Text(
                        'Your privacy is important to us. TaskFlow does not '
                        'collect personal data beyond what is needed for '
                        'functionality. All data is transmitted securely.',
                        style: GoogleFonts.poppins(
                          color: AppConstants.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Close',
                            style: GoogleFonts.poppins(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Button showcase ──
          const _SectionHeader(emoji: '🎛️', title: 'BUTTON TYPES DEMO'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => _showSnack(context, 'ElevatedButton pressed'),
                child: Text('Elevated', style: GoogleFonts.poppins()),
              ),
              OutlinedButton(
                onPressed: () => _showSnack(context, 'OutlinedButton pressed'),
                child: Text('Outlined', style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () => _showSnack(context, 'TextButton pressed'),
                child: Text('Text', style: GoogleFonts.poppins()),
              ),
              IconButton(
                icon: const Text('👍', style: TextStyle(fontSize: 22)),
                onPressed: () => _showSnack(context, 'IconButton pressed'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Log Out (OutlinedButton) ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              icon: const Text('🚪', style: TextStyle(fontSize: 18)),
              label: Text(
                'Log Out',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFF6B6B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6B6B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.cardRadius,
                      ),
                    ),
                    title: Text(
                      '🚪  Log Out',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to log out?',
                      style: GoogleFonts.poppins(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Logged out (demo)',
                                style: GoogleFonts.poppins(),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppConstants.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Log Out',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins()),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppConstants.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Soft rounded card wrapper ──
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Column(children: children),
      ),
    );
  }
}

// ── Section header with emoji ──
class _SectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  const _SectionHeader({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
