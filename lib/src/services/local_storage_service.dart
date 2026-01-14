import 'package:hive_flutter/hive_flutter.dart';
import '../models/member.dart';
import '../models/diagnostic_record.dart';

class LocalStorageService {
  static const String _memberBoxName = 'members';
  static const String _diagnosticBoxName = 'diagnostics';

  late Box<Member> _memberBox;
  late Box<DiagnosticRecord> _diagnosticBox;

  Future<void> init() async {
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MemberAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DiagnosticRecordAdapter());
    }

    // Open boxes
    _memberBox = await Hive.openBox<Member>(_memberBoxName);
    _diagnosticBox = await Hive.openBox<DiagnosticRecord>(_diagnosticBoxName);
  }

  // ============ Member Operations ============

  /// Add or update a member
  Future<void> saveMember(Member member) async {
    await _memberBox.put(member.id, member);
  }

  /// Get a member by ID
  Member? getMember(String memberId) {
    return _memberBox.get(memberId);
  }

  /// Get all members
  List<Member> getAllMembers() {
    return _memberBox.values.toList();
  }

  /// Delete a member
  Future<void> deleteMember(String memberId) async {
    await _memberBox.delete(memberId);
  }

  /// Search members by name or email
  List<Member> searchMembers(String query) {
    return _memberBox.values
        .where(
          (member) =>
              member.firstName.toLowerCase().contains(query.toLowerCase()) ||
              member.lastName.toLowerCase().contains(query.toLowerCase()) ||
              member.email.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Get member count
  int getMemberCount() {
    return _memberBox.length;
  }

  // ============ Diagnostic Record Operations ============

  /// Add or update a diagnostic record
  Future<void> saveDiagnosticRecord(DiagnosticRecord record) async {
    await _diagnosticBox.put(record.id, record);
  }

  /// Get a diagnostic record by ID
  DiagnosticRecord? getDiagnosticRecord(String recordId) {
    return _diagnosticBox.get(recordId);
  }

  /// Get all diagnostic records for a member
  List<DiagnosticRecord> getMemberDiagnostics(String memberId) {
    return _diagnosticBox.values
        .where((record) => record.memberId == memberId)
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  /// Get all diagnostic records
  List<DiagnosticRecord> getAllDiagnosticRecords() {
    return _diagnosticBox.values.toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  /// Delete a diagnostic record
  Future<void> deleteDiagnosticRecord(String recordId) async {
    await _diagnosticBox.delete(recordId);
  }

  /// Delete all records for a member (cascade delete)
  Future<void> deleteMemberRecords(String memberId) async {
    final records = getMemberDiagnostics(memberId);
    for (final record in records) {
      await _diagnosticBox.delete(record.id);
    }
  }

  /// Get diagnostic record count
  int getDiagnosticRecordCount() {
    return _diagnosticBox.length;
  }

  // ============ Utility Operations ============

  /// Clear all data (for testing or reset)
  Future<void> clearAll() async {
    await _memberBox.clear();
    await _diagnosticBox.clear();
  }

  /// Close boxes
  Future<void> close() async {
    await _memberBox.close();
    await _diagnosticBox.close();
  }
}
