class UserEntity {
  final String uid;
  final String email;
  final String name; // Tambahkan ini
  final String role;

  UserEntity({
    required this.uid,
    required this.email,
    required this.name, // Tambahkan ini
    required this.role,
  });
}