// TODO(Person4): Implement fully.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/local/shared_preferences_datasource.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs)
      : super(SettingsState(
          defaultDistrict: _prefs.getDefaultDistrict(),
          notificationsEnabled: _prefs.getNotificationsEnabled(),
        ));

  final SharedPreferencesDataSource _prefs;

  Future<void> setDefaultDistrict(String? district) async {
    await _prefs.setDefaultDistrict(district);
    emit(SettingsState(
      defaultDistrict: district,
      notificationsEnabled: state.notificationsEnabled,
    ));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setNotificationsEnabled(enabled);
    emit(SettingsState(
      defaultDistrict: state.defaultDistrict,
      notificationsEnabled: enabled,
    ));
  }
}
