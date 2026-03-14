// TODO(Person3): Add feed/filter events. TODO(Person5): Add CRUD events.
import 'package:equatable/equatable.dart';

sealed class GymEvent extends Equatable {
  const GymEvent();
  @override
  List<Object?> get props => [];
}

class LoadGyms extends GymEvent {
  const LoadGyms();
}
