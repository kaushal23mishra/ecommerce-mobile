# Comprehensive Testing Strategy for SalesDocket Mobile

## Overview

This document outlines the complete testing strategy for the SalesDocket mobile application. A properly tested module should include **three layers of testing**:

1. **Unit Tests** - Test individual components in isolation
2. **Widget Tests** - Test UI components and their interactions
3. **Integration Tests** - Test complete user flows end-to-end

## Current Test Coverage Status

### ✅ Completed Tests

#### Data Layer (Unit Tests)
- **Auth Module**: 128 tests passing
  - `AuthRepositoryImpl`: 10 tests
  - `AuthDataSourceImpl`: 11 tests
  - Use cases: `SignInUseCase`, `SignOutUseCase`, `GetCurrentUserUseCase`, `ForgotPasswordUseCase`
  - Entities: `UserEntity` tests
  - Mappers: `UserMapper` tests

- **Booking Module**: 32 tests passing
  - `BookingRepositoryImpl`: 10 tests
  - `BookingDataSourceImpl`: 22 tests

- **Lead Module**: 54 tests passing
  - `LeadRepositoryImpl`: 18 tests
  - `LeadDataSourceImpl`: 36 tests
  - Includes followup functionality tests

- **Delivery Module**: 30 tests passing
  - `DeliveryRepositoryImpl`: 11 tests
  - `DeliveryDataSourceImpl`: 19 tests

**Total Data Layer Tests: 244 passing**

#### UI Layer (Widget Tests)
- `PrimaryButton` widget test (existing in `test/widget/shared/widgets/`)

### 🔄 In Progress / Template Created

#### Presentation Layer (Unit Tests)
- **View Model Tests**: Template created at `test/unit/presentation/view_models/lead_view_model_test.dart`
  - Demonstrates testing Riverpod view models
  - Tests business logic layer
  - Requires model adjustments to run

#### Widget Tests
- **Lead Item Header Widget**: Template created at `test/widget/features/lead/lead_item_header_widget_test.dart`
  - Demonstrates widget testing patterns
  - Tests UI component rendering

#### Integration Tests
- **Lead Creation Flow**: Template created at `test/integration/lead_creation_flow_test.dart`
  - Demonstrates end-to-end testing
  - Includes multiple user journey scenarios

## Testing Layers Explained

### 1. Unit Tests (`test/unit/`)

**Purpose**: Test individual classes and functions in complete isolation

**Structure**:
```
test/unit/
├── data/
│   ├── data_sources/      # Test HTTP/API layer
│   ├── repositories/      # Test repository implementations
│   └── mappers/           # Test data transformation
├── domain/
│   ├── use_cases/         # Test business logic
│   └── entities/          # Test domain models
└── presentation/
    └── view_models/       # Test presentation logic
```

**What to Test**:
- ✅ Repository methods delegate correctly to data sources
- ✅ Data sources make correct API calls with proper parameters
- ✅ Error handling and exception propagation
- ✅ Data transformation and mapping
- ✅ Business logic in use cases
- ✅ View model state management and logic

**Example Pattern** (from existing tests):
```dart
test('should return ApiResponse when request succeeds', () async {
  // Arrange - Setup test data and mocks
  final tRequest = CreateLeadRequest(firstName: 'John');
  final tResponse = MockData.createApiResponse(...);

  when(() => mockDataSource.createLead(any()))
      .thenAnswer((_) async => tResponse);

  // Act - Execute the method being tested
  final result = await repository.createLead(req: tRequest);

  // Assert - Verify the outcome
  expect(result.isSuccess, true);
  verify(() => mockDataSource.createLead(tRequest)).called(1);
});
```

### 2. Widget Tests (`test/widget/`)

**Purpose**: Test UI components and user interactions without running on a real device

**Structure**:
```
test/widget/
├── features/
│   ├── lead/              # Lead feature widgets
│   ├── booking/           # Booking feature widgets
│   ├── delivery/          # Delivery feature widgets
│   └── auth/              # Auth feature widgets
└── shared/
    └── widgets/           # Reusable UI components
```

**What to Test**:
- ✅ Widgets render correctly with different inputs
- ✅ User interactions (taps, text input, gestures)
- ✅ Conditional rendering based on state
- ✅ Widget tree structure and layout
- ✅ Accessibility features
- ✅ Form validation UI feedback

