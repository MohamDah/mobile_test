part of 'settings_cubit.dart';

/// Holds the persisted user preferences managed by [SettingsCubit].
class SettingsState extends Equatable {
  const SettingsState({
    this.defaultDistrict,
    required this.notificationsEnabled,
  });

  /// The district selected as the default filter. Null means "all districts".
  final String? defaultDistrict;

  final bool notificationsEnabled;

  SettingsState copyWith({
    String? defaultDistrict,
    bool? notificationsEnabled,
    bool clearDistrict = false,
  }) =>
      SettingsState(
        defaultDistrict:
            clearDistrict ? null : defaultDistrict ?? this.defaultDistrict,
        notificationsEnabled:
            notificationsEnabled ?? this.notificationsEnabled,
      );

  @override
  List<Object?> get props => [defaultDistrict, notificationsEnabled];
}
