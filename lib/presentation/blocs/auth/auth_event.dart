// TODO(Person2): Add all auth events.
import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Dispatched on app start to check persisted auth state.
class AppStarted extends AuthEvent {
  const AppStarted();
}
