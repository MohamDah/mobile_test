/// Sealed hierarchy of domain-level failures.
/// Repositories return these instead of raw exceptions so the BLoC layer never
/// leaks Firebase or Dart I/O details into UI.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

/// Network / Firestore I/O errors.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred.']);
}

/// Authentication-specific failures (wrong password, user not found, etc.).
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

/// Errors coming from SharedPreferences or other local storage.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

/// Caller asked for an entity that does not exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

/// The authenticated user does not have permission for the requested action.
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied.']);
}
