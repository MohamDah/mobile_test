// TODO(Person4): Implement fully.
import 'package:equatable/equatable.dart';

class SavedGymsState extends Equatable {
  const SavedGymsState({this.savedGymIds = const {}});
  final Set<String> savedGymIds;
  bool isSaved(String gymId) => savedGymIds.contains(gymId);
  @override
  List<Object?> get props => [savedGymIds];
}
