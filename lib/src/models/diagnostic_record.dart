import 'package:hive_flutter/hive_flutter.dart';

part 'diagnostic_record.g.dart';

@HiveType(typeId: 1)
class DiagnosticRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String memberId;

  @HiveField(2)
  final String symptoms;

  @HiveField(3)
  final String medicalCondition;

  @HiveField(4)
  final String severity;

  @HiveField(5)
  final String diagnosis;

  @HiveField(6)
  final String recommendations;

  @HiveField(7)
  final String notes;

  @HiveField(8)
  final DateTime recordedAt;

  @HiveField(9)
  final DateTime? updatedAt;

  @HiveField(10)
  final String? doctorName;

  DiagnosticRecord({
    required this.id,
    required this.memberId,
    required this.symptoms,
    required this.medicalCondition,
    required this.severity,
    this.diagnosis = '',
    this.recommendations = '',
    this.notes = '',
    DateTime? recordedAt,
    DateTime? updatedAt,
    this.doctorName,
  }) : recordedAt = recordedAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  DiagnosticRecord copyWith({
    String? id,
    String? memberId,
    String? symptoms,
    String? medicalCondition,
    String? severity,
    String? diagnosis,
    String? recommendations,
    String? notes,
    DateTime? recordedAt,
    DateTime? updatedAt,
    String? doctorName,
  }) {
    return DiagnosticRecord(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      symptoms: symptoms ?? this.symptoms,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      severity: severity ?? this.severity,
      diagnosis: diagnosis ?? this.diagnosis,
      recommendations: recommendations ?? this.recommendations,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      doctorName: doctorName ?? this.doctorName,
    );
  }

  @override
  String toString() {
    return 'DiagnosticRecord(id: $id, memberId: $memberId, condition: $medicalCondition)';
  }
}
