import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../services/task_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/app_dialogs.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

/// Edit Task Screen — Tiimo‑style form to update a task (PUT to API).
class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late String _status;
  DateTime? _dueDate;
  bool _isSaving = false;

  static const _statuses = {
    'pending': 'Pending',
    'in_progress': 'In Progress',
    'completed': 'Completed',
  };

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title);
    _descCtrl = TextEditingController(text: widget.task.description);
    _status = widget.task.status;
    if (widget.task.dueDate != null) {
      try {
        _dueDate = DateTime.parse(widget.task.dueDate!);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppConstants.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedTask = widget.task.copyWith(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: _status,
      dueDate: _dueDate != null
          ? '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}'
          : widget.task.dueDate,
    );

    final success = await context.read<TaskProvider>().updateTask(updatedTask);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      await AppDialogs.showSuccess(
        context: context,
        message: 'Task updated successfully!',
      );
      if (mounted) Navigator.pop(context);
    } else {
      await AppDialogs.showError(
        context: context,
        message: 'Failed to update task. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppConstants.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Color(0xFFFF6B6B)),
            tooltip: 'Delete Task',
            onPressed: () async {
              final nav = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final provider = context.read<TaskProvider>();
              final confirmed = await AppDialogs.showConfirmation(
                context: context,
                title: 'Delete Task',
                message: 'Delete "${widget.task.title}"?',
              );
              if (!confirmed || !mounted) return;
              await provider.deleteTask(widget.task.id!);
              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(
                  content: const Text('Task deleted.'),
                  backgroundColor: AppConstants.successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              nav.pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Emoji header ──
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppConstants.statusBgColor(
                      _status,
                    ).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      AppConstants.statusEmoji(_status),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Task Title ──
              CustomTextField(
                controller: _titleCtrl,
                label: 'Task Title',
                hint: 'Enter task title',
                prefixIcon: Icons.title_rounded,
                validator: Validators.minLength3,
              ),

              // ── Description ──
              CustomTextField(
                controller: _descCtrl,
                label: 'Description',
                hint: 'Enter task description',
                prefixIcon: Icons.description_rounded,
                maxLines: 3,
                validator: Validators.required,
              ),

              // ── Due Date Picker ──
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      labelStyle: GoogleFonts.poppins(
                        color: AppConstants.textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.calendar_today_rounded,
                        color: AppConstants.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppConstants.primaryLight.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppConstants.primaryLight.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: AppConstants.backgroundColor,
                    ),
                    child: Text(
                      _dueDate != null
                          ? '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}'
                          : 'Select due date',
                      style: GoogleFonts.poppins(
                        color: _dueDate != null
                            ? AppConstants.textPrimary
                            : AppConstants.textLight,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Status dropdown ──
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: DropdownButtonFormField<String>(
                  initialValue: _status,
                  style: GoogleFonts.poppins(
                    color: AppConstants.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: GoogleFonts.poppins(
                      color: AppConstants.textSecondary,
                    ),
                    prefixIcon: const Icon(
                      Icons.flag_rounded,
                      color: AppConstants.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppConstants.primaryLight.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppConstants.primaryLight.withValues(alpha: 0.3),
                      ),
                    ),
                    filled: true,
                    fillColor: AppConstants.backgroundColor,
                  ),
                  items: _statuses.entries.map((e) {
                    return DropdownMenuItem(value: e.key, child: Text(e.value));
                  }).toList(),
                  onChanged: (v) => setState(() => _status = v!),
                ),
              ),

              // ── Save ──
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    _isSaving ? 'Saving…' : 'Update Task',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: _isSaving ? null : _submit,
                ),
              ),
              const SizedBox(height: 12),

              // ── Cancel ──
              SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
