import '../../entities/gym_entity.dart';
import '../../repositories/gym_repository.dart';

/// Filters an already-loaded list of gyms by district in memory.
/// Passing null or empty string returns the full unfiltered list.
class FilterGymsByDistrictUseCase {
  const FilterGymsByDistrictUseCase();

  List<GymEntity> call({
    required List<GymEntity> gyms,
    required String? district,
  }) {
    if (district == null || district.isEmpty) return gyms;
    return gyms
        .where((g) => g.district.toLowerCase() == district.toLowerCase())
        .toList();
  }
}

/// Creates a new gym document in Firestore.
class CreateGymUseCase {
  const CreateGymUseCase(this._repository);
  final GymRepository _repository;
  Future<void> call(GymEntity gym) => _repository.createGym(gym);
}

/// Updates an existing gym document in Firestore.
class UpdateGymUseCase {
  const UpdateGymUseCase(this._repository);
  final GymRepository _repository;
  Future<void> call(GymEntity gym) => _repository.updateGym(gym);
}

/// Permanently deletes a gym document from Firestore.
class DeleteGymUseCase {
  const DeleteGymUseCase(this._repository);
  final GymRepository _repository;
  Future<void> call(String gymId) => _repository.deleteGym(gymId);
}
