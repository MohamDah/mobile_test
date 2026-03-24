import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/gym_entity.dart';
import '../../blocs/gym/gym_bloc.dart';
import '../../widgets/loading_indicator.dart';

/// Admin-only screen listing all gyms with Edit and Delete actions.
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GymBloc>()..add(const LoadGyms()),
      child: const _AdminDashboardView(),
    );
  }
}

class _AdminDashboardView extends StatelessWidget {
  const _AdminDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.adminDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: AppStrings.addGym,
            onPressed: () => context.push('/admin/gym/new'),
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
              GymLoading() ||
              GymOperationLoading() =>
                const FitlifeLoadingIndicator(message: 'Loading gyms…'),
              GymLoaded(:final allGyms) when allGyms.isEmpty =>
                const EmptyStateWidget(
                  message: 'No gyms yet. Tap + to add one.',
                  icon: Icons.fitness_center,
                ),
              GymLoaded(:final allGyms) => _GymAdminList(gyms: allGyms),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/gym/new'),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addGym),
      ),
    );
  }
}

class _GymAdminList extends StatelessWidget {
  const _GymAdminList({required this.gyms});
  final List<GymEntity> gyms;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: gyms.length,
      separatorBuilder: (ctx, i) => const Divider(height: 1),
      itemBuilder: (ctx, i) {
        final gym = gyms[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withAlpha(20),
            child:
                const Icon(Icons.fitness_center, color: AppColors.primary),
          ),
          title: Text(
            gym.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${gym.district} · RWF ${gym.subscriptionPrice.toStringAsFixed(0)}/mo',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: AppColors.primary,
                tooltip: AppStrings.editGym,
                onPressed: () =>
                    context.push('/admin/gym/${gym.id}/edit', extra: gym),
              ),
              // Delete
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                tooltip: AppStrings.deleteGym,
                onPressed: () => _confirmDelete(context, gym),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, GymEntity gym) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text(AppStrings.deleteGym),
        content: Text(
          'Delete "${gym.name}"?\n\n${AppStrings.confirmDelete}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context
                  .read<GymBloc>()
                  .add(DeleteGymRequested(gym.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.deleteGym),
          ),
        ],
      ),
    );
  }
}
