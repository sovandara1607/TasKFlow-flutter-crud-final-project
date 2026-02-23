import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../services/task_provider.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';

/// Tiimo‑style Home Screen — "Today" view with date header, stats and tasks.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TaskProvider>();
      if (provider.tasks.isEmpty && !provider.isLoading) {
        provider.fetchTasks();
      }
    });
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = _weekdays[now.weekday - 1];
    final monthName = _months[now.month - 1];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✓ ', style: TextStyle(fontSize: 20)),
            Text(
              AppConstants.appName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: AppConstants.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: AppConstants.primaryColor,
        onRefresh: () => context.read<TaskProvider>().fetchTasks(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Date header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    Text(
                      '$monthName ${now.day}, ${now.year}',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppConstants.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Greeting card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B8EC5), Color(0xFFB8ACE6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppConstants.cardRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withValues(
                          alpha: 0.25,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting()}, Dara! 👋',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'What\'s your plan today?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: Text(
                            'New Task',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppConstants.primaryColor,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () => Navigator.pushNamed(context, '/add'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Stats row ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<TaskProvider>(
                  builder: (_, provider, _) => Row(
                    children: [
                      _StatBubble(
                        emoji: '📋',
                        value: '${provider.totalTasks}',
                        label: 'Total',
                        color: AppConstants.accentLavender,
                      ),
                      const SizedBox(width: 10),
                      _StatBubble(
                        emoji: '⏳',
                        value: '${provider.pendingTasks}',
                        label: 'Pending',
                        color: AppConstants.accentPeach,
                      ),
                      const SizedBox(width: 10),
                      _StatBubble(
                        emoji: '🔄',
                        value: '${provider.inProgressTasks}',
                        label: 'Active',
                        color: AppConstants.accentSky,
                      ),
                      const SizedBox(width: 10),
                      _StatBubble(
                        emoji: '✅',
                        value: '${provider.completedTasks}',
                        label: 'Done',
                        color: AppConstants.accentMint,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Task sections ──
              Consumer<TaskProvider>(
                builder: (_, provider, _) {
                  if (provider.isLoading && provider.tasks.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (provider.tasks.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: Column(
                          children: [
                            Text('🌤️', style: const TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text(
                              'No tasks yet',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap + to create your first task',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppConstants.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final pending = provider.tasks
                      .where((t) => t.status == 'pending')
                      .toList();
                  final inProgress = provider.tasks
                      .where((t) => t.status == 'in_progress')
                      .toList();
                  final completed = provider.tasks
                      .where((t) => t.status == 'completed')
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pending.isNotEmpty) ...[
                        _SectionHeader(
                          emoji: '📋',
                          title: 'PENDING',
                          count: pending.length,
                        ),
                        ...pending.map(
                          (t) => _MiniTaskTile(task: t, context: context),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (inProgress.isNotEmpty) ...[
                        _SectionHeader(
                          emoji: '⏳',
                          title: 'IN PROGRESS',
                          count: inProgress.length,
                        ),
                        ...inProgress.map(
                          (t) => _MiniTaskTile(task: t, context: context),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (completed.isNotEmpty) ...[
                        _SectionHeader(
                          emoji: '✅',
                          title: 'COMPLETED',
                          count: completed.length,
                        ),
                        ...completed.map(
                          (t) => _MiniTaskTile(task: t, context: context),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat bubble ──
class _StatBubble extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatBubble({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppConstants.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header (like Tiimo's MORNING / AFTERNOON) ──
class _SectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final int count;

  const _SectionHeader({
    required this.emoji,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppConstants.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: AppConstants.primaryLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini task tile for the home screen ──
class _MiniTaskTile extends StatelessWidget {
  final Task task;
  final BuildContext context;

  const _MiniTaskTile({required this.task, required this.context});

  String _shortDate(String? raw) {
    if (raw == null) return '';
    try {
      final d = DateTime.parse(raw);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[d.month - 1]} ${d.day}';
    } catch (_) {
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }

  @override
  Widget build(BuildContext _) {
    final isCompleted = task.status == 'completed';
    final bgColor = AppConstants.statusBgColor(task.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, '/edit', arguments: task),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bgColor.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      AppConstants.statusEmoji(task.status),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimary,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: AppConstants.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.dueDate != null)
                        Text(
                          _shortDate(task.dueDate),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppConstants.successColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isCompleted
                          ? AppConstants.successColor
                          : AppConstants.textLight,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
