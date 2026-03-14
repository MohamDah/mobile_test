// TODO(Person3): Implement read methods. TODO(Person5): Implement write methods.
import '../entities/gym_entity.dart';

abstract interface class GymRepository {
  Stream<List<GymEntity>> getGymsStream();
  Future<void> createGym(GymEntity gym);
  Future<void> updateGym(GymEntity gym);
  Future<void> deleteGym(String gymId);
}
