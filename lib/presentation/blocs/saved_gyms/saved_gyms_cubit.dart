import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/user_repository.dart';
import '../../../domain/usecases/user/user_usecases.dart';

part 'saved_gyms_state.dart';

/// Manages the list of gym IDs saved by the current user.
class SavedGymsCubit extends Cubit<SavedGymsState> {
  SavedGymsCubit({
    required SaveGymUseCase saveGym,
    required UnsaveGymUseCase unsaveGym,
    required UserRepository userRepository,
  })  : _saveGym = saveGym,
        _unsaveGym = unsaveGym,
        _userRepository = userRepository,
        super(const SavedGymsState(savedGymIds: []));

  final SaveGymUseCase _saveGym;
  final UnsaveGymUseCase _unsaveGym;
  final UserRepository _userRepository;

  /// Initialises the cubit by streaming the user's saved-gyms list.
  void loadSavedGyms(String uid) {
    _userRepository.getUserStream(uid).listen((user) {
      if (user != null) {
        emit(SavedGymsState(savedGymIds: user.savedGyms));
      }
    });
  }

  /// Adds or removes the gym from the saved list, toggling the bookmark.
  Future<void> toggleSaveGym(String uid, String gymId) async {
    if (uid.isEmpty) return;

    final previousIds = List<String>.from(state.savedGymIds);
    final isSaved = previousIds.contains(gymId);

    // Optimistic update so UI toggles immediately.
    final nextIds = isSaved
        ? previousIds.where((id) => id != gymId).toList()
        : [...previousIds, gymId];
    emit(SavedGymsState(savedGymIds: nextIds));

    try {
      if (isSaved) {
        await _unsaveGym(uid: uid, gymId: gymId);
      } else {
        await _saveGym(uid: uid, gymId: gymId);
      }
    } catch (_) {
      // Revert on failure.
      emit(SavedGymsState(savedGymIds: previousIds));
      rethrow;
    }
  }
}
