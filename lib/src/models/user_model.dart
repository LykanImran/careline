import 'package:careline/src/models/member_model.dart';

class UserModel extends MemberModel {
  final String email;
  UserModel({
    required int id,
    required String name,
    required int age,
    required String sex,
    required this.email,
  }) : super(id: id, name: name, age: age, sex: sex);
  @override
  UserModel copyWith({
    int? id,
    String? name,
    int? age,
    String? sex,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      email: email ?? this.email,
    );
  }
}
