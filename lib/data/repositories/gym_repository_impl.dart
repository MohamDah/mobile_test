import '../../domain/entities/gym_entity.dart';
import '../../domain/repositories/gym_repository.dart';
import '../datasources/remote/firestore_gym_datasource.dart';
import '../models/gym_model.dart';

/// Concrete implementation of [GymRepository] backed by Firestore.
class GymRepositoryImpl implements GymRepository {
  const GymRepositoryImpl(this._dataSource);

  final FirestoreGymDataSource _dataSource;

  @override
  Stream<List<GymEntity>> getGymsStream() => _dataSource.getGymsStream();

  @override
  Future<GymEntity> getGymById(String id) => _dataSource.getGymById(id);

  @override
  Future<void> createGym(GymEntity gym) =>
      _dataSource.createGym(GymModel.fromEntity(gym));

  @override
  Future<void> updateGym(GymEntity gym) =>
      _dataSource.updateGym(GymModel.fromEntity(gym));

  @override
  Future<void> deleteGym(String id) => _dataSource.deleteGym(id);
}