**Example Pattern**:
```dart
testWidgets('should display lead status when status is not empty', (tester) async {
  // Arrange
  final tLead = Lead(id: 1, firstName: 'John', state: 'active');

  // Act
  await tester.pumpApp(
    LeadItemHeaderWidget(lead: tLead),
    overrides: [/* provider overrides */],
  );

  // Assert
  expect(find.text('active'), findsOneWidget);
  expect(find.byType(Container), findsWidgets);
});
```

**Helper Functions** (in `test/helpers/pump_app.dart`):
- `pumpApp()` - Wraps widgets with necessary providers and theme
- Provides consistent test environment
- Handles Riverpod provider overrides

### 3. Integration Tests (`test/integration/`)

**Purpose**: Test complete user journeys from start to finish

**Structure**:
```
test/integration/
├── lead_creation_flow_test.dart
├── booking_flow_test.dart
├── authentication_flow_test.dart
└── delivery_flow_test.dart
```

**What to Test**:
- ✅ Complete user workflows (login → navigate → create → submit)
- ✅ Multi-screen navigation flows
- ✅ Data persistence across screens
- ✅ Real-world usage scenarios
- ✅ Edge cases in user journeys

**Example User Flows**:

1. **Lead Creation Flow**:
   - User enters contact → Search duplicates → No duplicates → Fill form → Submit → Success

2. **Authentication Flow**:
   - Launch app → Not authenticated → Navigate to login → Enter credentials → Success → Navigate to dashboard

3. **Booking Flow**:
   - View lead → Create booking → Fill details → Upload documents → Submit → Confirmation

**Integration Test Pattern**:
```dart
testWidgets('complete lead creation flow', (tester) async {
  // Step 1: Launch app and navigate
  await tester.pumpApp(MyApp());
  await tester.tap(find.byKey(Key('create_lead_button')));
  await tester.pumpAndSettle();

  // Step 2: Fill form
  await tester.enterText(find.byKey(Key('first_name')), 'John');
  await tester.enterText(find.byKey(Key('last_name')), 'Doe');

  // Step 3: Submit
  await tester.tap(find.byKey(Key('submit_button')));
  await tester.pumpAndSettle();

  // Step 4: Verify navigation and success
  expect(find.text('Lead created successfully'), findsOneWidget);
});
```

## Test Implementation Guide

### For Each Module, Create:

#### 1. Data Layer Tests (Priority: HIGH)

**Repository Tests** (`test/unit/data/repositories/`):
```dart
// Example: test/unit/data/repositories/[module]_repository_impl_test.dart
// - Test each repository method
// - Verify delegation to data source
// - Test error handling
// - Verify Result pattern usage
```

**Data Source Tests** (`test/unit/data/data_sources/`):
```dart
// Example: test/unit/data/data_sources/[module]_data_source_impl_test.dart
// - Test HTTP requests to correct endpoints
// - Verify request parameters and headers
// - Test response parsing
// - Test error scenarios (timeout, 404, 500, etc.)
```

#### 2. Presentation Layer Tests (Priority: MEDIUM)

**View Model Tests** (`test/unit/presentation/view_models/`):
```dart
// Example: test/unit/presentation/view_models/[module]_view_model_test.dart
// - Test state management logic
// - Test business logic in view models
// - Test provider interactions
// - Test filter/search/validation logic
```

**Widget Tests** (`test/widget/features/[module]/`):
```dart
// Example: test/widget/features/lead/[widget_name]_test.dart
// - Test widget rendering
// - Test user interactions
// - Test conditional UI
// - Test form validation feedback
```

#### 3. Integration Tests (Priority: LOW, but IMPORTANT)

**Flow Tests** (`test/integration/`):
```dart
// Example: test/integration/[module]_flow_test.dart
// - Test happy path scenarios
// - Test error scenarios
// - Test edge cases
// - Test multi-screen workflows
```

## Running Tests

### Run All Tests
```bash
flutter test --no-pub
```

### Run Specific Test File
```bash
flutter test test/unit/data/repositories/auth_repository_impl_test.dart --no-pub
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # View in browser
```

### Run Integration Tests
```bash
# Template tests (current setup)
flutter test test/integration/

# For actual device/emulator integration tests:
# 1. Add integration_test package to pubspec.yaml
# 2. Move tests to integration_test/ directory
# 3. Run with: flutter test integration_test/
```

