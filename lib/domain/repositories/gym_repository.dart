import '../entities/gym_entity.dart';

/// Abstract contract for gym data operations.
abstract interface class GymRepository {
  /// Returns a real-time stream of all gyms.
  Stream<List<GymEntity>> getGymsStream();

  /// Retrieves a single gym by its document [id].
  Future<GymEntity> getGymById(String id);

  /// Creates a new gym document.
  Future<void> createGym(GymEntity gym);

  /// Replaces the Firestore document for [gym.id] with the new field values.
  Future<void> updateGym(GymEntity gym);

  /// Permanently deletes the gym document with the given [id].
  Future<void> deleteGym(String id);
}
