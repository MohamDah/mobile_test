part of 'saved_gyms_cubit.dart';

/// Holds the set of gym document IDs that the current user has bookmarked.
class SavedGymsState extends Equatable {
  const SavedGymsState({required this.savedGymIds});

  final List<String> savedGymIds;

  bool isGymSaved(String gymId) => savedGymIds.contains(gymId);

  @override
  List<Object?> get props => [savedGymIds];
}
