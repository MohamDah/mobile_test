// TODO(Person4): Implement these use cases fully.
import '../../../core/usecases/usecase.dart';
import '../../repositories/user_repository.dart';

class SaveUnsaveParams {
  const SaveUnsaveParams({required this.userId, required this.gymId});
  final String userId;
  final String gymId;
}

class SaveGymUseCase implements UseCase<void, SaveUnsaveParams> {
  SaveGymUseCase(this._repo);
  final UserRepository _repo;
  @override
  Future<void> call(SaveUnsaveParams params) =>
      _repo.saveGym(userId: params.userId, gymId: params.gymId);
}

class UnsaveGymUseCase implements UseCase<void, SaveUnsaveParams> {
  UnsaveGymUseCase(this._repo);
  final UserRepository _repo;
  @override
  Future<void> call(SaveUnsaveParams params) =>
      _repo.unsaveGym(userId: params.userId, gymId: params.gymId);
}
