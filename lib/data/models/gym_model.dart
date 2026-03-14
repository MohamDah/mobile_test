// TODO(Person3): Implement fromFirestore/toFirestore fully.
import '../../domain/entities/gym_entity.dart';

class GymModel extends GymEntity {
  const GymModel({
    required super.id,
    required super.name,
    required super.description,
    required super.district,
    required super.subscriptionPrice,
    required super.amenities,
    super.thumbnailUrl,
    super.galleryUrls,
  });
}
