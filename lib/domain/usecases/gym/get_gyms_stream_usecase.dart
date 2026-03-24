import '../../entities/gym_entity.dart';
import '../../repositories/gym_repository.dart';

/// Exposes the real-time [Stream] of all gyms from the data source.
class GetGymsStreamUseCase {
  const GetGymsStreamUseCase(this._repository);

  final GymRepository _repository;

  Stream<List<GymEntity>> call() => _repository.getGymsStream();
}
