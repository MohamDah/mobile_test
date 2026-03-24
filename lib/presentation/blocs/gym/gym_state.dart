part of 'gym_bloc.dart';

/// States emitted by [GymBloc].
sealed class GymState {
  const GymState();
}

/// Gym data is being loaded for the first time.
class GymLoading extends GymState {
  const GymLoading();
}

/// Gym data (or an update to it) has arrived.
class GymLoaded extends GymState {
  const GymLoaded({
    required this.allGyms,
    required this.filteredGyms,
    this.selectedDistrict,
  });

  /// Complete, unfiltered list from Firestore.
  final List<GymEntity> allGyms;

  /// The list currently shown in the feed (may be filtered).
  final List<GymEntity> filteredGyms;

  /// The active filter; null means "all districts".
  final String? selectedDistrict;
}

/// An operation resulted in an error.
class GymError extends GymState {
  const GymError(this.message);
  final String message;
}

/// An admin write/delete operation is in progress.
class GymOperationLoading extends GymState {
  const GymOperationLoading();
}

/// An admin write/delete operation succeeded.
class GymOperationSuccess extends GymState {
  const GymOperationSuccess(this.message);
  final String message;
}
