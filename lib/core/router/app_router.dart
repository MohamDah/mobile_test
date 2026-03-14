import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/gym_entity.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/auth/auth_state.dart';
import '../../presentation/blocs/gym/gym_bloc.dart';
import '../../presentation/blocs/saved_gyms/saved_gyms_cubit.dart';
import '../../presentation/blocs/settings/settings_cubit.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';
import '../../presentation/pages/admin/admin_dashboard_page.dart';
import '../../presentation/pages/admin/gym_form_page.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/gyms/gym_detail_page.dart';
import '../../presentation/pages/gyms/gym_feed_page.dart';
import '../../presentation/pages/gyms/saved_gyms_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../di/injection.dart';

/// Builds the application's [GoRouter].
///
/// Route guards:
/// - Unauthenticated users → /login
/// - Non-admin users → / from any /admin route
GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthStateNotifier(context.read<AuthBloc>()),
    redirect: (ctx, state) {
      final authState = ctx.read<AuthBloc>().state;
      final isAuthenticated = authState is Authenticated;
      final isAdmin = isAuthenticated && authState.user.isAdmin;

      final isOnAuthPage = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot-password');

      if (!isAuthenticated && !isOnAuthPage) return '/login';
      if (isAuthenticated && isOnAuthPage) return '/';
      if (!isAdmin && state.matchedLocation.startsWith('/admin')) return '/';

      return null;
    },
    routes: [
      // ── Auth ────────────────────────────────────────────────────────────
      GoRoute(path: '/login', builder: (_, s) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, s) => const RegisterPage()),
      GoRoute(
        path: '/forgot-password',
        builder: (_, s) => const ForgotPasswordPage(),
      ),

      // ── Main app shell ───────────────────────────────────────────────────
      GoRoute(
        path: '/',
        builder: (_, s) => const GymFeedPage(),
        routes: [
          GoRoute(
            path: 'gym/:id',
            builder: (_, state) {
              final gym = state.extra as GymEntity?;
              if (gym == null) return const _GymNotFoundPage();
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: sl<SavedGymsCubit>()),
                  BlocProvider.value(value: sl<ThemeCubit>()),
                ],
                child: GymDetailPage(gym: gym),
              );
            },
          ),
          GoRoute(
            path: 'saved',
            builder: (_, s) => const SavedGymsPage(),
          ),
          GoRoute(
            path: 'settings',
            builder: (ctx, s) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: ctx.read<ThemeCubit>()),
                BlocProvider.value(value: ctx.read<SettingsCubit>()),
              ],
              child: const SettingsPage(),
            ),
          ),
          // ── Admin routes ─────────────────────────────────────────────────
          GoRoute(
            path: 'admin',
            builder: (_, s) => const AdminDashboardPage(),
            routes: [
              GoRoute(
                path: 'gym/new',
                builder: (_, s) => BlocProvider(
                  create: (_) => sl<GymBloc>(),
                  child: const GymFormPage(),
                ),
              ),
              GoRoute(
                path: 'gym/:gymId/edit',
                builder: (_, state) {
                  final gym = state.extra as GymEntity?;
                  if (gym == null) return const _GymNotFoundPage();
                  return BlocProvider(
                    create: (_) => sl<GymBloc>(),
                    child: GymFormPage(existingGym: gym),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Bridges [AuthBloc] state changes to [GoRouter]'s refresh mechanism.
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(this._bloc) {
    _bloc.stream.listen((_) => notifyListeners());
  }
  final AuthBloc _bloc;
}

class _GymNotFoundPage extends StatelessWidget {
  const _GymNotFoundPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(child: Text('Gym not found.')),
    );
  }
}
