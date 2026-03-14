// TODO(Person4): Implement this interface fully.
import '../entities/user_entity.dart';

abstract interface class UserRepository {
  Stream<UserEntity?> getUserStream(String userId);
  Future<void> saveGym({required String userId, required String gymId});
  Future<void> unsaveGym({required String userId, required String gymId});
}
