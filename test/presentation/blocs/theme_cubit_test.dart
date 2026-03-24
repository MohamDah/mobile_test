import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fitlife/data/datasources/local/shared_preferences_datasource.dart';
import 'package:fitlife/presentation/blocs/theme/theme_cubit.dart';

// ── Mock ──────────────────────────────────────────────────────────────────────

class MockSharedPreferencesDataSource extends Mock
    implements SharedPreferencesDataSource {}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late MockSharedPreferencesDataSource mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferencesDataSource();
  });

  /// Helper that builds a [ThemeCubit] with the given stored theme.
  ThemeCubit buildCubit(String storedTheme) {
    when(() => mockPrefs.getThemeMode()).thenReturn(storedTheme);
    when(() => mockPrefs.setThemeMode(any())).thenAnswer((_) async {});
    return ThemeCubit(mockPrefs);
  }

  group('ThemeCubit', () {
    /// Test 1: Initial state is light when 'light' is stored.
    test('initial state is ThemeMode.light when pref is "light"', () {
      final cubit = buildCubit('light');
      expect(cubit.state, ThemeMode.light);
    });

    /// Test 2: Initial state is dark when 'dark' is stored.
    test('initial state is ThemeMode.dark when pref is "dark"', () {
      final cubit = buildCubit('dark');
      expect(cubit.state, ThemeMode.dark);
    });

    /// Test 3: toggleTheme switches from light → dark and persists 'dark'.
    blocTest<ThemeCubit, ThemeMode>(
      'toggleTheme from light emits ThemeMode.dark and persists "dark"',
      build: () => buildCubit('light'),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(() => mockPrefs.setThemeMode('dark')).called(1);
      },
    );

    /// Test 4: toggleTheme switches from dark → light and persists 'light'.
    blocTest<ThemeCubit, ThemeMode>(
      'toggleTheme from dark emits ThemeMode.light and persists "light"',
      build: () => buildCubit('dark'),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(() => mockPrefs.setThemeMode('light')).called(1);
      },
    );

    /// Test 5: setTheme explicitly sets a specific mode.
    blocTest<ThemeCubit, ThemeMode>(
      'setTheme(dark) emits ThemeMode.dark',
      build: () => buildCubit('light'),
      act: (cubit) => cubit.setTheme(ThemeMode.dark),
      expect: () => [ThemeMode.dark],
    );
  });
}
