import 'package:firebase_auth/firebase_auth.dart';

import '../../repositories/auth_repository.dart';

/// Signs the user in with email and password.
class SignInUseCase {
  const SignInUseCase(this._repository);
  final AuthRepository _repository;
  Future<User> call({required String email, required String password}) =>
      _repository.signInWithEmailAndPassword(email, password);
}

/// Registers a new account; also triggers email verification.
class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;
  Future<User> call({required String email, required String password}) =>
      _repository.registerWithEmailAndPassword(email, password);
}

/// Initiates Google OAuth sign-in flow.
class GoogleSignInUseCase {
  const GoogleSignInUseCase(this._repository);
  final AuthRepository _repository;
  Future<User> call() => _repository.signInWithGoogle();
}

/// Sends a password-reset email.
class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);
  final AuthRepository _repository;
  Future<void> call(String email) =>
      _repository.sendPasswordResetEmail(email);
}

/// Signs the current user out.
class SignOutUseCase {
  const SignOutUseCase(this._repository);
  final AuthRepository _repository;
  Future<void> call() => _repository.signOut();
}
