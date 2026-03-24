import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

/// Data-transfer object (DTO) for a user document in Firestore.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.role,
    required super.savedGyms,
  });

  // ── Factory constructors ─────────────────────────────────────────────────

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'user',
      savedGyms: List<String>.from(data['savedGyms'] as List? ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'role': role,
        'savedGyms': savedGyms,
      };

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        uid: entity.uid,
        email: entity.email,
        role: entity.role,
        savedGyms: entity.savedGyms,
      );

  /// Creates a brand-new user document with sensible defaults.
  factory UserModel.newUser({required String uid, required String email}) =>
      UserModel(uid: uid, email: email, role: 'user', savedGyms: const []);
}
