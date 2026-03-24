import 'package:equatable/equatable.dart';

/// Pure-Dart representation of a FitLife user.
/// The [role] field drives admin vs. regular-user access control.
class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    required this.role,
    required this.savedGyms,
  });

  final String uid;
  final String email;

  /// Either 'user' (default) or 'admin'. Set manually in Firestore console.
  final String role;

  /// List of gym document IDs the user has bookmarked.
  final List<String> savedGyms;

  /// Convenience checker so UI/BLoC code reads clearly.
  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [uid, email, role, savedGyms];
}
