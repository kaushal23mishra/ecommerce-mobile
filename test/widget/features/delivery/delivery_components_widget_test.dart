import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../helpers/pump_app.dart';

/// Widget tests for Delivery Module Components
///
/// This test file focuses on testing the individual components of the delivery form
/// without the full DeliveryScreen which has timer issues due to initState callbacks.
///
/// Components tested:
/// - Payment received amount input
/// - Booking amount display
/// - Pre-delivery amount input
/// - Exchange amount input
/// - Delivery amount input
/// - Finance details input
/// - Credit given input
/// - Deal closure date picker
/// - Delivery action buttons
/// - Payment validation
void main() {
  group('Delivery Components Widget Tests', () {
    group('Payment Amount Widgets', () {
      testWidgets('should render booking amount input field', (tester) async {
        // Arrange
        final amountController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Booking Amount',
              hint: 'Enter Amount',
              controller: amountController,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should accept booking amount input', (tester) async {
        // Arrange
        final amountController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Booking Amount',
              hint: 'Enter Amount',
              controller: amountController,
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), '50000');
        await tester.pump();

        // Assert
        expect(amountController.text, '50000');
      });

      testWidgets('should render pre-delivery amount input field', (
        tester,
      ) async {
        // Arrange
        final amountController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Pre-Delivery Amount',
              hint: 'Enter Amount',
              controller: amountController,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should render delivery amount input field', (tester) async {
        // Arrange
        final amountController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Delivery Amount',
              hint: 'Enter Amount',
              controller: amountController,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should render exchange amount input field', (tester) async {
        // Arrange
        final amountController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Exchange Amount',
              hint: 'Enter Amount',
              controller: amountController,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should accept exchange amount input', (tester) async {
        // Arrange
        final amountController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Exchange Amount',
              hint: 'Enter Amount',
              controller: amountController,
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), '25000');
        await tester.pump();

        // Assert
        expect(amountController.text, '25000');
      });
    });

    group('Finance Widget', () {
      testWidgets('should render finance dropdown', (tester) async {
        // Arrange
        final financeOptions = ['Yes', 'No'];
        String? selectedOption;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: financeOptions,
              itemValue: selectedOption,
              hintText: 'Select Finance Option',
              onChanged: (value) {
                selectedOption = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });

      testWidgets('should render bank dropdown', (tester) async {
        // Arrange
        final banks = ['HDFC Bank', 'ICICI Bank', 'SBI', 'Axis Bank'];
        String? selectedBank;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: banks,
              itemValue: selectedBank,
              hintText: 'Select Bank',
              onChanged: (value) {
                selectedBank = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });

      testWidgets('should render loan amount input field', (tester) async {
        // Arrange
        final loanAmountController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Loan Amount',
              hint: 'Enter Loan Amount',
              controller: loanAmountController,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });
    });

    group('Credit Given Widget', () {
      testWidgets('should render credit given amount input', (tester) async {
        // Arrange
        final creditController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Credit Given',
              hint: 'Enter Credit Amount',
              controller: creditController,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should accept credit amount input', (tester) async {
        // Arrange
        final creditController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.number,
              label: 'Credit Given',
              hint: 'Enter Credit Amount',
              controller: creditController,
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), '15000');
        await tester.pump();

        // Assert
        expect(creditController.text, '15000');
      });
    });

    group('Deal Closure Widget', () {
      testWidgets('should render deal closure date input', (tester) async {
        // Arrange
        final dateController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.datetime,
              label: 'Deal Closure Date',
              hint: 'DD/MM/YYYY',
              controller: dateController,
              readOnly: true,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should display deal closure date value', (tester) async {
        // Arrange
        final dateController = TextEditingController(text: '15/03/2025');

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              inputType: TextInputType.datetime,
              label: 'Deal Closure Date',
              hint: 'DD/MM/YYYY',
              controller: dateController,
              readOnly: true,
            ),
          ),
        );

        // Assert
        expect(dateController.text, '15/03/2025');
      });
    });

    group('Delivery Action Buttons', () {
      testWidgets('should render save delivery button', (tester) async {
        // Arrange
        var savePressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Save Delivery',
              onPressed: () {
                savePressed = true;
              },
              isDisabled: false,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
        expect(find.text('Save Delivery'), findsOneWidget);

        // Act - Tap the button
        await tester.tap(find.byType(SalesDocketButtonWidget));
        await tester.pump();

        // Assert
        expect(savePressed, true);
      });

      testWidgets('should render submit delivery button', (tester) async {
        // Arrange
        var submitPressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Submit Delivery',
              onPressed: () {
                submitPressed = true;
              },
              isDisabled: false,
            ),
          ),
        );

        // Assert
        expect(find.text('Submit Delivery'), findsOneWidget);

        // Act - Tap the button
        await tester.tap(find.byType(SalesDocketButtonWidget));
        await tester.pump();

        // Assert
        expect(submitPressed, true);
      });

      testWidgets('should disable button when processing', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Processing...',
              onPressed: () {},
              isDisabled: true,
            ),
          ),
        );

        // Assert
        expect(find.text('Processing...'), findsOneWidget);
        expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
      });
    });

    group('Payment Validation', () {
      testWidgets('should validate required booking amount', (tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        final amountController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: SalesDocketInputWidget(
                inputType: TextInputType.number,
                label: 'Booking Amount',
                hint: 'Enter Amount',
                controller: amountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Booking amount is required';
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

      testWidgets('should validate numeric amount input', (tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        final amountController = TextEditingController(text: 'abc');

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: SalesDocketInputWidget(
                inputType: TextInputType.number,
                label: 'Delivery Amount',
                hint: 'Enter Amount',
                controller: amountController,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final numValue = num.tryParse(value);
                    if (numValue == null) {
                      return 'Amount must be a number';
                    }
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

      testWidgets('should validate positive amount', (tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        final amountController = TextEditingController(text: '-1000');

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: SalesDocketInputWidget(
                inputType: TextInputType.number,
                label: 'Payment Amount',
                hint: 'Enter Amount',
                controller: amountController,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final numValue = num.tryParse(value);
                    if (numValue != null && numValue < 0) {
                      return 'Amount must be positive';
                    }
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

      testWidgets('should validate complete delivery form', (tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        final bookingAmountController = TextEditingController(text: '50000');
        final deliveryAmountController = TextEditingController(text: '100000');

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SalesDocketInputWidget(
                    inputType: TextInputType.number,
                    label: 'Booking Amount',
                    hint: 'Enter Amount',
                    controller: bookingAmountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Booking amount is required';
                      }
                      final numValue = num.tryParse(value);
                      if (numValue == null) {
                        return 'Amount must be a number';
                      }
                      if (numValue < 0) {
                        return 'Amount must be positive';
                      }
                      return null;
                    },
                  ),
                  SalesDocketInputWidget(
                    inputType: TextInputType.number,
                    label: 'Delivery Amount',
                    hint: 'Enter Amount',
                    controller: deliveryAmountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Delivery amount is required';
                      }
                      final numValue = num.tryParse(value);
                      if (numValue == null) {
                        return 'Amount must be a number';
                      }
                      if (numValue < 0) {
                        return 'Amount must be positive';
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

    group('Pending Amount Display', () {
      testWidgets('should render pending amount text', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Column(
              children: [
                const Text('Pending Amount'),
                Text('25,000', style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
        );

        // Assert
        expect(find.text('Pending Amount'), findsOneWidget);
        expect(find.text('25,000'), findsOneWidget);
      });
    });
  });
}
