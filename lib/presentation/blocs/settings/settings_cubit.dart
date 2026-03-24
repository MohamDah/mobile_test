import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/local/shared_preferences_datasource.dart';

part 'settings_state.dart';

/// Manages the Settings screen preferences: default district and
/// notifications enabled. Each change is immediately persisted via
/// [SharedPreferencesDataSource].
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs)
      : super(SettingsState(
          defaultDistrict: _prefs.getDefaultDistrict(),
          notificationsEnabled: _prefs.getNotificationsEnabled(),
        ));

  final SharedPreferencesDataSource _prefs;

  /// Updates the default district filter and persists it.
  Future<void> setDefaultDistrict(String? district) async {
    await _prefs.setDefaultDistrict(district);
    emit(state.copyWith(
      defaultDistrict: district,
      clearDistrict: district == null,
    ));
  }

  /// Toggles push notifications and persists the change.
  Future<void> toggleNotifications() async {
    final next = !state.notificationsEnabled;
    await _prefs.setNotificationsEnabled(next);
    emit(state.copyWith(notificationsEnabled: next));
  }
}
