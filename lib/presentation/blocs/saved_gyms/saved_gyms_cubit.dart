// TODO(Person4): Implement fully.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/user_repository.dart';
import '../../../domain/usecases/user/user_usecases.dart';
import 'saved_gyms_state.dart';

class SavedGymsCubit extends Cubit<SavedGymsState> {
  SavedGymsCubit({
    required SaveGymUseCase saveGym,
    required UnsaveGymUseCase unsaveGym,
    required UserRepository userRepository,
  }) : super(const SavedGymsState());
}
