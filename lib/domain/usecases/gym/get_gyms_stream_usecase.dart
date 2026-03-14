// TODO(Person3): Implement fully.
import '../../../core/usecases/usecase.dart';
import '../../entities/gym_entity.dart';
import '../../repositories/gym_repository.dart';

class GetGymsStreamUseCase implements UseCase<Stream<List<GymEntity>>, NoParams> {
  GetGymsStreamUseCase(this._repo);
  final GymRepository _repo;
  @override
  Future<Stream<List<GymEntity>>> call(NoParams params) async =>
      _repo.getGymsStream();
}
