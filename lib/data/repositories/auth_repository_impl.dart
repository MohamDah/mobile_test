import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_auth_datasource.dart';

/// Concrete implementation of [AuthRepository] backed by Firebase Auth.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final FirebaseAuthDataSource _dataSource;

  @override
  Stream<User?> get authStateChanges => _dataSource.authStateChanges;

  @override
  User? get currentUser => _dataSource.currentUser;

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) =>
      _dataSource.signInWithEmailAndPassword(email, password);

  @override
  Future<User> registerWithEmailAndPassword(String email, String password) =>
      _dataSource.registerWithEmailAndPassword(email, password);

  @override
  Future<User> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _dataSource.sendPasswordResetEmail(email);

  @override
  Future<void> signOut() => _dataSource.signOut();
}
