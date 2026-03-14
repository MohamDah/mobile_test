// TODO(Person4): Implement fully.
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.defaultDistrict,
    this.notificationsEnabled = true,
  });
  final String? defaultDistrict;
  final bool notificationsEnabled;
  @override
  List<Object?> get props => [defaultDistrict, notificationsEnabled];
}
