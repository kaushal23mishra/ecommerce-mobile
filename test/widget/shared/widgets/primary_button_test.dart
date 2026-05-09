import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_mobile/shared/widgets/primary_button.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('PrimaryButton', () {
    group('Rendering', () {
      testWidgets('should render button with label', (tester) async {
        // Arrange
        const label = 'Sign In';

        // Act
        await tester.pumpApp(
          const PrimaryButton(label: label, onPressed: null),
        );

        // Assert
        expect(find.text(label), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should render with custom label', (tester) async {
        // Arrange
        const customLabel = 'Custom Action';

        // Act
        await tester.pumpApp(
          const PrimaryButton(label: customLabel, onPressed: null),
        );

        // Assert
        expect(find.text(customLabel), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('should call onPressed when tapped', (tester) async {
        // Arrange
        var pressed = false;

        await tester.pumpApp(
          PrimaryButton(label: 'Click Me', onPressed: () => pressed = true),
        );

        // Act
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        expect(pressed, true);
      });

      testWidgets('should not call onPressed when disabled', (tester) async {
        // Arrange
        var pressed = false;

        await tester.pumpApp(PrimaryButton(label: 'Disabled', onPressed: null));

        // Act
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        expect(pressed, false);
      });

      testWidgets('should call onPressed multiple times', (tester) async {
        // Arrange
        var pressCount = 0;

        await tester.pumpApp(
          PrimaryButton(label: 'Counter', onPressed: () => pressCount++),
        );

        // Act
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        expect(pressCount, 3);
      });
    });

    group('Loading state', () {
      testWidgets('should show loading indicator when isLoading is true', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(
          PrimaryButton(label: 'Sign In', onPressed: () {}, isLoading: true),
        );

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Sign In'), findsNothing);
      });

      testWidgets('should hide label when isLoading is true', (tester) async {
        // Arrange
        const label = 'Processing';

        // Act
        await tester.pumpApp(
          PrimaryButton(label: label, onPressed: () {}, isLoading: true),
        );

        // Assert
        expect(find.text(label), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should not call onPressed when isLoading is true', (
        tester,
      ) async {
        // Arrange
        var pressed = false;

        await tester.pumpApp(
          PrimaryButton(
            label: 'Loading',
            onPressed: () => pressed = true,
            isLoading: true,
          ),
        );

        // Act
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        expect(pressed, false);
      });

      testWidgets('should show label when isLoading is false', (tester) async {
        // Arrange
        const label = 'Submit';

        // Act
        await tester.pumpApp(
          PrimaryButton(label: label, onPressed: () {}, isLoading: false),
        );

        // Assert
        expect(find.text(label), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should toggle between loading and normal state', (
        tester,
      ) async {
        // Arrange
        const label = 'Submit';
        var isLoading = false;

        // Act - Initial state
        await tester.pumpApp(
          StatefulBuilder(
            builder: (context, setState) {
              return PrimaryButton(
                label: label,
                onPressed: () {
                  setState(() => isLoading = !isLoading);
                },
                isLoading: isLoading,
              );
            },
          ),
        );

        // Assert - Normal state
        expect(find.text(label), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Act - Trigger loading
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert - Loading state
        expect(find.text(label), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Disabled state', () {
      testWidgets('should be disabled when onPressed is null', (tester) async {
        // Act
        await tester.pumpApp(
          const PrimaryButton(label: 'Disabled', onPressed: null),
        );

        // Assert
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNull);
      });

      testWidgets('should be enabled when onPressed is provided', (
        tester,
      ) async {
        // Act
        await tester.pumpApp(PrimaryButton(label: 'Enabled', onPressed: () {}));

        // Assert
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNotNull);
      });
    });

    group('Styling', () {
      testWidgets('should have correct widget type', (tester) async {
        // Act
        await tester.pumpApp(PrimaryButton(label: 'Button', onPressed: () {}));

        // Assert
        expect(find.byType(PrimaryButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should render text as child of button', (tester) async {
        // Arrange
        const label = 'Test Label';

        // Act
        await tester.pumpApp(PrimaryButton(label: label, onPressed: () {}));

        // Assert
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.child, isA<Text>());
      });
    });

    group('Edge cases', () {
      testWidgets('should handle empty label', (tester) async {
        // Act
        await tester.pumpApp(PrimaryButton(label: '', onPressed: () {}));

        // Assert
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should handle very long label', (tester) async {
        // Arrange
        const longLabel =
            'This is a very long button label that might overflow';

        // Act
        await tester.pumpApp(PrimaryButton(label: longLabel, onPressed: () {}));

        // Assert
        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('should handle special characters in label', (tester) async {
        // Arrange
        const specialLabel = '!@#\$%^&*()_+{}[]|\\:";\'<>?,./';

        // Act
        await tester.pumpApp(
          PrimaryButton(label: specialLabel, onPressed: () {}),
        );

        // Assert
        expect(find.text(specialLabel), findsOneWidget);
      });

      testWidgets('should handle unicode characters in label', (tester) async {
        // Arrange
        const unicodeLabel = '登录 साइन इन';

        // Act
        await tester.pumpApp(
          PrimaryButton(label: unicodeLabel, onPressed: () {}),
        );

        // Assert
        expect(find.text(unicodeLabel), findsOneWidget);
      });
    });
  });
}
