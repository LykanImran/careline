// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MemberModel {
  final int id;
  final String name;
  final int age;
  final String sex;
  MemberModel({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
  });

  MemberModel copyWith({int? id, String? name, int? age, String? sex}) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'age': age, 'sex': sex};
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as int,
      name: map['name'] as String,
      age: map['age'] as int,
      sex: map['sex'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) =>
      MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MemberModel(id: $id, name: $name, age: $age, sex: $sex)';
  }

  @override
  bool operator ==(covariant MemberModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.age == age &&
        other.sex == sex;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ age.hashCode ^ sex.hashCode;
  }
}
