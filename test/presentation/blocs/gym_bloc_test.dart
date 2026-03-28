import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fitlife/domain/entities/gym_entity.dart';
import 'package:fitlife/domain/usecases/gym/get_gyms_stream_usecase.dart';
import 'package:fitlife/domain/usecases/gym/gym_usecases.dart';
import 'package:fitlife/presentation/blocs/gym/gym_bloc.dart';

// Mocks

class MockGetGymsStreamUseCase extends Mock implements GetGymsStreamUseCase {}

class MockCreateGymUseCase extends Mock implements CreateGymUseCase {}

class MockUpdateGymUseCase extends Mock implements UpdateGymUseCase {}

class MockDeleteGymUseCase extends Mock implements DeleteGymUseCase {}

// Fixtures

final _gasaboGym = const GymEntity(
  id: 'g1',
  name: 'Gasabo Fitness',
  description: 'Top gym',
  district: 'Gasabo',
  subscriptionPrice: 25000,
  galleryUrls: [],
  amenities: [],
);

final _kicukiroGym = const GymEntity(
  id: 'g2',
  name: 'Kicukiro Gym',
  description: 'Great gym',
  district: 'Kicukiro',
  subscriptionPrice: 20000,
  galleryUrls: [],
  amenities: [],
);

// Tests

void main() {
  late MockGetGymsStreamUseCase mockGetGymsStream;
  late MockCreateGymUseCase mockCreateGym;
  late MockUpdateGymUseCase mockUpdateGym;
  late MockDeleteGymUseCase mockDeleteGym;
  late FilterGymsByDistrictUseCase filterGyms;

  setUp(() {
    mockGetGymsStream = MockGetGymsStreamUseCase();
    mockCreateGym = MockCreateGymUseCase();
    mockUpdateGym = MockUpdateGymUseCase();
    mockDeleteGym = MockDeleteGymUseCase();
    filterGyms = const FilterGymsByDistrictUseCase();

    // Default: stream emits both gyms.
    when(() => mockGetGymsStream())
        .thenAnswer((_) => Stream.value([_gasaboGym, _kicukiroGym]));
  });

  GymBloc buildBloc() => GymBloc(
        getGymsStream: mockGetGymsStream,
        filterGyms: filterGyms,
        createGym: mockCreateGym,
        updateGym: mockUpdateGym,
        deleteGym: mockDeleteGym,
      );

  /// Test 1: LoadGyms emits GymLoaded with the full list.
  blocTest<GymBloc, GymState>(
    'LoadGyms emits [GymLoading, GymLoaded] with both gyms',
    build: buildBloc,
    act: (bloc) => bloc.add(const LoadGyms()),
    expect: () => [
      const GymLoading(),
      isA<GymLoaded>().having(
        (s) => s.allGyms.length,
        'allGyms length',
        2,
      ),
    ],
  );

  /// Test 2: FilterByDistrict('Gasabo') returns only Gasabo gyms.
  blocTest<GymBloc, GymState>(
    'FilterByDistrict("Gasabo") filters to only Gasabo gyms',
    build: buildBloc,
    seed: () => GymLoaded(
      allGyms: [_gasaboGym, _kicukiroGym],
      filteredGyms: [_gasaboGym, _kicukiroGym],
    ),
    act: (bloc) => bloc.add(const FilterByDistrict('Gasabo')),
    expect: () => [
      isA<GymLoaded>()
          .having((s) => s.filteredGyms.length, 'filtered count', 1)
          .having(
            (s) => s.filteredGyms.first.district,
            'district',
            'Gasabo',
          )
          .having((s) => s.selectedDistrict, 'selectedDistrict', 'Gasabo'),
    ],
  );

  /// Test 3: FilterByDistrict(null) clears the filter and returns all gyms.
  blocTest<GymBloc, GymState>(
    'FilterByDistrict(null) clears filter and returns all gyms',
    build: buildBloc,
    seed: () => GymLoaded(
      allGyms: [_gasaboGym, _kicukiroGym],
      filteredGyms: [_gasaboGym],
      selectedDistrict: 'Gasabo',
    ),
    act: (bloc) => bloc.add(const FilterByDistrict(null)),
    expect: () => [
      isA<GymLoaded>()
          .having((s) => s.filteredGyms.length, 'all gyms count', 2)
          .having((s) => s.selectedDistrict, 'selectedDistrict', isNull),
    ],
  );

  /// Test 4: DeleteGymRequested emits GymOperationSuccess on success.
  blocTest<GymBloc, GymState>(
    'DeleteGymRequested emits [GymOperationLoading, GymOperationSuccess]',
    build: () {
      when(() => mockDeleteGym(any())).thenAnswer((_) async {});
      return buildBloc();
    },
    act: (bloc) => bloc.add(const DeleteGymRequested('g1')),
    expect: () => [
      const GymOperationLoading(),
      isA<GymOperationSuccess>(),
    ],
  );

  /// Test 5: FilterGymsByDistrictUseCase unit test (pure Dart, no BLoC).
  group('FilterGymsByDistrictUseCase unit tests', () {
    final useCase = const FilterGymsByDistrictUseCase();
    final gyms = [_gasaboGym, _kicukiroGym];

    test('returns full list when district is null', () {
      final result = useCase(gyms: gyms, district: null);
      expect(result.length, 2);
    });

    test('returns full list when district is empty string', () {
      final result = useCase(gyms: gyms, district: '');
      expect(result.length, 2);
    });

    test('returns only matching gyms for a specific district', () {
      final result = useCase(gyms: gyms, district: 'Kicukiro');
      expect(result.length, 1);
      expect(result.first.id, 'g2');
    });
  });
}
