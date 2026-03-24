import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitlife/core/constants/app_constants.dart';
import 'package:fitlife/presentation/widgets/district_dropdown.dart';

void main() {
  group('DistrictDropdown widget tests', () {
    /// Helper that pumps the dropdown with an optional initial selection.
    Widget buildDropdown({
      String? selected,
      required ValueChanged<String?> onChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: DistrictDropdown(
            selectedDistrict: selected,
            onChanged: onChanged,
          ),
        ),
      );
    }

    testWidgets('shows "All Districts" option', (tester) async {
      await tester.pumpWidget(buildDropdown(onChanged: (_) {}));
      // Open the dropdown.
      await tester.tap(find.byKey(const Key('district_dropdown')));
      await tester.pumpAndSettle();
      expect(find.text('All Districts'), findsWidgets);
    });

    testWidgets('shows all three Kigali districts', (tester) async {
      await tester.pumpWidget(buildDropdown(onChanged: (_) {}));
      await tester.tap(find.byKey(const Key('district_dropdown')));
      await tester.pumpAndSettle();

      for (final d in AppConstants.districts) {
        expect(find.text(d), findsWidgets);
      }
    });

    testWidgets('calls onChanged with selected district value', (tester) async {
      String? emitted;
      await tester.pumpWidget(
        buildDropdown(onChanged: (v) => emitted = v),
      );
      await tester.tap(find.byKey(const Key('district_dropdown')));
      await tester.pumpAndSettle();

      // Tap the first real district.
      await tester.tap(find.text('Gasabo').last);
      await tester.pumpAndSettle();

      expect(emitted, equals('Gasabo'));
    });

    testWidgets('calls onChanged with null when "All Districts" selected',
        (tester) async {
      String? emitted = 'Gasabo'; // start with a selection
      await tester.pumpWidget(
        buildDropdown(
          selected: 'Gasabo',
          onChanged: (v) => emitted = v,
        ),
      );
      await tester.tap(find.byKey(const Key('district_dropdown')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All Districts').last);
      await tester.pumpAndSettle();

      expect(emitted, isNull);
    });
  });
}
