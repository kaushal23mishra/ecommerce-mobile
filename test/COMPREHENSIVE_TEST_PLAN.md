# Comprehensive Test Coverage Plan

## Current Status: 264 Tests Passing

### ✅ Fully Tested Modules (228 Unit + 35 Widget + 5 Integration)

#### Data Layer - Unit Tests (228 tests)
- ✅ **Auth Module** (128 tests)
  - AuthRepositoryImpl: 10 tests
  - AuthDataSourceImpl: 11 tests
  - Use Cases: 107 tests
- ✅ **Booking Module** (32 tests)
  - BookingRepositoryImpl: 10 tests
  - BookingDataSourceImpl: 22 tests
- ✅ **Lead Module** (54 tests)
  - LeadRepositoryImpl: 18 tests
  - LeadDataSourceImpl: 36 tests
- ✅ **Delivery Module** (30 tests)
  - DeliveryRepositoryImpl: 11 tests
  - DeliveryDataSourceImpl: 19 tests
- ✅ **Mappers** (14 tests)
  - User entity mapper tests

#### Widget Tests (35 tests)
- ✅ LeadItemHeaderWidget (4 tests)
- ✅ Login Form Components (11 tests)
- ✅ Create Enquiry Form Components (20 tests)

#### Integration Tests (5 tests)
- ✅ Lead creation flow templates
- ✅ Lead search flow templates
- ✅ Lead update flow templates

---

## 🎯 Priority 1: Critical Business Logic (Data Layer)

### Untested Data Sources & Repositories

#### 1. Reports Module
**Priority**: HIGH - Business analytics and reporting
**Location**: `libraries/salesdocket_core/lib/src/data_source/reports/`
**Tests Needed**:
- ReportsDataSourceImpl: 15-20 tests
  - Dashboard statistics API calls
  - Sales reports generation
  - Lead conversion analytics
  - Performance metrics
- ReportsRepositoryImpl: 8-10 tests
  - Report data transformation
  - Error handling for missing data
  - Date range filtering

#### 2. Quotation Module
**Priority**: HIGH - Sales workflow
**Location**: `libraries/salesdocket_core/lib/src/data_source/quotation/`
**Tests Needed**:
- QuotationDataSourceImpl: 18-22 tests
  - Create quotation
  - Update quotation
  - Get quotation details
  - List quotations with filters
  - Delete/archive quotation
- QuotationRepositoryImpl: 10-12 tests
  - Quotation business logic
  - Price calculations
  - Discount validations

#### 3. Receipts Module
**Priority**: HIGH - Financial transactions
**Location**: `libraries/salesdocket_core/lib/src/data_source/receipts/`
**Tests Needed**:
- ReceiptsDataSourceImpl: 15-18 tests
  - Create receipt
  - Update receipt
  - Get receipt details
  - Payment method validation
- ReceiptsRepositoryImpl: 8-10 tests
  - Receipt number generation
  - Amount calculations
  - Payment tracking

#### 4. Product Module
**Priority**: HIGH - Inventory management
**Location**: `libraries/salesdocket_core/lib/src/data_source/product/`
**Tests Needed**:
- ProductDataSourceImpl: 12-15 tests
  - Get product list
  - Get product details
  - Product search
  - Product availability
- ProductRepositoryImpl: 6-8 tests
  - Product filtering
  - Stock management

#### 5. Locality Module
**Priority**: MEDIUM - Address management
**Location**: `libraries/salesdocket_core/lib/src/data_source/locality/`
**Tests Needed**:
- LocalityDataSourceImpl: 10-12 tests
  - Get cities
  - Get locations/areas
  - Search localities
- LocalityRepositoryImpl: 5-6 tests
  - Location filtering
  - Address validation

#### 6. User Module
**Priority**: MEDIUM - Team management
**Location**: `libraries/salesdocket_core/lib/src/data_source/user/`
**Tests Needed**:
- UserDataSourceImpl: 12-15 tests
  - Get user list
  - Get user details
  - User search
  - User role management
- UserRepositoryImpl: 6-8 tests
  - User filtering
  - Permission checks

#### 7. Notification Module
**Priority**: MEDIUM - Communication
**Location**: `libraries/salesdocket_core/lib/src/data_source/notification/`
**Tests Needed**:
- NotificationDataSourceImpl: 10-12 tests
  - Get notifications
  - Mark as read
  - Delete notifications
  - Push notification handling
- NotificationRepositoryImpl: 5-6 tests
  - Notification filtering
  - Unread count tracking

#### 8. Document Module
**Priority**: MEDIUM - File management
**Location**: `libraries/salesdocket_core/lib/src/data_source/document/`
**Tests Needed**:
- DocumentDataSourceImpl: 12-15 tests
  - Upload document
  - Download document
  - Delete document
  - Get document list
- DocumentRepositoryImpl: 6-8 tests
  - File validation
  - Document type handling

#### 9. Discount Module
**Priority**: MEDIUM - Pricing logic
**Location**: `libraries/salesdocket_core/lib/src/data_source/discount/`
**Tests Needed**:
- DiscountDataSourceImpl: 10-12 tests
  - Get discount approvals
  - Request discount
  - Approve/reject discount
- DiscountRepositoryImpl: 5-6 tests
  - Discount calculation
  - Approval workflow

#### 10. Workflow Module
**Priority**: LOW - Process management
**Location**: `libraries/salesdocket_core/lib/src/data_source/workflow/`
**Tests Needed**:
- WorkflowDataSourceImpl: 8-10 tests
  - Get workflow steps
  - Update workflow status
- WorkflowRepositoryImpl: 4-5 tests
  - Status transitions

