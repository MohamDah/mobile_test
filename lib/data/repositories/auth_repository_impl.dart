// TODO(Person2): Implement this fully.
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);
  final FirebaseAuthDataSource _dataSource;

  @override
  Stream<UserEntity?> get authStateChanges => const Stream.empty();

  @override
  Future<UserEntity> signIn({required String email, required String password}) =>
      throw UnimplementedError('TODO(Person2)');

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  }) => throw UnimplementedError('TODO(Person2)');

  @override
  Future<UserEntity> signInWithGoogle() =>
      throw UnimplementedError('TODO(Person2)');

  @override
  Future<void> resetPassword(String email) =>
      throw UnimplementedError('TODO(Person2)');

  @override
  Future<void> signOut() => throw UnimplementedError('TODO(Person2)');
}
