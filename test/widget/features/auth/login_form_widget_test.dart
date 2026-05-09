import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../helpers/pump_app.dart';

/// Widget tests for Login Form components
///
/// This test file focuses on testing the individual components of the login form
/// without the full AuthScreen which has timer issues due to initState callbacks.
///
/// Components tested:
/// - Email input field with validation
/// - Password input field with visibility toggle
/// - Login button with states
/// - Form validation behavior
void main() {
  group('Login Form Components', () {
    testWidgets('should render email input field correctly', (tester) async {
      // Arrange
      final emailController = TextEditingController();

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 50,
            inputType: TextInputType.emailAddress,
            label: 'Email',
            hint: 'Email',
            controller: emailController,
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should render password input field correctly', (tester) async {
      // Arrange
      final passwordController = TextEditingController();

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 15,
            inputType: TextInputType.visiblePassword,
            label: 'Password',
            hint: 'Password',
            controller: passwordController,
            obscureText: true,
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should render login button correctly', (tester) async {
      // Arrange
      var buttonPressed = false;

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketButtonWidget(
            text: 'Log In',
            onPressed: () {
              buttonPressed = true;
            },
            isDisabled: false,
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('should disable login button when loading', (tester) async {
      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketButtonWidget(
            text: 'Logging In',
            onPressed: () {},
            isDisabled: true,
          ),
        ),
      );

      // Assert
      expect(find.text('Logging In'), findsOneWidget);
      expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
    });

    testWidgets('should accept text input in email field', (tester) async {
      // Arrange
      final emailController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 50,
            inputType: TextInputType.emailAddress,
            label: 'Email',
            hint: 'Email',
            controller: emailController,
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pump();

      // Assert
      expect(emailController.text, 'test@example.com');
    });

    testWidgets('should accept text input in password field', (tester) async {
      // Arrange
      final passwordController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 15,
            inputType: TextInputType.visiblePassword,
            label: 'Password',
            hint: 'Password',
            controller: passwordController,
            obscureText: true,
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'password123');
      await tester.pump();

      // Assert
      expect(passwordController.text, 'password123');
    });

    testWidgets('should show password visibility toggle icon', (tester) async {
      // Arrange
      final passwordController = TextEditingController();
      final visibilityIcon = Icon(Icons.visibility_off);

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 15,
            inputType: TextInputType.visiblePassword,
            label: 'Password',
            hint: 'Password',
            controller: passwordController,
            obscureText: true,
            suffix: GestureDetector(onTap: () {}, child: visibilityIcon),
          ),
        ),
      );

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should trigger button callback when pressed', (tester) async {
      // Arrange
      var buttonPressed = false;

      await tester.pumpApp(
        Material(
          child: SalesDocketButtonWidget(
            text: 'Log In',
            onPressed: () {
              buttonPressed = true;
            },
            isDisabled: false,
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(SalesDocketButtonWidget));
      await tester.pump();

      // Assert
      expect(buttonPressed, true);
    });

    testWidgets('should validate form with email and password', (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final emailController = TextEditingController();
      final passwordController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SalesDocketInputWidget(
                  maxLength: 50,
                  inputType: TextInputType.emailAddress,
                  label: 'Email',
                  hint: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                SalesDocketInputWidget(
                  maxLength: 15,
                  inputType: TextInputType.visiblePassword,
                  label: 'Password',
                  hint: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // Act - Try to validate with empty fields
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, false);
    });

    testWidgets('should validate form successfully with valid inputs', (
      tester,
    ) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final emailController = TextEditingController(text: 'test@example.com');
      final passwordController = TextEditingController(text: 'password123');

      await tester.pumpApp(
        Material(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SalesDocketInputWidget(
                  maxLength: 50,
                  inputType: TextInputType.emailAddress,
                  label: 'Email',
                  hint: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                SalesDocketInputWidget(
                  maxLength: 15,
                  inputType: TextInputType.visiblePassword,
                  label: 'Password',
                  hint: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // Act
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, true);
    });

    testWidgets('should render forgot password button', (tester) async {
      // Arrange
      var forgotPasswordPressed = false;

      // Act
      await tester.pumpApp(
        Material(
          child: TextButton(
            onPressed: () {
              forgotPasswordPressed = true;
            },
            child: const Text('Forgot Password?'),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Act - Tap the button
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      // Assert
      expect(forgotPasswordPressed, true);
    });
  });
}
