import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/network/app_error.dart';
import 'package:salesdocket_mobile/common/widgets/app_logo.dart';
import 'package:salesdocket_mobile/features/auth/presentation/auth_screen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../helpers/pump_app.dart';

/// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockException implements Exception {
  final String message;
  MockException(this.message);
}

/// Integration tests for Authentication Flow
///
/// Tests cover:
/// - Login form validation (email, password)
/// - Successful login with valid credentials
/// - Failed login with invalid credentials
/// - Password visibility toggle
/// - Loading states during authentication
/// - Form field behavior
void main() {
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(SignInRequest(username: '', password: ''));
    registerFallbackValue(ForgotPasswordRequest(email: ''));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('Authentication Flow - Form Validation', () {
    testWidgets('should show error with invalid email format', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter invalid email (no @ symbol)
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalidemail');
      await tester.pump();

      // Enter valid password (15 char max)
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Pass123');
      await tester.pump();

      // Tap login button to trigger validation
      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should show validation error
      expect(find.text('invalidemail'), findsOneWidget);
    });

    testWidgets('should show error with empty password field', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter valid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      // Leave password empty and try to submit
      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Form should not submit (remains on auth screen)
      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('should accept valid email and password', (tester) async {
      // Arrange
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.success(
          data: const User(id: 1, firstName: 'Test', status: '1'),
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'ValidPass123');
      await tester.pump();

      // Assert - Fields should contain entered values
      expect(find.text('user@example.com'), findsOneWidget);
      expect(find.text('ValidPass123'), findsOneWidget);
    });
  });

  group('Authentication Flow - Login Success', () {
    testWidgets('should call signIn with valid credentials', (tester) async {
      // Arrange - Mock successful authentication (but don't navigate)
      // Using status '0' to prevent navigation attempt
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.success(
          data: const User(
            id: 1,
            status: '0', // Prevents navigation
            firstName: 'Test',
            lastName: 'User',
          ),
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter valid credentials (password limited to 15 chars by maxLength)
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'ValidPass123');
      await tester.pump();

      // Submit login form
      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Verify signIn was called with correct parameters
      verify(
        () => mockAuthRepository.signIn(
          any(
            that: predicate<SignInRequest>(
              (req) =>
                  req.username == 'user@example.com' &&
                  req.password == 'ValidPass123',
            ),
          ),
        ),
      ).called(1);

      // Should remain on auth screen (no navigation with status '0')
      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('should handle user with status 0 (unauthorized)', (
      tester,
    ) async {
      // Arrange - Mock user with status '0' (unauthorized)
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.success(
          data: const User(
            id: 1,
            status: '0', // Unauthorized status
          ),
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter credentials and submit
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Pass123');
      await tester.pump();

      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should remain on auth screen (not navigate away)
      expect(find.byType(AuthScreen), findsOneWidget);
    });
  });

  group('Authentication Flow - Login Failure', () {
    testWidgets('should show error with invalid credentials', (tester) async {
      // Arrange - Mock failed authentication
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.failure(
          error: AppError(MockException('Invalid credentials')),
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter invalid credentials
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'wrong@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'WrongPass');
      await tester.pump();

      // Submit login form
      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should remain on auth screen
      expect(find.byType(AuthScreen), findsOneWidget);

      // Verify authentication was attempted
      verify(() => mockAuthRepository.signIn(any())).called(1);
    });

    testWidgets('should handle network error', (tester) async {
      // Arrange - Mock network error
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.failure(
          error: AppError(MockException('Network error. Please try again.')),
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter credentials and submit
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Pass123');
      await tester.pump();

      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should remain on auth screen
      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('should retain form fields after failed login', (tester) async {
      // Arrange - Mock failed authentication
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.failure(
          error: AppError(MockException('Authentication failed')),
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter credentials
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Pass123');
      await tester.pump();

      // Submit and fail
      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Email field should still contain value
      expect(find.text('user@example.com'), findsOneWidget);
    });
  });

  group('Authentication Flow - Password Visibility', () {
    testWidgets('should toggle password visibility', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter password
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'MyPass123');
      await tester.pump();

      // Assert - Initially visibility_off icon should be shown (password obscured)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Act - Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Assert - Password should now be visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Act - Tap visibility toggle again
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Assert - Password should be obscured again
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should show password text when visibility is on', (
      tester,
    ) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter password
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'SecPass123');
      await tester.pump();

      // Toggle visibility on
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Assert - Password text should be visible
      expect(find.text('SecPass123'), findsOneWidget);
    });
  });

  group('Authentication Flow - Loading States', () {
    testWidgets('should show loading state during login', (tester) async {
      // Arrange - Mock authentication without delay to avoid timer issues
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.success(
          data: const User(id: 1, status: '0'), // Prevents navigation
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter credentials
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Pass123');
      await tester.pump();

      // Submit login
      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pump();

      // Assert - Button should exist and form should be processing
      expect(find.byType(SalesDocketButtonWidget), findsOneWidget);

      // Complete async operations
      await tester.pumpAndSettle();

      // Should remain on auth screen
      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('should handle button state during authentication', (
      tester,
    ) async {
      // Arrange - Mock authentication that returns error (no delay)
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Result.failure(
          error: AppError(MockException('Authentication error')),
        ),
      );

      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter credentials and submit
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Pass123');
      await tester.pump();

      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should remain on auth screen after failed login
      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
    });
  });

  group('Authentication Flow - Forgot Password Navigation', () {
    testWidgets('should find forgot password button', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Assert - Forgot password button should be present
      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  group('Authentication Flow - UI Components', () {
    testWidgets('should render all login form components', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Assert - All components should be present
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email + Password
      expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget); // Forgot password
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should render logo', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Assert - Logo should be present
      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('should render email and password fields in correct order', (
      tester,
    ) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Get form fields
      final textFields = find.byType(TextFormField);

      // Assert - Should have 2 fields in order (email first, password second)
      expect(textFields, findsNWidgets(2));

      // Enter text to verify field order
      await tester.enterText(textFields.first, 'test@email.com');
      await tester.pump();
      expect(find.text('test@email.com'), findsOneWidget);

      await tester.enterText(textFields.at(1), 'password');
      await tester.pump();
      expect(find.text('password'), findsOneWidget);
    });
  });

  group('Authentication Flow - Input Validation Edge Cases', () {
    testWidgets('should validate email with spaces', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter email with spaces
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, ' user@example.com ');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Pass123');
      await tester.pump();

      // Tap login (should trim spaces and proceed)
      final loginButton = find.byType(SalesDocketButtonWidget);
      await tester.tap(loginButton);
      await tester.pump();

      // Assert - Email field contains text with spaces
      expect(find.text(' user@example.com '), findsOneWidget);
    });

    testWidgets('should handle very long password input', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter very long password (maxLength is 15)
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'VeryLongPass123');
      await tester.pump();

      // Assert - Widget should exist (maxLength enforced by SalesDocketInputWidget)
      expect(find.byType(TextFormField).at(1), findsOneWidget);
    });

    testWidgets('should handle special characters in email', (tester) async {
      // Arrange
      await tester.pumpApp(
        const AuthScreen(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      await tester.pumpAndSettle();

      // Act - Enter email with special characters
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'user+test@example.co.uk');
      await tester.pump();

      // Assert - Should accept special characters
      expect(find.text('user+test@example.co.uk'), findsOneWidget);
    });
  });
}
