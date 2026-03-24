import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/entities/gym_entity.dart';
import '../../../domain/usecases/gym/get_gyms_stream_usecase.dart';
import '../../../domain/usecases/gym/gym_usecases.dart';

part 'gym_event.dart';
part 'gym_state.dart';

/// Manages the gym feed.
///
/// Subscribes to a real-time Firestore stream via [GetGymsStreamUseCase] and
/// re-emits [GymLoaded] on every update. District filtering is applied in the
/// domain layer without an additional network call.
class GymBloc extends Bloc<GymEvent, GymState> {
  GymBloc({
    required GetGymsStreamUseCase getGymsStream,
    required FilterGymsByDistrictUseCase filterGyms,
    required CreateGymUseCase createGym,
    required UpdateGymUseCase updateGym,
    required DeleteGymUseCase deleteGym,
  })  : _getGymsStream = getGymsStream,
        _filterGyms = filterGyms,
        _createGym = createGym,
        _updateGym = updateGym,
        _deleteGym = deleteGym,
        super(const GymLoading()) {
    on<LoadGyms>(_onLoadGyms);
    on<FilterByDistrict>(_onFilterByDistrict);
    on<CreateGymRequested>(_onCreateGym);
    on<UpdateGymRequested>(_onUpdateGym);
    on<DeleteGymRequested>(_onDeleteGym);
  }

  final GetGymsStreamUseCase _getGymsStream;
  final FilterGymsByDistrictUseCase _filterGyms;
  final CreateGymUseCase _createGym;
  final UpdateGymUseCase _updateGym;
  final DeleteGymUseCase _deleteGym;

  StreamSubscription<List<GymEntity>>? _gymStreamSubscription;
  String? _activeDistrict;

  // ── Event Handlers ────────────────────────────────────────────────────────

  Future<void> _onLoadGyms(LoadGyms event, Emitter<GymState> emit) async {
    emit(const GymLoading());
    await _gymStreamSubscription?.cancel();

    await emit.forEach<List<GymEntity>>(
      _getGymsStream(),
      onData: (gyms) => GymLoaded(
        allGyms: gyms,
        filteredGyms: _filterGyms(
          gyms: gyms,
          district: _activeDistrict,
        ),
        selectedDistrict: _activeDistrict,
      ),
      onError: (err, st) => const GymError('Failed to load gyms.'),
    );
  }

  Future<void> _onFilterByDistrict(
    FilterByDistrict event,
    Emitter<GymState> emit,
  ) async {
    _activeDistrict = event.district;
    if (state is GymLoaded) {
      final current = state as GymLoaded;
      emit(GymLoaded(
        allGyms: current.allGyms,
        filteredGyms: _filterGyms(
          gyms: current.allGyms,
          district: _activeDistrict,
        ),
        selectedDistrict: _activeDistrict,
      ));
    }
  }

  Future<void> _onCreateGym(
    CreateGymRequested event,
    Emitter<GymState> emit,
  ) async {
    emit(const GymOperationLoading());
    try {
      await _createGym(event.gym);
      emit(const GymOperationSuccess('Gym created successfully.'));
    } on ServerFailure catch (f) {
      emit(GymError(f.message));
    } catch (_) {
      emit(const GymError('Failed to create gym.'));
    }
  }

  Future<void> _onUpdateGym(
    UpdateGymRequested event,
    Emitter<GymState> emit,
  ) async {
    emit(const GymOperationLoading());
    try {
      await _updateGym(event.gym);
      emit(const GymOperationSuccess('Gym updated successfully.'));
    } on ServerFailure catch (f) {
      emit(GymError(f.message));
    } catch (_) {
      emit(const GymError('Failed to update gym.'));
    }
  }

  Future<void> _onDeleteGym(
    DeleteGymRequested event,
    Emitter<GymState> emit,
  ) async {
    emit(const GymOperationLoading());
    try {
      await _deleteGym(event.gymId);
      emit(const GymOperationSuccess('Gym deleted.'));
    } on ServerFailure catch (f) {
      emit(GymError(f.message));
    } on PermissionFailure catch (f) {
      emit(GymError(f.message));
    } catch (_) {
      emit(const GymError('Failed to delete gym.'));
    }
  }

  @override
  Future<void> close() {
    _gymStreamSubscription?.cancel();
    return super.close();
  }
}
