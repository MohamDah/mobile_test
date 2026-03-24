import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Manages the entire authentication lifecycle.
///
/// Listens to [AuthRepository.authStateChanges] so the BLoC re-emits the
/// correct state whenever the Firebase auth session changes (including on
/// app restart, thanks to persistent auth).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInUseCase signIn,
    required RegisterUseCase register,
    required GoogleSignInUseCase googleSignIn,
    required ResetPasswordUseCase resetPassword,
    required SignOutUseCase signOut,
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _signIn = signIn,
        _register = register,
        _googleSignIn = googleSignIn,
        _resetPassword = resetPassword,
        _signOut = signOut,
        _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInWithEmailRequested>(_onSignInWithEmail);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<RegisterRequested>(_onRegister);
    on<ResetPasswordRequested>(_onResetPassword);
    on<SignOutRequested>(_onSignOut);

    // Subscribe to Firebase auth-state stream immediately so the BLoC
    // always mirrors the current session (persistent across restarts).
    _authSubscription =
        _authRepository.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        add(_AuthStateChanged(firebaseUser.uid));
      } else {
        add(const _AuthStateSignedOut());
      }
    });

    on<_AuthStateChanged>(_onAuthStateChanged);
    on<_AuthStateSignedOut>(
      (_, emit) => emit(const Unauthenticated()),
    );
  }

  final SignInUseCase _signIn;
  final RegisterUseCase _register;
  final GoogleSignInUseCase _googleSignIn;
  final ResetPasswordUseCase _resetPassword;
  final SignOutUseCase _signOut;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  late final StreamSubscription<dynamic> _authSubscription;

  // ── Event handlers ────────────────────────────────────────────────────────

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    // The auth-state stream subscription above will drive the actual state
    // transition; emitting Loading gives the splash screen something to show.
  }

  Future<void> _onAuthStateChanged(
    _AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    await _loadAndEmitUser(event.uid, emit: emit);
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _signIn(
        email: event.email,
        password: event.password,
      );
      await _loadAndEmitUser(user.uid, emit: emit);
    } on AuthFailure catch (f) {
      emit(AuthError(f.message));
    } catch (_) {
      emit(const AuthError('Sign-in failed. Please try again.'));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _googleSignIn();
      // Ensure the user document exists (first-time Google sign-in).
      await _userRepository.createUserDocument(
        UserEntityPlaceholder(uid: user.uid, email: user.email ?? ''),
      );
      await _loadAndEmitUser(user.uid, emit: emit);
    } on AuthFailure catch (f) {
      emit(AuthError(f.message));
    } catch (_) {
      emit(const AuthError('Google sign-in failed. Please try again.'));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _register(
        email: event.email,
        password: event.password,
      );
      // Create the user document in Firestore with default role.
      await _userRepository.createUserDocument(
        UserEntityPlaceholder(uid: user.uid, email: user.email ?? ''),
      );
      emit(const RegistrationSuccess());
    } on AuthFailure catch (f) {
      emit(AuthError(f.message));
    } catch (_) {
      emit(const AuthError('Registration failed. Please try again.'));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _resetPassword(event.email);
      emit(const PasswordResetSent());
    } on AuthFailure catch (f) {
      emit(AuthError(f.message));
    } catch (_) {
      emit(const AuthError('Could not send reset email.'));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut();
    emit(const Unauthenticated());
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Fetches the Firestore user document and emits [Authenticated].
  /// If no document exists yet, creates one first.
  Future<void> _loadAndEmitUser(
    String uid, {
    required Emitter<AuthState> emit,
  }) async {
    try {
      var userEntity = await _userRepository.getUser(uid);
      if (userEntity == null) {
        final firebaseUser = _authRepository.currentUser;
        if (firebaseUser != null) {
          final placeholder = UserEntityPlaceholder(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
          );
          await _userRepository.createUserDocument(placeholder);
          userEntity = await _userRepository.getUser(uid);
        }
      }
      if (userEntity != null) {
        emit(Authenticated(userEntity));
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

/// Minimal [UserEntity] used when creating a new user document.
/// The real [UserModel.newUser] is in the data layer; this keeps the BLoC
/// layer free of data-layer imports.
class UserEntityPlaceholder extends UserEntity {
  const UserEntityPlaceholder({required super.uid, required super.email})
      : super(role: 'user', savedGyms: const []);
}