#### 11. App Module
**Priority**: LOW - App configuration
**Location**: `libraries/salesdocket_core/lib/src/data_source/app/`
**Tests Needed**:
- AppDataSourceImpl: 6-8 tests
  - Get app config
  - Version check
  - Feature flags
- AppRepositoryImpl: 3-4 tests
  - Config parsing

---

## 🎯 Priority 2: Presentation Layer (View Models)

### View Models Need Testing

#### Critical View Models
1. **LeadViewModel** - Lead management logic
2. **BookingViewModel** - Booking workflow
3. **DeliveryViewModel** - Delivery tracking
4. **AuthViewModel** - Authentication state
5. **DashboardViewModel** - Dashboard data aggregation
6. **QuotationViewModel** - Quotation calculations
7. **ReceiptViewModel** - Receipt generation
8. **ReportsViewModel** - Analytics processing

**Template**: `test/unit/presentation/view_models/[module]_view_model_test.dart`

**Tests per ViewModel**: 15-25 tests
- State initialization
- Loading states
- Success scenarios
- Error handling
- Business logic validation
- Provider interactions

---

## 🎯 Priority 3: Widget Tests (UI Layer)

### Additional Widget Tests Needed

#### Form Widgets
- ✅ Login form components (11 tests) - DONE
- ✅ Create enquiry form components (20 tests) - DONE
- ⏳ Booking form components (15-20 tests)
- ⏳ Delivery form components (12-15 tests)
- ⏳ Receipt form components (10-12 tests)
- ⏳ Quotation form components (12-15 tests)

#### List/Display Widgets
- ✅ LeadItemHeaderWidget (4 tests) - DONE
- ⏳ BookingListItemWidget (8-10 tests)
- ⏳ DeliveryListItemWidget (8-10 tests)
- ⏳ NotificationItemWidget (6-8 tests)
- ⏳ ProductListItemWidget (6-8 tests)

#### Common Widgets
- ⏳ AppBarWidget (5-6 tests)
- ⏳ LoadingOverlay (3-4 tests)
- ⏳ EmptyStateWidget (3-4 tests)
- ⏳ ErrorWidget (4-5 tests)

---

## 🎯 Priority 4: Integration Tests

### E2E Flow Tests Needed

#### Critical User Journeys
1. **Complete Lead to Booking Flow** (10-15 tests)
   - Create lead → Add followup → Create quotation → Convert to booking
2. **Booking to Delivery Flow** (8-10 tests)
   - Create booking → Update payment → Schedule delivery → Complete delivery
3. **Authentication Flow** (5-6 tests)
   - Login → Navigate → Logout → Session handling
4. **Search and Filter Flow** (6-8 tests)
   - Search leads → Apply filters → View details → Update
5. **Notification Flow** (4-5 tests)
   - Receive notification → Navigate → Mark read → Handle actions

---

## 📊 Estimated Test Count After Full Implementation

| Layer | Current | Priority 1 | Priority 2 | Priority 3 | Priority 4 | Total |
|-------|---------|------------|------------|------------|------------|-------|
| **Unit Tests (Data)** | 228 | +160 | - | - | - | 388 |
| **Unit Tests (Presentation)** | 0 | - | +160 | - | - | 160 |
| **Widget Tests** | 35 | - | - | +100 | - | 135 |
| **Integration Tests** | 5 | - | - | - | +40 | 45 |
| **TOTAL** | 264 | +160 | +160 | +100 | +40 | **728** |

---

## 🚀 Implementation Strategy

### Phase 1: Data Layer Completion (2-3 days)
**Goal**: 388 unit tests for data layer
1. Reports module (25-30 tests)
2. Quotation module (28-34 tests)
3. Receipts module (23-28 tests)
4. Product module (18-23 tests)
5. Remaining modules (66-75 tests)

### Phase 2: Presentation Layer (2-3 days)
**Goal**: 160 view model tests
1. Critical view models (LeadViewModel, BookingViewModel, etc.)
2. State management testing
3. Business logic validation

### Phase 3: Widget Layer Expansion (1-2 days)
**Goal**: 135 widget tests total
1. Additional form components
2. List item widgets
3. Common/shared widgets

### Phase 4: Integration Testing (1-2 days)
**Goal**: 45 integration tests
1. Complete user journeys
2. Multi-screen flows
3. State persistence tests

---

## 📝 Test Writing Guidelines

### For Each Module:

1. **Data Source Tests**:
   - HTTP request validation (endpoint, method, headers)
   - Request body/query parameters
   - Response parsing
   - Error handling (network, timeout, 4xx, 5xx)

2. **Repository Tests**:
   - Data transformation
   - Business logic
   - Error propagation
   - Edge cases (null, empty, invalid)

3. **View Model Tests**:
   - State initialization
   - Loading/success/error states
   - Provider interactions
   - Business logic validation

4. **Widget Tests**:
   - Render verification
   - User interactions
   - State changes
   - Validation feedback

5. **Integration Tests**:
   - Complete user flows
   - Multi-screen navigation
   - State persistence
   - Real-world scenarios

---

## 🎯 Success Criteria

- ✅ 80%+ code coverage
- ✅ All critical paths tested
- ✅ No skipped or disabled tests
- ✅ All tests passing in CI/CD
- ✅ Fast test execution (<5 minutes for full suite)
- ✅ Maintainable and well-documented tests

---

## 📚 Next Steps

1. Review this plan with the team
2. Prioritize modules based on business criticality
3. Assign test implementation to developers
4. Set up code coverage tracking
5. Integrate tests into CI/CD pipeline
6. Establish test writing standards
7. Create test review checklist

---

**Last Updated**: 2025-10-03
**Status**: Plan Ready for Implementation
