// TODO(Person4): Implement SavedGymsCubit to use these.
import '../../repositories/user_repository.dart';

class SaveGymUseCase {
  const SaveGymUseCase(this._repo);
  final UserRepository _repo;
  Future<void> call(String uid, String gymId) => _repo.saveGym(uid, gymId);
}

class UnsaveGymUseCase {
  const UnsaveGymUseCase(this._repo);
  final UserRepository _repo;
  Future<void> call(String uid, String gymId) => _repo.unsaveGym(uid, gymId);
}
