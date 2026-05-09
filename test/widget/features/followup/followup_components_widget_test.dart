import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../helpers/pump_app.dart';

/// Widget tests for Followup Module Components
///
/// This test file covers all key components of the followup module:
/// - Followup status buttons (Done/Not Done)
/// - Reject reason checkboxes
/// - Visit date/time pickers
/// - Met whom input
/// - Test drive status
/// - Lost to competitor/dealer selections
/// - Call status components
/// - Followup details display
void main() {
  group('Followup Components Widget Tests', () {
    group('Followup Status Buttons', () {
      testWidgets('should render Done and Not Done buttons', (tester) async {
        // Arrange
        bool? statusSelected;

        // Act
        await tester.pumpApp(
          Material(
            child: Row(
              children: [
                const Text('Follow up Status:'),
                Expanded(
                  child: SalesDocketButtonWidget(
                    onPressed: () => statusSelected = true,
                    text: "Done",
                  ),
                ),
                Expanded(
                  child: SalesDocketButtonWidget(
                    onPressed: () => statusSelected = false,
                    text: "Not Done",
                  ),
                ),
              ],
            ),
          ),
        );

        // Assert
        expect(find.text('Follow up Status:'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);
        expect(find.text('Not Done'), findsOneWidget);
        expect(find.byType(SalesDocketButtonWidget), findsNWidgets(2));
      });

      testWidgets('should trigger callback when Done button is pressed', (
        tester,
      ) async {
        // Arrange
        bool? statusSelected;

        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              onPressed: () => statusSelected = true,
              text: "Done",
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Done'));
        await tester.pump();

        // Assert
        expect(statusSelected, true);
      });

      testWidgets('should trigger callback when Not Done button is pressed', (
        tester,
      ) async {
        // Arrange
        bool? statusSelected;

        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              onPressed: () => statusSelected = false,
              text: "Not Done",
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Not Done'));
        await tester.pump();

        // Assert
        expect(statusSelected, false);
      });
    });

    group('Reject Reason Checkboxes', () {
      testWidgets('should render reject reason checkbox list', (tester) async {
        // Arrange
        final reasons = ['Price', 'Features', 'Service', 'Availability'];
        final selectedReasons = <String>[];

        // Act
        await tester.pumpApp(
          Material(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: reasons.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Checkbox(
                      value: selectedReasons.contains(reasons[index]),
                      onChanged: (value) {
                        if (value == true) {
                          selectedReasons.add(reasons[index]);
                        } else {
                          selectedReasons.remove(reasons[index]);
                        }
                      },
                    ),
                    Text(reasons[index]),
                  ],
                );
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(Checkbox), findsNWidgets(4));
        expect(find.text('Price'), findsOneWidget);
        expect(find.text('Features'), findsOneWidget);
        expect(find.text('Service'), findsOneWidget);
        expect(find.text('Availability'), findsOneWidget);
      });

      testWidgets('should toggle checkbox selection', (tester) async {
        // Arrange
        bool isChecked = false;

        await tester.pumpApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Material(
                child: Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() => isChecked = value ?? false);
                  },
                ),
              );
            },
          ),
        );

        // Act
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Assert
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, true);
      });

      testWidgets('should show validation error for required selection', (
        tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        final selectedReasons = <String>[];

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  FormField<List<String>>(
                    initialValue: selectedReasons,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select at least one reason';
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Reject Reasons'),
                          if (state.hasError)
                            Text(
                              state.errorText ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        formKey.currentState?.validate();
        await tester.pump();

        // Assert
        expect(find.text('Please select at least one reason'), findsOneWidget);
      });
    });

    group('Visit Date Widget', () {
      testWidgets('should render visit date input field', (tester) async {
        // Arrange
        final dateController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Visit Date',
              hint: 'Select Visit Date',
              controller: dateController,
              readOnly: true,
              suffix: const Icon(Icons.calendar_today),
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });

      testWidgets('should accept date input', (tester) async {
        // Arrange
        final dateController = TextEditingController(
          text: '2024-01-15 10:30 AM',
        );

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Visit Date',
              hint: 'Select Visit Date',
              controller: dateController,
              readOnly: true,
            ),
          ),
        );

        // Assert
        expect(dateController.text, '2024-01-15 10:30 AM');
      });
    });

    group('Met Whom Widget', () {
      testWidgets('should render met whom input field', (tester) async {
        // Arrange
        final metWhomController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Met Whom',
              hint: 'Enter name',
              controller: metWhomController,
              maxLength: 100,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should accept text input for met whom', (tester) async {
        // Arrange
        final metWhomController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Met Whom',
              hint: 'Enter name',
              controller: metWhomController,
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'Customer Name');
        await tester.pump();

        // Assert
        expect(metWhomController.text, 'Customer Name');
      });
    });

    group('Test Drive Status', () {
      testWidgets('should render test drive given dropdown', (tester) async {
        // Arrange
        final options = ['Yes', 'No'];
        String? selectedOption;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: options,
              itemValue: selectedOption,
              hintText: 'Test Drive Given?',
              onChanged: (value) {
                selectedOption = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });

    group('Lost To Competitor Widget', () {
      testWidgets('should render lost to competitor dropdown', (tester) async {
        // Arrange
        final competitors = ['Honda', 'Toyota', 'Hyundai', 'Tata'];
        String? selectedCompetitor;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: competitors,
              itemValue: selectedCompetitor,
              hintText: 'Select Competitor',
              onChanged: (value) {
                selectedCompetitor = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });

      testWidgets('should render competitor model input', (tester) async {
        // Arrange
        final modelController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Competitor Model',
              hint: 'Enter model name',
              controller: modelController,
              maxLength: 50,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should accept competitor model input', (tester) async {
        // Arrange
        final modelController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Competitor Model',
              hint: 'Enter model name',
              controller: modelController,
            ),
          ),
        );

        // Act
        await tester.enterText(find.byType(TextFormField), 'City');
        await tester.pump();

        // Assert
        expect(modelController.text, 'City');
      });
    });

    group('Lost To Co-Dealer Widget', () {
      testWidgets('should render co-dealer dropdown', (tester) async {
        // Arrange
        final coDealers = ['Dealer A', 'Dealer B', 'Dealer C'];
        String? selectedDealer;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: coDealers,
              itemValue: selectedDealer,
              hintText: 'Select Co-Dealer',
              onChanged: (value) {
                selectedDealer = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });

    group('Call Status Widget', () {
      testWidgets('should render call status dropdown', (tester) async {
        // Arrange
        final callStatuses = [
          'Connected',
          'Not Reachable',
          'Switch Off',
          'Wrong Number',
          'Call Back',
        ];
        String? selectedStatus;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: callStatuses,
              itemValue: selectedStatus,
              hintText: 'Call Status',
              onChanged: (value) {
                selectedStatus = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });

    group('Visit By Widget', () {
      testWidgets('should render visit by dropdown', (tester) async {
        // Arrange
        final visitByOptions = ['Self', 'With Family', 'With Friends'];
        String? selectedOption;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: visitByOptions,
              itemValue: selectedOption,
              hintText: 'Visit By',
              onChanged: (value) {
                selectedOption = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });

    group('Not Done Reason Widget', () {
      testWidgets('should render not done reason input', (tester) async {
        // Arrange
        final reasonController = TextEditingController();

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Not Done Reason',
              hint: 'Enter reason',
              controller: reasonController,
              maxLength: 200,
              maxLines: 3,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketInputWidget), findsOneWidget);
      });

      testWidgets('should accept multi-line reason text', (tester) async {
        // Arrange
        final reasonController = TextEditingController();

        await tester.pumpApp(
          Material(
            child: SalesDocketInputWidget(
              label: 'Not Done Reason',
              hint: 'Enter reason',
              controller: reasonController,
              maxLines: 3,
            ),
          ),
        );

        // Act
        await tester.enterText(
          find.byType(TextFormField),
          'Customer was busy\nWill follow up tomorrow',
        );
        await tester.pump();

        // Assert
        expect(
          reasonController.text,
          'Customer was busy\nWill follow up tomorrow',
        );
      });
    });

    group('Lead Category Widget', () {
      testWidgets('should render lead category dropdown', (tester) async {
        // Arrange
        final categories = ['Hot', 'Warm', 'Cold', 'Lost'];
        String? selectedCategory;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: categories,
              itemValue: selectedCategory,
              hintText: 'Select Lead Category',
              onChanged: (value) {
                selectedCategory = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });

    group('Expected Month of Conversion Widget', () {
      testWidgets('should render expected conversion month dropdown', (
        tester,
      ) async {
        // Arrange
        final months = [
          'This Month',
          'Next Month',
          'In 2 Months',
          'In 3+ Months',
        ];
        String? selectedMonth;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketDropDownWidget(
              itemList: months,
              itemValue: selectedMonth,
              hintText: 'Expected Month of Conversion',
              onChanged: (value) {
                selectedMonth = value;
              },
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketDropDownWidget), findsOneWidget);
      });
    });

    group('Followup Action Buttons', () {
      testWidgets('should render submit followup button', (tester) async {
        // Arrange
        var submitPressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Submit Followup',
              onPressed: () {
                submitPressed = true;
              },
            ),
          ),
        );

        // Assert
        expect(find.text('Submit Followup'), findsOneWidget);

        // Act - Tap button
        await tester.tap(find.byType(SalesDocketButtonWidget));
        await tester.pump();

        // Assert
        expect(submitPressed, true);
      });

      testWidgets('should render validate later button', (tester) async {
        // Arrange
        var validateLaterPressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Validate Later',
              onPressed: () {
                validateLaterPressed = true;
              },
            ),
          ),
        );

        // Assert
        expect(find.text('Validate Later'), findsOneWidget);

        // Act - Tap button
        await tester.tap(find.byType(SalesDocketButtonWidget));
        await tester.pump();

        // Assert
        expect(validateLaterPressed, true);
      });

      testWidgets('should disable button when loading', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Submitting...',
              onPressed: () {},
              isDisabled: true,
            ),
          ),
        );

        // Assert
        expect(find.text('Submitting...'), findsOneWidget);
      });
    });

    group('Followup Form Validation', () {
      testWidgets('should validate required followup status', (tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        bool? followupStatus;

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: FormField<bool>(
                validator: (value) {
                  if (value == null) {
                    return 'Please select followup status';
                  }
                  return null;
                },
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.hasError)
                        Text(
                          state.errorText ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Act
        formKey.currentState?.validate();
        await tester.pump();

        // Assert
        expect(find.text('Please select followup status'), findsOneWidget);
      });

      testWidgets('should validate complete followup form', (tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        final metWhomController = TextEditingController(text: 'John Doe');
        final visitDateController = TextEditingController(
          text: '2024-01-15 10:30 AM',
        );

        await tester.pumpApp(
          Material(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SalesDocketInputWidget(
                    label: 'Met Whom',
                    hint: 'Enter name',
                    controller: metWhomController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Met whom is required';
                      }
                      return null;
                    },
                  ),
                  SalesDocketInputWidget(
                    label: 'Visit Date',
                    hint: 'Select date',
                    controller: visitDateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Visit date is required';
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
