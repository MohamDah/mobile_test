import 'package:equatable/equatable.dart';

/// Pure-Dart representation of a gym listing.
/// Contains no Flutter or Firebase imports — this is the "truth" of what a gym
/// is within the application domain.
class GymEntity extends Equatable {
  const GymEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.district,
    required this.subscriptionPrice,
    required this.galleryUrls,
    required this.amenities,
  });

  final String id;
  final String name;
  final String description;

  /// One of 'Gasabo', 'Kicukiro', 'Nyarugenge'.
  final String district;

  /// Monthly subscription price in RWF.
  final double subscriptionPrice;

  /// URLs pointing to gym / equipment photos.
  final List<String> galleryUrls;

  /// Free-text amenity tags (e.g. 'Pool', 'Sauna', 'Free WiFi').
  final List<String> amenities;

  /// Convenience getter: first gallery image URL, or null if gallery is empty.
  String? get thumbnailUrl => galleryUrls.isNotEmpty ? galleryUrls.first : null;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        district,
        subscriptionPrice,
        galleryUrls,
        amenities,
      ];
}
