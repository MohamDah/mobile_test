import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';

/// Allows the user to toggle dark mode, set their default district filter,
/// and toggle push notifications. All changes are persisted via BLoC/Cubit.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: SafeArea(
        child: ListView(
          children: [
            // ── Section: Appearance ──────────────────────────────────────
            const _SectionHeader(label: AppStrings.preferences),

            // Dark Mode toggle
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (ctx, themeMode) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text(AppStrings.darkMode),
                  subtitle: Text(
                    themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled',
                  ),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (_) => ctx.read<ThemeCubit>().toggleTheme(),
                );
              },
            ),
            const Divider(height: 1),

            // ── Section: Feed preferences ────────────────────────────────
            const _SectionHeader(label: 'Feed'),

            // Default District
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (ctx, settings) {
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text(AppStrings.defaultDistrict),
                  subtitle: Text(
                    settings.defaultDistrict ?? AppStrings.allDistricts,
                  ),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () => _showDistrictPicker(ctx, settings),
                );
              },
            ),
            const Divider(height: 1),

            // ── Section: Notifications ───────────────────────────────────
            const _SectionHeader(label: 'Notifications'),

            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (ctx, settings) {
                return SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text(AppStrings.notifications),
                  subtitle: Text(
                    settings.notificationsEnabled ? 'Enabled' : 'Disabled',
                  ),
                  value: settings.notificationsEnabled,
                  onChanged: (_) =>
                      ctx.read<SettingsCubit>().toggleNotifications(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDistrictPicker(BuildContext ctx, SettingsState settings) {
    showModalBottomSheet<void>(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.defaultDistrict,
                style: Theme.of(sheetCtx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              // All districts option
              ListTile(
                title: const Text(AppStrings.allDistricts),
                leading: Icon(
                  settings.defaultDistrict == null
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                onTap: () {
                  ctx.read<SettingsCubit>().setDefaultDistrict(null);
                  Navigator.of(sheetCtx).pop();
                },
              ),
              ...AppConstants.districts.map((d) {
                return ListTile(
                  title: Text(d),
                  leading: Icon(
                    settings.defaultDistrict == d
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  onTap: () {
                    ctx.read<SettingsCubit>().setDefaultDistrict(d);
                    Navigator.of(sheetCtx).pop();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
