// TODO(Person3): Add all gym states.
import 'package:equatable/equatable.dart';

import '../../../domain/entities/gym_entity.dart';

sealed class GymState extends Equatable {
  const GymState();
  @override
  List<Object?> get props => [];
}

class GymInitial extends GymState {
  const GymInitial();
}

class GymLoading extends GymState {
  const GymLoading();
}

class GymLoaded extends GymState {
  const GymLoaded(this.gyms, {this.selectedDistrict});
  final List<GymEntity> gyms;
  final String? selectedDistrict;
  @override
  List<Object?> get props => [gyms, selectedDistrict];
}

class GymError extends GymState {
  const GymError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
