import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_header_widget.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('LeadItemHeaderWidget', () {
    testWidgets('should render without errors when lead has status', (
      tester,
    ) async {
      // Arrange
      final tLead = Lead(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        leadState: 'active',
      );

      // Act
      await tester.pumpApp(
        LeadItemHeaderWidget(lead: tLead),
        overrides: [profileProvider.overrideWith((ref) => null)],
      );

      // Assert
      expect(find.byType(LeadItemHeaderWidget), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('should render without errors when status is empty', (
      tester,
    ) async {
      // Arrange
      final tLead = Lead(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        leadState: null,
      );

      // Act
      await tester.pumpApp(
        LeadItemHeaderWidget(lead: tLead),
        overrides: [profileProvider.overrideWith((ref) => null)],
      );

      // Assert
      expect(find.byType(LeadItemHeaderWidget), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should render without errors when lead is CC lead', (
      tester,
    ) async {
      // Arrange
      final tLead = Lead(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        leadState: 'active',
        isCCLead: 1,
      );

      // Act
      await tester.pumpApp(
        LeadItemHeaderWidget(lead: tLead),
        overrides: [profileProvider.overrideWith((ref) => null)],
      );

      // Assert
      expect(find.byType(LeadItemHeaderWidget), findsOneWidget);
    });

    testWidgets('should use Container with proper decoration', (tester) async {
      // Arrange
      final tLead = Lead(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        leadState: 'active',
      );

      // Act
      await tester.pumpApp(
        LeadItemHeaderWidget(lead: tLead),
        overrides: [profileProvider.overrideWith((ref) => null)],
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LeadItemHeaderWidget), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsWidgets);
    });
  });
}
