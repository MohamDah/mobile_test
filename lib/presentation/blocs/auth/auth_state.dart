part of 'auth_bloc.dart';

/// All states emitted by [AuthBloc].
sealed class AuthState {
  const AuthState();
}

/// Initial state before auth check completes.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// An async auth operation is in progress (show loading indicator).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// A user is signed in.
class Authenticated extends AuthState {
  const Authenticated(this.user);
  final UserEntity user;
}

/// No user is signed in.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// An error occurred; [message] is shown in a Snackbar.
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

/// Password-reset email was sent successfully.
class PasswordResetSent extends AuthState {
  const PasswordResetSent();
}

/// Registration succeeded; email verification prompt should be shown.
class RegistrationSuccess extends AuthState {
  const RegistrationSuccess();
}
