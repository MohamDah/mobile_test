import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/gym/gym_bloc.dart';
import '../../blocs/saved_gyms/saved_gyms_cubit.dart';
import '../../widgets/gym_card.dart';
import '../../widgets/loading_indicator.dart';

/// Displays only the gyms the user has bookmarked.
class SavedGymsPage extends StatelessWidget {
  const SavedGymsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final uid = authState is Authenticated ? authState.user.uid : '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<GymBloc>()..add(const LoadGyms()),
        ),
        BlocProvider(
          create: (_) {
            final cubit = sl<SavedGymsCubit>();
            if (uid.isNotEmpty) cubit.loadSavedGyms(uid);
            return cubit;
          },
        ),
      ],
      child: const _SavedGymsView(),
    );
  }
}

class _SavedGymsView extends StatelessWidget {
  const _SavedGymsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.savedGyms)),
      body: SafeArea(
        child: BlocBuilder<GymBloc, GymState>(
          builder: (context, gymState) {
            if (gymState is GymLoading) {
              return const FitlifeLoadingIndicator();
            }
            if (gymState is! GymLoaded) {
              return const FitlifeErrorWidget(message: AppStrings.error);
            }

            return BlocBuilder<SavedGymsCubit, SavedGymsState>(
              builder: (ctx, savedState) {
                final savedGyms = gymState.allGyms
                    .where((g) => savedState.isGymSaved(g.id))
                    .toList();

                if (savedGyms.isEmpty) {
                  return const EmptyStateWidget(
                    message: AppStrings.noSavedGyms,
                    icon: Icons.bookmark_border,
                  );
                }

                final auth = ctx.read<AuthBloc>().state;
                final uid = auth is Authenticated ? auth.user.uid : '';

                return ListView.builder(
                  itemCount: savedGyms.length,
                  itemBuilder: (_, i) {
                    final gym = savedGyms[i];
                    return GymCard(
                      gym: gym,
                      isSaved: true,
                      onTap: () =>
                          context.push('/gym/${gym.id}', extra: gym),
                      onSaveToggle: () => ctx
                          .read<SavedGymsCubit>()
                          .toggleSaveGym(uid, gym.id),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
