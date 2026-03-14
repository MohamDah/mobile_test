// TODO(Person2): Implement these use cases fully.
import '../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class SignInParams {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;
}

class RegisterParams {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
  final String email;
  final String password;
  final String displayName;
}

class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  SignInUseCase(this._repo);
  final AuthRepository _repo;
  @override
  Future<UserEntity> call(SignInParams params) =>
      _repo.signIn(email: params.email, password: params.password);
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  RegisterUseCase(this._repo);
  final AuthRepository _repo;
  @override
  Future<UserEntity> call(RegisterParams params) => _repo.register(
        email: params.email,
        password: params.password,
        displayName: params.displayName,
      );
}

class GoogleSignInUseCase implements UseCase<UserEntity, NoParams> {
  GoogleSignInUseCase(this._repo);
  final AuthRepository _repo;
  @override
  Future<UserEntity> call(NoParams params) => _repo.signInWithGoogle();
}

class ResetPasswordUseCase implements UseCase<void, String> {
  ResetPasswordUseCase(this._repo);
  final AuthRepository _repo;
  @override
  Future<void> call(String email) => _repo.resetPassword(email);
}

class SignOutUseCase implements UseCase<void, NoParams> {
  SignOutUseCase(this._repo);
  final AuthRepository _repo;
  @override
  Future<void> call(NoParams params) => _repo.signOut();
}
