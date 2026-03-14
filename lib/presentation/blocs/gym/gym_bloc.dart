// TODO(Person3): Implement feed/filter. TODO(Person5): Implement CRUD.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/gym/get_gyms_stream_usecase.dart';
import '../../../domain/usecases/gym/gym_usecases.dart';
import 'gym_event.dart';
import 'gym_state.dart';

class GymBloc extends Bloc<GymEvent, GymState> {
  GymBloc({
    required GetGymsStreamUseCase getGymsStream,
    required FilterGymsByDistrictUseCase filterGyms,
    required CreateGymUseCase createGym,
    required UpdateGymUseCase updateGym,
    required DeleteGymUseCase deleteGym,
  }) : super(const GymInitial()) {
    on<LoadGyms>(_onLoadGyms);
  }

  Future<void> _onLoadGyms(LoadGyms event, Emitter<GymState> emit) async {
    emit(const GymLoaded([]));
  }
}
