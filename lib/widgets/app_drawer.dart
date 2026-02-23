import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

/// Tiimo‑style Drawer with gradient header.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppConstants.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Gradient header ──
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9B8EC5), Color(0xFFB8ACE6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=12',
                ),
              ),
            ),
            accountName: Text(
              'Dara Student',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            accountEmail: Text(
              'dara@university.edu',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
          _DrawerItem(
            emoji: '☀️',
            title: 'Today',
            onTap: () => _navigate(context, '/'),
          ),
          _DrawerItem(
            emoji: '📝',
            title: 'Tasks',
            onTap: () => _navigate(context, '/tasks'),
          ),
          _DrawerItem(
            emoji: '➕',
            title: 'Add Task',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add');
            },
          ),
          _DrawerItem(
            emoji: '👤',
            title: 'Profile',
            onTap: () => _navigate(context, '/profile'),
          ),
          const Divider(indent: 16, endIndent: 16),
          _DrawerItem(
            emoji: '⚙️',
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          _DrawerItem(
            emoji: 'ℹ️',
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: AppConstants.appName,
                applicationVersion: '1.0.0',
                applicationIcon: const Text(
                  '✓',
                  style: TextStyle(fontSize: 36),
                ),
                children: [
                  Text(
                    'TaskFlow is a modern task management app built with '
                    'Flutter and Laravel REST API for the CS361 final project.',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

class _DrawerItem extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
