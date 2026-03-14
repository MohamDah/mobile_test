// TODO(Person2): Implement fromFirestore/toFirestore fully.
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    required super.role,
    super.photoUrl,
    super.savedGymIds,
  });
}
