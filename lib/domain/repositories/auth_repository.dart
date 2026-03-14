// TODO(Person2): Implement this interface fully.
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity> signIn({required String email, required String password});
  Future<UserEntity> register({required String email, required String password, required String displayName});
  Future<UserEntity> signInWithGoogle();
  Future<void> resetPassword(String email);
  Future<void> signOut();
}
