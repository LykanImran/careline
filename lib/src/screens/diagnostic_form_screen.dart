import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/member.dart';
import '../models/diagnostic_record.dart';
import '../services/local_storage_service.dart';
import '../theme/app_theme.dart';

class DiagnosticFormScreen extends StatefulWidget {
  final LocalStorageService storageService;
  final Member member;
  final DiagnosticRecord? existingRecord;

  const DiagnosticFormScreen({
    super.key,
    required this.storageService,
    required this.member,
    this.existingRecord,
  });

  @override
  State<DiagnosticFormScreen> createState() => _DiagnosticFormScreenState();
}

class _DiagnosticFormScreenState extends State<DiagnosticFormScreen> {
  late final TextEditingController _symptomsController;
  late final TextEditingController _conditionController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _recommendationsController;

  String _selectedSeverity = 'Mild';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _symptomsController = TextEditingController(
      text: widget.existingRecord?.symptoms ?? '',
    );
    _conditionController = TextEditingController(
      text: widget.existingRecord?.medicalCondition ?? '',
    );
    _diagnosisController = TextEditingController(
      text: widget.existingRecord?.diagnosis ?? '',
    );
    _recommendationsController = TextEditingController(
      text: widget.existingRecord?.recommendations ?? '',
    );
    _selectedSeverity = widget.existingRecord?.severity ?? 'Mild';
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _conditionController.dispose();
    _diagnosisController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  Future<void> _saveDiagnostic() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final record = DiagnosticRecord(
        id: widget.existingRecord?.id ?? const Uuid().v4(),
        memberId: widget.member.id,
        symptoms: _symptomsController.text.trim(),
        medicalCondition: _conditionController.text.trim(),
        severity: _selectedSeverity,
        diagnosis: _diagnosisController.text.trim(),
        recommendations: _recommendationsController.text.trim(),
        recordedAt: widget.existingRecord?.recordedAt ?? DateTime.now(),
        updatedAt: widget.existingRecord?.updatedAt ?? DateTime.now(),
      );

      await widget.storageService.saveDiagnosticRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingRecord == null
                  ? 'Diagnostic record created successfully'
                  : 'Diagnostic record updated successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, record);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving record: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Mild':
        return Colors.green;
      case 'Moderate':
        return Colors.orange;
      case 'Severe':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingRecord != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Diagnostic Record' : 'New Diagnostic Record',
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Member Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(
                          widget.member.firstName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.member.firstName} ${widget.member.lastName}',
                              style: AppTypography.textTheme.titleLarge,
                            ),
                            Text(
                              widget.member.email,
                              style: AppTypography.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Symptoms
              TextFormField(
                controller: _symptomsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Symptoms',
                  hintText: 'Describe the symptoms experienced',
                  prefixIcon: const Icon(Icons.local_hospital),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please describe symptoms';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Medical Condition
              TextFormField(
                controller: _conditionController,
                decoration: InputDecoration(
                  labelText: 'Medical Condition',
                  hintText: 'Enter the primary condition',
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Medical condition is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Severity Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSeverity,
                decoration: InputDecoration(
                  labelText: 'Severity Level',
                  prefixIcon: const Icon(Icons.priority_high),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ['Mild', 'Moderate', 'Severe']
                    .map(
                      (severity) => DropdownMenuItem(
                        value: severity,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getSeverityColor(severity),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(severity),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSeverity = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Diagnosis (AI-generated or clinician input)
              TextFormField(
                controller: _diagnosisController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Diagnosis',
                  hintText: 'AI-generated diagnosis or clinician assessment',
                  prefixIcon: const Icon(Icons.psychology),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recommendations
              TextFormField(
                controller: _recommendationsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Recommendations',
                  hintText: 'Treatment recommendations or follow-up actions',
                  prefixIcon: const Icon(Icons.assignment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveDiagnostic,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          isEditing
                              ? 'Update Record'
                              : 'Save Diagnostic Record',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
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
