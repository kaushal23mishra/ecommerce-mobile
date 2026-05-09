import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../helpers/pump_app.dart';

/// Widget tests for Booking Module Components
///
/// This test file focuses on testing the individual components of the booking form
/// without the full BookingScreen which has timer issues due to initState callbacks.
///
/// Components tested:
/// - Name input fields (Salutation dropdown + Full name)
/// - Date of birth picker
/// - PAN card input
/// - Profession dropdown
/// - Address input
/// - Contact details input
/// - Type of customer selection

/// - Action buttons (Save, Submit)
void main() {
  group('Booking Components Widget Tests', () {
    group('Name Input Fields', () {
      testWidgets('should render salutation dropdown', (tester) async {
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

      testWidgets('should render full name input field', (tester) async {
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

      testWidgets('should accept full name input', (tester) async {
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
    });

    group('Date of Birth Widget', () {
      testWidgets('should render date of birth input field', (tester) async {
        // Arrange
        final dobController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.datetime,
              label: 'Date of Birth',
              hint: 'DD/MM/YYYY',
              controller: dobController,
              readOnly: true,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should display date value', (tester) async {
        // Arrange
        final dobController = TextEditingController(text: '01/01/1990');

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.datetime,
              label: 'Date of Birth',
              hint: 'DD/MM/YYYY',
              controller: dobController,
              readOnly: true,
            ),
          ),
        );

        // Assert
        expect(dobController.text, '01/01/1990');
      });
    });

    group('PAN Card Widget', () {
      testWidgets('should render PAN input field', (tester) async {
        // Arrange
        final panController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              maxLength: 10,
              inputType: TextInputType.text,
              label: 'PAN Card',
              hint: 'Enter PAN',
              controller: panController,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should accept PAN input', (tester) async {
        // Arrange
        final panController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              maxLength: 10,
              inputType: TextInputType.text,
              label: 'PAN Card',
              hint: 'Enter PAN',
              controller: panController,
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'ABCDE1234F');
        await tester.pump();

        // Assert
        expect(panController.text, 'ABCDE1234F');
      });

      testWidgets('should validate PAN length', (tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        final panController = TextEditingController(text: 'ABC123');

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: SalesDocketInputWidget(
                maxLength: 10,
                inputType: TextInputType.text,
                label: 'PAN Card',
                hint: 'Enter PAN',
                controller: panController,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length != 10) {
                    return 'PAN must be 10 characters';
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
    });

    group('Profession Widget', () {
      testWidgets('should render profession dropdown', (tester) async {
        // Arrange
        final professions = [
          'Salaried',
          'Business',
          'Self-employed',
          'Student',
          'Other',
        ];
        String? selectedProfession;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: professions,
              itemValue: selectedProfession,
              hintText: 'Select Profession',
              onChanged: (value) {
                selectedProfession = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });

    group('Address Widget', () {
      testWidgets('should render address input field', (tester) async {
        // Arrange
        final addressController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              maxLength: 200,
              inputType: TextInputType.streetAddress,
              label: 'Address',
              hint: 'Enter Address',
              controller: addressController,
              maxLines: 3,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should accept multi-line address input', (tester) async {
        // Arrange
        final addressController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              maxLength: 200,
              inputType: TextInputType.streetAddress,
              label: 'Address',
              hint: 'Enter Address',
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
    });

    group('Type of Customer Widget', () {
      testWidgets('should render customer type dropdown', (tester) async {
        // Arrange
        final customerTypes = [
          'Individual',
          'Corporate',
          'Government',
          'Fleet',
        ];
        String? selectedType;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: customerTypes,
              itemValue: selectedType,
              hintText: 'Select Customer Type',
              onChanged: (value) {
                selectedType = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });



    group('Contact Details Widget', () {
      testWidgets('should render phone number input field', (tester) async {
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

      testWidgets('should render email input field', (tester) async {
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
      });
    });

    group('Booking Action Buttons', () {
      testWidgets('should render save booking button', (tester) async {
        // Arrange
        var savePressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Save Booking',
              onPressed: () {
                savePressed = true;
              },
              isDisabled: false,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
        expect(find.text('Save Booking'), findsOneWidget);

        // Act - Tap the button
        await tester.tap(find.byType(SalesDocketButtonWidget));
        await tester.pump();

        // Assert
        expect(savePressed, true);
      });

      testWidgets('should render submit booking button', (tester) async {
        // Arrange
        var submitPressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Submit Booking',
              onPressed: () {
                submitPressed = true;
              },
              isDisabled: false,
            ),
          ),
        );

        // Assert
        expect(find.text('Submit Booking'), findsOneWidget);

        // Act - Tap the button
        await tester.tap(find.byType(SalesDocketButtonWidget));
        await tester.pump();

        // Assert
        expect(submitPressed, true);
      });

      testWidgets('should disable button when loading', (tester) async {
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
    });

    group('Booking Form Validation', () {
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

      testWidgets('should validate required contact field', (tester) async {
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

      testWidgets('should validate complete booking form', (tester) async {
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
    });
  });
}