### Run Widget Tests Only
```bash
flutter test test/widget/
```

### Run Unit Tests Only
```bash
flutter test test/unit/
```

## Test Quality Guidelines

### ✅ DO:
- Use **AAA pattern** (Arrange, Act, Assert)
- Write **descriptive test names** that explain what is being tested
- **Mock dependencies** completely - no real HTTP calls, no real database
- Test **both success and failure** scenarios
- Test **edge cases** (null, empty lists, invalid input)
- Use **meaningful variable names** prefixed with 't' (e.g., `tLead`, `tRequest`)
- **Verify mock calls** to ensure correct interactions
- Keep tests **independent** - no test should depend on another

### ❌ DON'T:
- Make real API calls in unit tests
- Share state between tests
- Test implementation details (private methods)
- Write tests that depend on execution order
- Skip error scenario testing
- Hardcode magic numbers without explanation
- Leave commented-out test code

## Testing Tools & Packages

### Core Testing
- `flutter_test`: Flutter's testing framework
- `test`: Dart testing package
- `integration_test`: (Optional) For real device/emulator integration tests

### Mocking
- `mocktail`: Mock generation for testing (used in all current tests)

### Helpers
- `test/helpers/mock_data.dart`: Factory methods for creating test data
- `test/helpers/matchers.dart`: Custom matchers for assertions
- `test/helpers/test_providers.dart`: Provider overrides for testing
- `test/helpers/pump_app.dart`: Widget test helpers

### Note on Integration Tests
The current integration test templates in `test/integration/` use `flutter_test` and can run without the `integration_test` package. They serve as documentation and examples of user flow testing patterns. For actual device/emulator integration tests, add the `integration_test` package to your `pubspec.yaml` and move tests to the `integration_test/` directory.

## Module Testing Checklist

For each module to be considered **properly tested**, verify:

- [ ] **Data Layer**
  - [ ] Repository implementation tests
  - [ ] Data source implementation tests
  - [ ] All methods covered
  - [ ] Success scenarios tested
  - [ ] Failure scenarios tested
  - [ ] Edge cases covered

- [ ] **Presentation Layer**
  - [ ] View model logic tests
  - [ ] State management tests
  - [ ] Business logic tests
  - [ ] Provider interaction tests

- [ ] **UI Layer**
  - [ ] Widget rendering tests
  - [ ] User interaction tests
  - [ ] Conditional rendering tests
  - [ ] Form validation tests

- [ ] **Integration**
  - [ ] Happy path flow test
  - [ ] Error handling flow test
  - [ ] At least one complete user journey

## Next Steps

### Immediate Priorities:

1. **Complete Data Layer Tests** for remaining modules:
   - [ ] Reports module
   - [ ] Dashboard module
   - [ ] Calculator module
   - [ ] Notification module

2. **Add View Model Tests** for existing modules:
   - [ ] Auth view model
   - [ ] Lead view model
   - [ ] Booking view model
   - [ ] Delivery view model

3. **Add Widget Tests** for key UI components:
   - [ ] Lead list item widgets
   - [ ] Form input widgets
   - [ ] Filter widgets
   - [ ] Dashboard widgets

4. **Create Integration Tests** for critical flows:
   - [ ] Authentication flow
   - [ ] Lead creation and management flow
   - [ ] Booking creation flow
   - [ ] Delivery tracking flow

### Long-term Goals:

- Achieve **80%+ code coverage** across all layers
- Automate test execution in CI/CD pipeline
- Add **golden tests** for UI consistency
- Implement **performance tests** for critical operations
- Add **accessibility tests** for all screens

## Resources

### Documentation
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mocktail Package](https://pub.dev/packages/mocktail)
- [Riverpod Testing](https://riverpod.dev/docs/cookbooks/testing)

### Test Patterns
- **AAA**: Arrange-Act-Assert
- **Given-When-Then**: BDD-style test structure
- **Test Doubles**: Mocks, Stubs, Fakes, Spies

## Conclusion

A module is considered **properly tested** when it has:
1. ✅ **Comprehensive unit tests** for all data and business logic
2. ✅ **Widget tests** for all UI components
3. ✅ **Integration tests** for critical user flows

**Current Status**: 244 data layer unit tests passing. Widget and integration tests are in template stage.

**Goal**: Build comprehensive test coverage across all three layers for all modules.
