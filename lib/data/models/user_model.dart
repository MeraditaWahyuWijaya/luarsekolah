import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String uid,
    required String email,
    required String name,
    required String role,
  }) : super(uid: uid, email: email, name: name, role: role);

  // Mengubah Map dari Firestore ke Model
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'user',
    );
  }

  // Mengubah Model ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
    };
  }
}