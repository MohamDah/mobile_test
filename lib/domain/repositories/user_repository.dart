import '../entities/user_entity.dart';

/// Abstract contract for user-document operations in Firestore.
abstract interface class UserRepository {
  /// Creates a new user document in Firestore on first sign-up.
  Future<void> createUserDocument(UserEntity user);

  /// Returns a stream of the user document so the app reacts to role changes.
  Stream<UserEntity?> getUserStream(String uid);

  /// Fetches the user document once (used during app start-up).
  Future<UserEntity?> getUser(String uid);

  /// Adds [gymId] to the user's savedGyms array (idempotent).
  Future<void> saveGym(String uid, String gymId);

  /// Removes [gymId] from the user's savedGyms array.
  Future<void> unsaveGym(String uid, String gymId);
}
