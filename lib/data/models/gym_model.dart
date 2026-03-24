import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/gym_entity.dart';

/// Data-transfer object (DTO) for a gym document in Firestore.
class GymModel extends GymEntity {
  const GymModel({
    required super.id,
    required super.name,
    required super.description,
    required super.district,
    required super.subscriptionPrice,
    required super.galleryUrls,
    required super.amenities,
  });

  factory GymModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return GymModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      district: data['district'] as String? ?? '',
      subscriptionPrice:
          (data['subscriptionPrice'] as num?)?.toDouble() ?? 0,
      galleryUrls: List<String>.from(data['galleryUrls'] as List? ?? []),
      amenities: List<String>.from(data['amenities'] as List? ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'district': district,
        'subscriptionPrice': subscriptionPrice,
        'galleryUrls': galleryUrls,
        'amenities': amenities,
      };

  factory GymModel.fromEntity(GymEntity entity) => GymModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        district: entity.district,
        subscriptionPrice: entity.subscriptionPrice,
        galleryUrls: entity.galleryUrls,
        amenities: entity.amenities,
      );
}
