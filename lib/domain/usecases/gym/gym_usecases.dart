// TODO(Person3): FilterGymsByDistrictUseCase. TODO(Person5): CRUD use cases.
import '../../../core/usecases/usecase.dart';
import '../../entities/gym_entity.dart';
import '../../repositories/gym_repository.dart';

/// Pure in-memory filter — no repository needed.
class FilterGymsByDistrictUseCase {
  List<GymEntity> call(List<GymEntity> gyms, String? district) {
    if (district == null) return gyms;
    return gyms.where((g) => g.district == district).toList();
  }
}

class CreateGymUseCase implements UseCase<void, GymEntity> {
  CreateGymUseCase(this._repo);
  final GymRepository _repo;
  @override
  Future<void> call(GymEntity gym) => _repo.createGym(gym);
}

class UpdateGymUseCase implements UseCase<void, GymEntity> {
  UpdateGymUseCase(this._repo);
  final GymRepository _repo;
  @override
  Future<void> call(GymEntity gym) => _repo.updateGym(gym);
}

class DeleteGymUseCase implements UseCase<void, String> {
  DeleteGymUseCase(this._repo);
  final GymRepository _repo;
  @override
  Future<void> call(String gymId) => _repo.deleteGym(gymId);
}
