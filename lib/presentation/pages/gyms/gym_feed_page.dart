import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/gym/gym_bloc.dart';
import '../../blocs/saved_gyms/saved_gyms_cubit.dart';
import '../../widgets/district_dropdown.dart';
import '../../widgets/gym_card.dart';
import '../../widgets/loading_indicator.dart';

/// Main screen: real-time gym feed with district filter.
class GymFeedPage extends StatelessWidget {
  const GymFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GymBloc>()..add(const LoadGyms())),
        BlocProvider(
          create: (ctx) {
            final cubit = sl<SavedGymsCubit>();
            final authState = ctx.read<AuthBloc>().state;
            if (authState is Authenticated) {
              cubit.loadSavedGyms(authState.user.uid);
            }
            return cubit;
          },
        ),
      ],
      child: const _GymFeedView(),
    );
  }
}

class _GymFeedView extends StatelessWidget {
  const _GymFeedView();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isAdmin = authState is Authenticated && authState.user.isAdmin;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.appName),
        actions: [
          // ── District filter dropdown ────────────────────────────────────
          BlocBuilder<GymBloc, GymState>(
            builder: (ctx, state) {
              final selected =
                  state is GymLoaded ? state.selectedDistrict : null;
              return DistrictDropdown(
                selectedDistrict: selected,
                onChanged: (d) =>
                    ctx.read<GymBloc>().add(FilterByDistrict(d)),
              );
            },
          ),
          // ── Admin shortcut ──────────────────────────────────────────────
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              tooltip: 'Admin Dashboard',
              onPressed: () => context.push('/admin'),
            ),
          // ── Saved gyms ──────────────────────────────────────────────────
          IconButton(
            icon: const Icon(Icons.bookmark_outlined),
            tooltip: AppStrings.savedGyms,
            onPressed: () => context.push('/saved'),
          ),
          // ── Settings / Sign-out ─────────────────────────────────────────
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'settings') context.push('/settings');
              if (v == 'logout') {
                context.read<AuthBloc>().add(const SignOutRequested());
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'logout', child: Text('Sign Out')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<GymBloc, GymState>(
          listener: (context, state) {
            if (state is GymOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
              context.read<GymBloc>().add(const LoadGyms());
            }
            if (state is GymError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              GymLoading() => const FitlifeLoadingIndicator(
                  message: AppStrings.loading,
                ),
              GymLoaded(:final filteredGyms) when filteredGyms.isEmpty =>
                const EmptyStateWidget(
                  message: AppStrings.noGyms,
                  icon: Icons.fitness_center,
                ),
              GymLoaded(:final filteredGyms) =>
                BlocBuilder<SavedGymsCubit, SavedGymsState>(
                  builder: (ctx, savedState) {
                    final uid = authState is Authenticated
                        ? authState.user.uid
                        : '';
                    return RefreshIndicator(
                      onRefresh: () async =>
                          ctx.read<GymBloc>().add(const LoadGyms()),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredGyms.length,
                        itemBuilder: (_, i) {
                          final gym = filteredGyms[i];
                          return GymCard(
                            gym: gym,
                            isSaved: savedState.isGymSaved(gym.id),
                            onTap: () =>
                                context.push('/gym/${gym.id}', extra: gym),
                            onSaveToggle: () => ctx
                                .read<SavedGymsCubit>()
                                .toggleSaveGym(uid, gym.id),
                          );
                        },
                      ),
                    );
                  },
                ),
              GymError(:final message) => FitlifeErrorWidget(
                  message: message,
                  onRetry: () =>
                      context.read<GymBloc>().add(const LoadGyms()),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
