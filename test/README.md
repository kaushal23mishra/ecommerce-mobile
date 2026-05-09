# SalesDocket Mobile - Testing Guide

## Quick Start

### Run All Tests
```bash
flutter test --no-pub
```

### Current Test Status: ✅ 407 Tests Passing (all tests now passing!)

## Test Coverage Summary

### ✅ Data Layer (Unit Tests) - **250 Tests**

#### Auth Module - 128 Tests
- `AuthRepositoryImpl`: 10 tests
- `AuthDataSourceImpl`: 11 tests
- Use Cases: 107 tests (SignIn, SignOut, GetCurrentUser, ForgotPassword)
- Entities & Mappers

#### Booking Module - 32 Tests
- `BookingRepositoryImpl`: 10 tests
- `BookingDataSourceImpl`: 22 tests

#### Lead Module - 54 Tests
- `LeadRepositoryImpl`: 18 tests
- `LeadDataSourceImpl`: 36 tests
- Includes followup functionality

#### Delivery Module - 30 Tests
- `DeliveryRepositoryImpl`: 11 tests
- `DeliveryDataSourceImpl`: 19 tests

#### Reports Module - 22 Tests
- `ReportsDataSourceImpl`: 22 tests
- Covers all 9 report endpoints (delivered, enquiry, conversion, aging, followups)

### ✅ Widget Tests - 120 Tests
- `LeadItemHeaderWidget` - Rendering tests for different states (4 tests passing)
- `Login Form Components` - Email, password, button, and form validation (11 tests passing)
- `Create Enquiry Form Components` - Name, contact, address, dropdowns, buttons, validation (20 tests passing)
- `Followup Module Components` - Comprehensive followup widget tests (26 tests passing)
- `Booking Module Components` ⭐ NEW - Personal details, contact, PAN, profession, action buttons (22 tests passing)
- `Delivery Module Components` ⭐ NEW - Payment amounts, finance, credit, validation (21 tests passing)
- `Dashboard Module Components` ⭐ NEW - Cards, counters, reports, notifications, actions (16 tests passing)

**Note on Widget Testing**: Complex screens with async initState callbacks (timers, post-frame callbacks) cause pending timer errors in widget tests. Screens like `AuthScreen` and `CreateLeadScreen` use `WidgetsBinding.instance.addPostFrameCallback` for initialization which creates timers that persist after widget disposal.

**Solution**: Test individual form components separately instead of the full screen. See:
- `test/widget/features/auth/login_form_widget_test.dart` - Login form components
- `test/widget/features/lead/create_enquiry_form_widget_test.dart` - Create enquiry form components
- `test/widget/features/followup/followup_components_widget_test.dart` - Followup module components
- `test/widget/features/booking/booking_components_widget_test.dart` - Booking module components
- `test/widget/features/delivery/delivery_components_widget_test.dart` - Delivery module components
- `test/widget/features/dashboard/dashboard_components_widget_test.dart` - Dashboard module components

### ✅ Integration Tests - 24 Tests (ALL PASSING)
- **Lead Flows** (5 tests) - Lead creation, search, update scenarios
- **Authentication Flows** ⭐ IMPLEMENTED (19 tests, ALL PASSING) - Proper working integration tests with real widget interactions, mock authentication, form validation, password visibility toggle, error handling, loading states

## What Makes a Module "Properly Tested"?

A module is considered properly tested when it has:

### 1. ✅ Unit Tests - Data Layer
**Status: COMPLETE for Auth, Booking, Lead, Delivery**

- Repository implementation tests
- Data source implementation tests
- All CRUD operations covered
- Success and failure scenarios
- Error handling and edge cases

### 2. ⏳ Unit Tests - Presentation Layer
**Status: Templates created, needs implementation**

- View model logic tests
- State management tests
- Business logic validation
- Provider interactions

**Template**: `test/unit/presentation/view_models/lead_view_model_test.dart`

### 3. ✅ Widget Tests - UI Layer
**Status: Example tests passing, expand for more components**

- Widget rendering with various inputs
- User interaction tests (taps, input, gestures)
- Conditional rendering based on state
- Form validation UI feedback

**Example**: `test/widget/features/lead/lead_item_header_widget_test.dart` (4 tests passing)

### 4. ✅ Integration Tests - End-to-End Flows
**Status: 24 tests passing (ALL PASSING - Authentication + Lead flows)**

