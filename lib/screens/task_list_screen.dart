import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../services/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/app_dialogs.dart';
import '../utils/constants.dart';

/// Tiimo‑style Task List Screen — filter chips, clean list with Explore feel.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _filter = 'all';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

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

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Task> _applyFilter(List<Task> tasks) {
    var result = tasks;
    if (_filter != 'all') {
      result = result.where((t) => t.status == _filter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                t.description.toLowerCase().contains(q),
          )
          .toList();
    }
    return result;
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await AppDialogs.showConfirmation(
      context: context,
      title: 'Delete Task',
      message:
          'Are you sure you want to delete "${task.title}"?\nThis action cannot be undone.',
    );
    if (!confirmed || !mounted) return;

    final success = await context.read<TaskProvider>().deleteTask(task.id!);
    if (!mounted) return;
    if (success) {
      await AppDialogs.showSuccess(
        context: context,
        message: '"${task.title}" has been deleted.',
      );
    } else {
      await AppDialogs.showError(
        context: context,
        message: 'Failed to delete task. Please try again.',
      );
    }
  }

  /// Format "2026-03-01" → "Mar 1"
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

  void _showTaskDetails(Task task) {
    AppDialogs.showBottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppConstants.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Emoji header
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppConstants.statusBgColor(
                  task.status,
                ).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  AppConstants.statusEmoji(task.status),
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            task.title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.statusBgColor(
                    task.status,
                  ).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.statusLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.statusColor(task.status),
                  ),
                ),
              ),
              const Spacer(),
              if (task.dueDate != null) ...[
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: AppConstants.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _shortDate(task.dueDate),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            task.description.isNotEmpty
                ? task.description
                : 'No description provided.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppConstants.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Edit'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/edit', arguments: task);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete_rounded, size: 18),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.errorColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteTask(task);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppConstants.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => context.read<TaskProvider>().fetchTasks(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryColor.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search tasks…',
                  hintStyle: GoogleFonts.poppins(
                    color: AppConstants.textLight,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppConstants.textSecondary,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── Filter chips ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    emoji: '📝',
                    selected: _filter == 'all',
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    emoji: '📋',
                    selected: _filter == 'pending',
                    onTap: () => setState(() => _filter = 'pending'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'In Progress',
                    emoji: '⏳',
                    selected: _filter == 'in_progress',
                    onTap: () => setState(() => _filter = 'in_progress'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Completed',
                    emoji: '✅',
                    selected: _filter == 'completed',
                    onTap: () => setState(() => _filter = 'completed'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Task list ──
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.tasks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('☁️', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text(
                            'Could not load tasks',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.error!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppConstants.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Retry'),
                            onPressed: () => provider.fetchTasks(),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filtered = _applyFilter(provider.tasks);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text(
                          provider.tasks.isEmpty
                              ? 'No tasks yet'
                              : 'No matching tasks',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (provider.tasks.isEmpty)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create Your First Task'),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/add'),
                          ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppConstants.primaryColor,
                  onRefresh: () => provider.fetchTasks(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final task = filtered[index];
                      return TaskCard(
                        task: task,
                        onTap: () => _showTaskDetails(task),
                        onEdit: () => Navigator.pushNamed(
                          context,
                          '/edit',
                          arguments: task,
                        ),
                        onDelete: () => _deleteTask(task),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // ── FAB ──
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_task_fab',
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'New Task',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        onPressed: () => Navigator.pushNamed(context, '/add'),
      ),
    );
  }
}

// ── Custom filter chip ──
class _FilterChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppConstants.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppConstants.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppConstants.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
