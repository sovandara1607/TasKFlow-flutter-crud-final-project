import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../services/task_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/app_dialogs.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

/// Add Task Screen — Tiimo‑style form to create a new task (POST to API).
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _status = 'pending';
  DateTime? _dueDate;
  bool _isSaving = false;

  static const _statuses = {
    'pending': 'Pending',
    'in_progress': 'In Progress',
    'completed': 'Completed',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
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

    final task = Task(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: _status,
      dueDate: _dueDate != null
          ? '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}'
          : null,
    );

    final success = await context.read<TaskProvider>().addTask(task);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      await AppDialogs.showSuccess(
        context: context,
        message: 'Task created successfully!',
      );
      if (mounted) Navigator.pop(context);
    } else {
      await AppDialogs.showError(
        context: context,
        message: 'Failed to create task. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppConstants.textPrimary,
          ),
        ),
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
                    color: AppConstants.accentLavender.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text('📝', style: TextStyle(fontSize: 30)),
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

              // ── Submit ──
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
                      : const Icon(Icons.add_task_rounded),
                  label: Text(
                    _isSaving ? 'Saving…' : 'Create Task',
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
