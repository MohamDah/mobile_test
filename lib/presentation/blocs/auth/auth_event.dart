part of 'auth_bloc.dart';

/// All events that [AuthBloc] handles.
sealed class AuthEvent {
  const AuthEvent();
}

/// Fired at app startup — checks existing auth state.
class AppStarted extends AuthEvent {
  const AppStarted();
}

/// User submitted the email/password sign-in form.
class SignInWithEmailRequested extends AuthEvent {
  const SignInWithEmailRequested({required this.email, required this.password});
  final String email;
  final String password;
}

/// User tapped "Continue with Google".
class SignInWithGoogleRequested extends AuthEvent {
  const SignInWithGoogleRequested();
}

/// User submitted the registration form.
class RegisterRequested extends AuthEvent {
  const RegisterRequested({required this.email, required this.password});
  final String email;
  final String password;
}

/// User requested a password-reset link.
class ResetPasswordRequested extends AuthEvent {
  const ResetPasswordRequested(this.email);
  final String email;
}

/// User tapped the Sign-Out button.
class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

/// Internal: fired when the Firebase auth-state stream emits a signed-in user.
class _AuthStateChanged extends AuthEvent {
  const _AuthStateChanged(this.uid);
  final String uid;
}

/// Internal: fired when the Firebase auth-state stream emits null (signed out).
class _AuthStateSignedOut extends AuthEvent {
  const _AuthStateSignedOut();
}
