part of 'gym_bloc.dart';

/// Events dispatched to [GymBloc].
sealed class GymEvent {
  const GymEvent();
}

/// Triggers the real-time stream subscription.
class LoadGyms extends GymEvent {
  const LoadGyms();
}

/// Filters the current gym list by [district].
/// Pass null or empty string to clear the filter.
class FilterByDistrict extends GymEvent {
  const FilterByDistrict(this.district);
  final String? district;
}

/// Admin: create a new gym.
class CreateGymRequested extends GymEvent {
  const CreateGymRequested(this.gym);
  final GymEntity gym;
}

/// Admin: update an existing gym.
class UpdateGymRequested extends GymEvent {
  const UpdateGymRequested(this.gym);
  final GymEntity gym;
}

/// Admin: delete a gym by ID.
class DeleteGymRequested extends GymEvent {
  const DeleteGymRequested(this.gymId);
  final String gymId;
}
