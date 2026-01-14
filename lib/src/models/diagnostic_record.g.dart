// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostic_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiagnosticRecordAdapter extends TypeAdapter<DiagnosticRecord> {
  @override
  final int typeId = 1;

  @override
  DiagnosticRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiagnosticRecord(
      id: fields[0] as String,
      memberId: fields[1] as String,
      symptoms: fields[2] as String,
      medicalCondition: fields[3] as String,
      severity: fields[4] as String,
      diagnosis: fields[5] as String,
      recommendations: fields[6] as String,
      notes: fields[7] as String,
      recordedAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
      doctorName: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DiagnosticRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.memberId)
      ..writeByte(2)
      ..write(obj.symptoms)
      ..writeByte(3)
      ..write(obj.medicalCondition)
      ..writeByte(4)
      ..write(obj.severity)
      ..writeByte(5)
      ..write(obj.diagnosis)
      ..writeByte(6)
      ..write(obj.recommendations)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.recordedAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.doctorName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagnosticRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
