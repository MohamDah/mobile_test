import 'package:firebase_auth/firebase_auth.dart';

/// Abstract contract for authentication operations.
abstract interface class AuthRepository {
  /// Emits the current [User?] and every subsequent auth-state change.
  /// Returns null when the user is signed out.
  Stream<User?> get authStateChanges;

  /// Signs in with [email] and [password].
  Future<User> signInWithEmailAndPassword(String email, String password);

  /// Creates a new account and sends an email-verification link.
  Future<User> registerWithEmailAndPassword(String email, String password);

  /// Signs in via Google OAuth.
  Future<User> signInWithGoogle();

  /// Sends a password-reset email to [email].
  Future<void> sendPasswordResetEmail(String email);

  /// Signs the current user out of all providers.
  Future<void> signOut();

  /// Returns the currently authenticated [User], or null if signed out.
  User? get currentUser;
}