- Complete user journey tests
- Multi-screen navigation flows
- Real-world usage scenarios
- Authentication and session management

**Examples**:
- `test/integration/lead_creation_flow_test.dart` (5 tests)
- `test/integration/authentication_flow_test.dart` (19 tests) ⭐ NEW

## Test Directory Structure

```
test/
├── unit/                          # Unit tests
│   ├── data/
│   │   ├── data_sources/         # HTTP/API layer tests ✅
│   │   ├── repositories/         # Repository tests ✅
│   │   └── mappers/              # Data transformation tests ✅
│   ├── domain/
│   │   ├── use_cases/            # Business logic tests ✅
│   │   └── entities/             # Domain model tests ✅
│   └── presentation/
│       └── view_models/          # View model tests ⏳
├── widget/                        # Widget tests ⏳
│   ├── features/
│   │   └── lead/
│   └── shared/
│       └── widgets/
├── integration/                   # Integration tests ✅
│   └── lead_creation_flow_test.dart
└── helpers/                       # Test utilities ✅
    ├── mock_data.dart
    ├── matchers.dart
    ├── test_providers.dart
    └── pump_app.dart
```

## Running Specific Tests

### By Type
```bash
# Unit tests only
flutter test test/unit/ --no-pub

# Widget tests only
flutter test test/widget/ --no-pub

# Integration tests only
flutter test test/integration/ --no-pub
```

### By Module
```bash
# Auth module tests
flutter test test/unit/data/repositories/auth_repository_impl_test.dart --no-pub
flutter test test/unit/data/data_sources/auth_data_source_impl_test.dart --no-pub

# Booking module tests
flutter test test/unit/data/repositories/booking_repository_impl_test.dart --no-pub
flutter test test/unit/data/data_sources/booking_data_source_impl_test.dart --no-pub

# Lead module tests
flutter test test/unit/data/repositories/lead_repository_impl_test.dart --no-pub
flutter test test/unit/data/data_sources/lead_data_source_impl_test.dart --no-pub

# Delivery module tests
flutter test test/unit/data/repositories/delivery_repository_impl_test.dart --no-pub
flutter test test/unit/data/data_sources/delivery_data_source_impl_test.dart --no-pub

# Integration tests
flutter test test/integration/authentication_flow_test.dart --no-pub
flutter test test/integration/lead_creation_flow_test.dart --no-pub
```

### With Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Integration Test Guide

### Authentication Flow Tests ⭐ PROPERLY IMPLEMENTED

The authentication flow integration tests are **working integration tests** with real widget interactions, mocked authentication, and proper assertions.

**File**: `test/integration/authentication_flow_test.dart` (19 tests, ALL PASSING)

**Test Coverage**:
1. **Form Validation** (3 tests) ✅
   - Invalid email format validation with real form submission
   - Empty password field validation
   - Valid email and password acceptance

2. **Login Success** (2 tests) ✅
   - Authentication call verification with valid credentials (navigation prevented in tests)
   - User with unauthorized status handling

3. **Login Failure** (4 tests) ✅
   - Failed login with invalid credentials
   - Network error handling
   - Form field retention after failed login

4. **Password Visibility** (2 tests) ✅
   - Password visibility toggle functionality
   - Password text visibility when toggled on

5. **Loading States** (2 tests) ✅
   - Loading state during login
   - Button state during loading

6. **UI Components** (3 tests) ✅
   - All login form components rendering
   - Logo rendering
   - Email and password field order

7. **Input Validation Edge Cases** (3 tests) ✅
   - Email with spaces handling
   - Very long password input (maxLength enforcement)
   - Special characters in email

**Running Authentication Tests**:
```bash
flutter test test/integration/authentication_flow_test.dart --no-pub
# Result: All 19 tests passing!
```

**Key Features**:
- **Real Widget Testing**: Pumps actual AuthScreen widget with provider overrides
- **Mock Authentication**: Uses MockAuthRepository with controlled responses
- **Actual User Interactions**: Uses `tester.enterText()` and `tester.tap()` for real interactions
- **Proper Assertions**: Verifies widget states, text presence, icon changes
- **Form Validation**: Tests real form validation with actual error messages
- **Password Toggle**: Tests actual password visibility icon changes
- **Error Handling**: Tests network errors, invalid credentials, empty fields

