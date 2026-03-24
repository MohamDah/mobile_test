import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fitlife/core/errors/failures.dart';
import 'package:fitlife/domain/repositories/auth_repository.dart';
import 'package:fitlife/domain/repositories/user_repository.dart';
import 'package:fitlife/domain/usecases/auth/auth_usecases.dart';
import 'package:fitlife/presentation/blocs/auth/auth_bloc.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockGoogleSignInUseCase extends Mock implements GoogleSignInUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockFirebaseUser extends Mock implements User {}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late MockSignInUseCase mockSignIn;
  late MockRegisterUseCase mockRegister;
  late MockGoogleSignInUseCase mockGoogleSignIn;
  late MockResetPasswordUseCase mockResetPassword;
  late MockSignOutUseCase mockSignOut;
  late MockAuthRepository mockAuthRepo;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockSignIn = MockSignInUseCase();
    mockRegister = MockRegisterUseCase();
    mockGoogleSignIn = MockGoogleSignInUseCase();
    mockResetPassword = MockResetPasswordUseCase();
    mockSignOut = MockSignOutUseCase();
    mockAuthRepo = MockAuthRepository();
    mockUserRepo = MockUserRepository();

    // Stub the auth-state stream to prevent BLoC subscription errors.
    when(() => mockAuthRepo.authStateChanges)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAuthRepo.currentUser).thenReturn(null);
  });

  AuthBloc buildBloc() => AuthBloc(
        signIn: mockSignIn,
        register: mockRegister,
        googleSignIn: mockGoogleSignIn,
        resetPassword: mockResetPassword,
        signOut: mockSignOut,
        authRepository: mockAuthRepo,
        userRepository: mockUserRepo,
      );

  /// Test 1: Invalid credentials produce AuthError.
  blocTest<AuthBloc, AuthState>(
    'SignInWithEmailRequested emits [AuthLoading, AuthError] on bad credentials',
    build: () {
      when(() => mockSignIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const AuthFailure('Incorrect email or password.'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SignInWithEmailRequested(
      email: 'bad@example.com',
      password: 'wrongpass',
    )),
    expect: () => [
      const AuthLoading(),
      isA<AuthError>().having(
        (s) => s.message,
        'message',
        'Incorrect email or password.',
      ),
    ],
  );

  /// Test 2: Registration success emits RegistrationSuccess.
  blocTest<AuthBloc, AuthState>(
    'RegisterRequested emits [AuthLoading, RegistrationSuccess] on success',
    build: () {
      final fakeUser = MockFirebaseUser();
      when(() => fakeUser.uid).thenReturn('new_uid');
      when(() => fakeUser.email).thenReturn('user@example.com');
      when(() => mockRegister(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => fakeUser);
      when(() => mockUserRepo.createUserDocument(any()))
          .thenAnswer((_) async {});
      return buildBloc();
    },
    act: (bloc) => bloc.add(const RegisterRequested(
      email: 'user@example.com',
      password: 'password123',
    )),
    expect: () => [
      const AuthLoading(),
      const RegistrationSuccess(),
    ],
  );

  /// Test 3: SignOutRequested emits Unauthenticated.
  blocTest<AuthBloc, AuthState>(
    'SignOutRequested emits Unauthenticated',
    build: () {
      when(() => mockSignOut()).thenAnswer((_) async {});
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SignOutRequested()),
    expect: () => [const Unauthenticated()],
  );
}
