// TODO(Person3): Implement read methods. TODO(Person5): Implement write methods.
import '../../domain/entities/gym_entity.dart';
import '../../domain/repositories/gym_repository.dart';
import '../datasources/remote/firestore_gym_datasource.dart';

class GymRepositoryImpl implements GymRepository {
  GymRepositoryImpl(this._dataSource);
  final FirestoreGymDataSource _dataSource;

  @override
  Stream<List<GymEntity>> getGymsStream() => const Stream.empty();

  @override
  Future<void> createGym(GymEntity gym) =>
      throw UnimplementedError('TODO(Person5)');

  @override
  Future<void> updateGym(GymEntity gym) =>
      throw UnimplementedError('TODO(Person5)');

  @override
  Future<void> deleteGym(String gymId) =>
      throw UnimplementedError('TODO(Person5)');
}