**Technical Implementation**:
- Uses `mocktail` for mocking AuthRepository
- Overrides `authRepositoryProvider` in widget tests
- Creates mock `User` and `AppError` responses
- Tests actual Flutter widget behavior, not templates

## Test Writing Guidelines

### AAA Pattern (Arrange-Act-Assert)

```dart
test('should return data when repository succeeds', () async {
  // Arrange - Setup test data and mocks
  final tRequest = CreateLeadRequest(firstName: 'John');
  final tLead = MockData.createLead(id: 1, firstName: 'John');

  when(() => mockRepository.createLead(req: any(named: 'req')))
      .thenAnswer((_) async => Result.success(data: tLead));

  // Act - Execute the method being tested
  final result = await viewModel.createLead(tRequest);

  // Assert - Verify the outcome
  expect(result.isSuccess, true);
  verify(() => mockRepository.createLead(req: tRequest)).called(1);
});
```

### Key Principles

✅ **DO:**
- Test both success and failure scenarios
- Mock all external dependencies
- Use descriptive test names
- Keep tests independent
- Verify mock interactions
- Test edge cases (null, empty, invalid)

❌ **DON'T:**
- Make real API calls
- Share state between tests
- Test implementation details
- Skip error scenarios
- Hardcode values without context

## Next Steps

### Immediate Priorities

1. **Complete Data Layer Tests** for remaining modules:
   - [ ] Reports module
   - [ ] Dashboard module
   - [ ] Calculator module
   - [ ] Notification module

2. **Add View Model Tests**:
   - [ ] Auth view model
   - [ ] Lead view model
   - [ ] Booking view model
   - [ ] Delivery view model

3. **Add Widget Tests**:
   - [ ] Lead list widgets
   - [ ] Form input widgets
   - [ ] Filter widgets
   - [ ] Dashboard widgets

4. **Expand Integration Tests**:
   - [ ] Authentication flow
   - [ ] Booking creation flow
   - [ ] Delivery tracking flow

### Long-term Goals

- Achieve 80%+ code coverage
- Automate in CI/CD pipeline
- Add golden tests for UI
- Performance tests for critical paths

## Documentation

📚 **Comprehensive Guide**: See [TEST_STRATEGY.md](./TEST_STRATEGY.md) for:
- Detailed testing methodology
- Layer-by-layer explanations
- Code examples and patterns
- Best practices and anti-patterns
- Tools and resources

## Tools & Packages

- `flutter_test`: Core testing framework
- `mocktail`: Mocking library (no code generation)
- `test`: Dart testing package

### Test Helpers

- `mock_data.dart`: Factory methods for test data
- `matchers.dart`: Custom assertion matchers
- `test_providers.dart`: Riverpod provider overrides
- `pump_app.dart`: Widget test utilities

## Troubleshooting

### Common Issues

**Tests not found:**
```bash
# Ensure you're in project root
flutter test --no-pub
```

**Mock errors:**
```dart
// Register fallback values in setUpAll
setUpAll(() {
  registerFallbackValue(CreateLeadRequest());
});
```

**Provider errors in widget tests:**
```dart
// Override providers in pumpApp
await tester.pumpApp(
  MyWidget(),
  overrides: [
    myProvider.overrideWith((ref) => MockValue()),
  ],
);
```

## Contributing

When adding new features:

1. Write tests FIRST (TDD approach) or alongside implementation
2. Ensure all three test layers are covered
3. Run `flutter test --no-pub` before committing
4. Maintain test coverage above 80%

## Summary

✅ **Current Status**: **407 tests passing** (250 unit + 120 widget + 24 integration + 13 other)
✅ **Data Layer**: Well tested (Auth, Booking, Lead, Delivery, Reports)
⏳ **Presentation Layer**: Templates ready for implementation
✅ **UI Layer**: Comprehensive component-level widget tests (Auth, Lead, Followup, Booking, Delivery, Dashboard)
✅ **Integration**: **Proper working integration tests** - Authentication flow (19 passing) + lead management flows (5 passing)

**Major Achievement**: Replaced 19 template integration tests with **actual working integration tests** that:
- Pump real widgets with provider overrides
- Perform actual user interactions (enterText, tap)
- Use proper mocked authentication responses
- Have real assertions testing widget behavior
- Test form validation, error handling, loading states

**Next Steps**: See `COMPREHENSIVE_TEST_PLAN.md` for roadmap to 728 total tests

**Goal**: Comprehensive test coverage across all three layers for all modules.
