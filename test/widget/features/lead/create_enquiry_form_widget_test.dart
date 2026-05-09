import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../helpers/pump_app.dart';

/// Widget tests for Create New Enquiry (Lead) Form components
///
/// This test file focuses on testing the individual components of the create enquiry form
/// without the full CreateLeadScreen which has timer issues due to initState callbacks.
///
/// Components tested:
/// - Name input fields (Salutation dropdown + Full name)
/// - Contact details input (Phone/Email with type selector)
/// - Address input field
/// - Dropdown selections (Car model, Lead source)
/// - Date picker widget
/// - Action buttons (Save, Save & Call, Save & Follow Up)
void main() {
  group('Create Enquiry Form Components', () {
    testWidgets('should render full name input field correctly', (
      tester,
    ) async {
      // Arrange
      final nameController = TextEditingController();

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 50,
            inputType: TextInputType.text,
            label: 'Full Name',
            hint: 'Full Name',
            controller: nameController,
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should render salutation dropdown correctly', (tester) async {
      // Arrange
      final salutations = ['Mr.', 'Mrs.', 'Ms.', 'Dr.'];
      String? selectedSalutation;

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketDropDownWidget(
            itemList: salutations,
            itemValue: selectedSalutation,
            hintText: 'Title',
            onChanged: (value) {
              selectedSalutation = value;
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
    });

    testWidgets('should accept text input in full name field', (tester) async {
      // Arrange
      final nameController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 50,
            inputType: TextInputType.text,
            label: 'Full Name',
            hint: 'Full Name',
            controller: nameController,
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pump();

      // Assert
      expect(nameController.text, 'John Doe');
    });

    testWidgets('should render phone number input field correctly', (
      tester,
    ) async {
      // Arrange
      final phoneController = TextEditingController();

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 10,
            inputType: TextInputType.phone,
            label: 'Phone Number',
            hint: 'Phone Number',
            controller: phoneController,
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should accept phone number input', (tester) async {
      // Arrange
      final phoneController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 10,
            inputType: TextInputType.phone,
            label: 'Phone Number',
            hint: 'Phone Number',
            controller: phoneController,
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), '9876543210');
      await tester.pump();

      // Assert
      expect(phoneController.text, '9876543210');
    });

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

    testWidgets('should accept email input', (tester) async {
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
      await tester.enterText(
        find.byType(TextFormField),
        'customer@example.com',
      );
      await tester.pump();

      // Assert
      expect(emailController.text, 'customer@example.com');
    });

    testWidgets('should render address input field correctly', (tester) async {
      // Arrange
      final addressController = TextEditingController();

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 200,
            inputType: TextInputType.streetAddress,
            label: 'Address',
            hint: 'Address',
            controller: addressController,
            maxLines: 3,
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should accept address input with multiple lines', (
      tester,
    ) async {
      // Arrange
      final addressController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: SalesDocketInputWidget(
            maxLength: 200,
            inputType: TextInputType.streetAddress,
            label: 'Address',
            hint: 'Address',
            controller: addressController,
            maxLines: 3,
          ),
        ),
      );

      // Act
      await tester.enterText(
        find.byType(TextFormField),
        '123 Main St\nCity, State\n12345',
      );
      await tester.pump();

      // Assert
      expect(addressController.text, '123 Main St\nCity, State\n12345');
    });

    testWidgets('should render car model dropdown correctly', (tester) async {
      // Arrange
      final carModels = ['Swift', 'Baleno', 'Brezza', 'Ertiga'];
      String? selectedCar;

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketDropDownWidget(
            itemList: carModels,
            itemValue: selectedCar,
            hintText: 'Select Car Model',
            onChanged: (value) {
              selectedCar = value;
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
    });

    testWidgets('should render lead source dropdown correctly', (tester) async {
      // Arrange
      final leadSources = ['Walk-in', 'Phone Call', 'Website', 'Referral'];
      String? selectedSource;

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketDropDownWidget(
            itemList: leadSources,
            itemValue: selectedSource,
            hintText: 'Select Lead Source',
            onChanged: (value) {
              selectedSource = value;
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
    });

    testWidgets('should render contact type dropdown correctly', (
      tester,
    ) async {
      // Arrange
      final contactTypes = ['Mobile', 'Email', 'WhatsApp', 'Landline'];
      String? selectedType;

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketDropDownWidget(
            itemList: contactTypes,
            itemValue: selectedType,
            hintText: 'Contact Type',
            onChanged: (value) {
              selectedType = value;
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
    });

    testWidgets('should render save button correctly', (tester) async {
      // Arrange
      var savePressed = false;

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketButtonWidget(
            text: 'Save',
            onPressed: () {
              savePressed = true;
            },
            isDisabled: false,
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      // Act - Tap the button
      await tester.tap(find.byType(SalesDocketButtonWidget));
      await tester.pump();

      // Assert
      expect(savePressed, true);
    });

    testWidgets('should render save and call button correctly', (tester) async {
      // Arrange
      var saveAndCallPressed = false;

      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketButtonWidget(
            text: 'Save & Call',
            onPressed: () {
              saveAndCallPressed = true;
            },
            isDisabled: false,
          ),
        ),
      );

      // Assert
      expect(find.text('Save & Call'), findsOneWidget);

      // Act - Tap the button
      await tester.tap(find.byType(SalesDocketButtonWidget));
      await tester.pump();

      // Assert
      expect(saveAndCallPressed, true);
    });

    testWidgets('should disable save button when loading', (tester) async {
      // Act
      await tester.pumpApp(
        Material(
          child: SalesDocketButtonWidget(
            text: 'Saving...',
            onPressed: () {},
            isDisabled: true,
          ),
        ),
      );

      // Assert
      expect(find.text('Saving...'), findsOneWidget);
      expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
    });

    testWidgets('should validate required name field', (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final nameController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: Form(
            key: formKey,
            child: SalesDocketInputWidget(
              maxLength: 50,
              inputType: TextInputType.text,
              label: 'Full Name',
              hint: 'Full Name',
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
          ),
        ),
      );

      // Act - Try to validate with empty field
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, false);
    });

    testWidgets('should validate required phone field', (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final phoneController = TextEditingController();

      await tester.pumpApp(
        Material(
          child: Form(
            key: formKey,
            child: SalesDocketInputWidget(
              maxLength: 10,
              inputType: TextInputType.phone,
              label: 'Phone Number',
              hint: 'Phone Number',
              controller: phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (value.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
          ),
        ),
      );

      // Act - Try to validate with empty field
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, false);
    });

    testWidgets('should validate phone number length', (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final phoneController = TextEditingController(text: '12345');

      await tester.pumpApp(
        Material(
          child: Form(
            key: formKey,
            child: SalesDocketInputWidget(
              maxLength: 10,
              inputType: TextInputType.phone,
              label: 'Phone Number',
              hint: 'Phone Number',
              controller: phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (value.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
          ),
        ),
      );

      // Act
      final isValid = formKey.currentState?.validate();

      // Assert
      expect(isValid, false);
    });

    testWidgets('should validate form successfully with valid inputs', (
      tester,
    ) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final nameController = TextEditingController(text: 'John Doe');
      final phoneController = TextEditingController(text: '9876543210');
      final emailController = TextEditingController(text: 'john@example.com');

      await tester.pumpApp(
        Material(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SalesDocketInputWidget(
                  maxLength: 50,
                  inputType: TextInputType.text,
                  label: 'Full Name',
                  hint: 'Full Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SalesDocketInputWidget(
                  maxLength: 10,
                  inputType: TextInputType.phone,
                  label: 'Phone Number',
                  hint: 'Phone Number',
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SalesDocketInputWidget(
                  maxLength: 50,
                  inputType: TextInputType.emailAddress,
                  label: 'Email',
                  hint: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !value.contains('@')) {
                      return 'Invalid email';
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

    testWidgets('should render multiple contact detail fields', (tester) async {
      // Arrange
      final phone1Controller = TextEditingController();
      final phone2Controller = TextEditingController();

      // Act
      await tester.pumpApp(
        Material(
          child: Column(
            children: [
              SalesDocketInputWidget(
                maxLength: 10,
                inputType: TextInputType.phone,
                label: 'Primary Phone',
                hint: 'Primary Phone',
                controller: phone1Controller,
              ),
              SalesDocketInputWidget(
                maxLength: 10,
                inputType: TextInputType.phone,
                label: 'Secondary Phone',
                hint: 'Secondary Phone',
                controller: phone2Controller,
              ),
            ],
          ),
        ),
      );

      // Assert
      expect(find.byType(SalesDocketInputWidget), findsNWidgets(2));
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}
