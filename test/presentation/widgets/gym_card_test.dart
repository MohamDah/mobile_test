import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fitlife/domain/entities/gym_entity.dart';
import 'package:fitlife/presentation/blocs/saved_gyms/saved_gyms_cubit.dart';
import 'package:fitlife/presentation/blocs/auth/auth_bloc.dart';
import 'package:fitlife/presentation/widgets/gym_card.dart';

// Mocks 

class MockAuthBloc extends Mock implements AuthBloc {}

class MockSavedGymsCubit extends Mock implements SavedGymsCubit {}

// Fixtures 

final _testGym = const GymEntity(
  id: 'gym_1',
  name: 'Kigali Power Gym',
  description: 'Best gym in Gasabo district.',
  district: 'Gasabo',
  subscriptionPrice: 30000,
  galleryUrls: [],
  amenities: ['Pool', 'Sauna'],
);

// Tests 

void main() {
  late MockSavedGymsCubit mockSavedGymsCubit;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockSavedGymsCubit = MockSavedGymsCubit();
    mockAuthBloc = MockAuthBloc();

    // Stub stream so BlocBuilder doesn't throw.
    when(() => mockSavedGymsCubit.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockSavedGymsCubit.state)
        .thenReturn(const SavedGymsState(savedGymIds: []));
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthBloc.state).thenReturn(const Unauthenticated());
  });

  /// Wraps the widget under test with the required BLoC providers.
  Widget buildCard({
    bool isSaved = false,
    VoidCallback? onTap,
    VoidCallback? onSaveToggle,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SavedGymsCubit>.value(value: mockSavedGymsCubit),
        BlocProvider<AuthBloc>.value(value: mockAuthBloc),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: GymCard(
            gym: _testGym,
            isSaved: isSaved,
            onTap: onTap ?? () {},
            onSaveToggle: onSaveToggle ?? () {},
          ),
        ),
      ),
    );
  }

  group('GymCard widget tests', () {
    testWidgets('renders gym name', (tester) async {
      await tester.pumpWidget(buildCard());
      expect(find.text('Kigali Power Gym'), findsOneWidget);
    });

    testWidgets('renders district label', (tester) async {
      await tester.pumpWidget(buildCard());
      expect(find.text('Gasabo'), findsOneWidget);
    });

    testWidgets('renders subscription price', (tester) async {
      await tester.pumpWidget(buildCard());
      // Price is rendered via RichText — search the plain string representation.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('30000'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders amenity chips (max 3)', (tester) async {
      await tester.pumpWidget(buildCard());
      expect(find.text('Pool'), findsOneWidget);
      expect(find.text('Sauna'), findsOneWidget);
    });

    testWidgets('shows filled bookmark icon when saved', (tester) async {
      await tester.pumpWidget(buildCard(isSaved: true));
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('shows outlined bookmark icon when not saved', (tester) async {
      await tester.pumpWidget(buildCard(isSaved: false));
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildCard(onTap: () => tapped = true));
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('calls onSaveToggle when bookmark is tapped', (tester) async {
      var toggled = false;
      await tester.pumpWidget(buildCard(onSaveToggle: () => toggled = true));
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pump();
      expect(toggled, isTrue);
    });
  });
}
