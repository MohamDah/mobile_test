import '../../repositories/user_repository.dart';

class SaveGymUseCase {
  const SaveGymUseCase(this._repo);
  final UserRepository _repo;
  Future<void> call({required String uid, required String gymId}) =>
      _repo.saveGym(uid, gymId);
}

class UnsaveGymUseCase {
  const UnsaveGymUseCase(this._repo);
  final UserRepository _repo;
  Future<void> call({required String uid, required String gymId}) =>
      _repo.unsaveGym(uid, gymId);
}
