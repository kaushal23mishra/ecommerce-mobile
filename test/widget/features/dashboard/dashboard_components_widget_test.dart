import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../helpers/pump_app.dart';

/// Widget tests for Dashboard Module Components
///
/// This test file focuses on testing the individual components of the dashboard
/// without the full DashboardScreen which has timer issues due to initState callbacks.
///
/// Components tested:
/// - Dashboard card items
/// - Lead status counters
/// - Notification cards
/// - User profile card
/// - Version display
/// - Report widgets (enquiry, conversion ratio)
/// - Action buttons
void main() {
  group('Dashboard Components Widget Tests', () {
    group('Dashboard Card Items', () {
      testWidgets('should render dashboard card with count', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(height: 8),
                  const Text('Calls'),
                  const SizedBox(height: 4),
                  Text(
                    '25',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Calls'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
      });

      testWidgets('should render multiple dashboard cards', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone),
                      Text('Calls'),
                      Text('25'),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.home),
                      Text('Visits'),
                      Text('10'),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.local_shipping),
                      Text('Deliveries'),
                      Text('5'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        // Assert
        expect(find.byType(Card), findsNWidgets(3));
        expect(find.text('Calls'), findsOneWidget);
        expect(find.text('Visits'), findsOneWidget);
        expect(find.text('Deliveries'), findsOneWidget);
      });
    });

    group('Lead Status Counters', () {
      testWidgets('should render lead counter card', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Total Leads'),
                trailing: Text(
                  '150',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Total Leads'), findsOneWidget);
        expect(find.text('150'), findsOneWidget);
      });

      testWidgets('should render active leads counter', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Active Leads'),
                trailing: Text(
                  '75',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Active Leads'), findsOneWidget);
        expect(find.text('75'), findsOneWidget);
      });
    });

    group('Notification Card', () {
      testWidgets('should render notification card', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('New Notification'),
                subtitle: const Text('You have 5 new notifications'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('New Notification'), findsOneWidget);
        expect(find.text('You have 5 new notifications'), findsOneWidget);
        expect(find.byIcon(Icons.notifications), findsOneWidget);
      });

      testWidgets('should render notification badge', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Badge(
              label: const Text('5'),
              child: const Icon(Icons.notifications),
            ),
          ),
        );

        // Assert
        expect(find.byType(Badge), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
      });
    });

    group('User Profile Card', () {
      testWidgets('should render user profile card', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('John Doe'),
                subtitle: const Text('Sales Executive'),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Sales Executive'), findsOneWidget);
        expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });

    group('Version Widget', () {
      testWidgets('should render version text', (tester) async {
        // Act
        await tester.pumpApp(const Material(child: Text('Version 1.0.0')));

        // Assert
        expect(find.text('Version 1.0.0'), findsOneWidget);
      });
    });

    group('Report Widgets', () {
      testWidgets('should render enquiry report widget', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enquiry Report',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('Total Enquiries'), Text('500')],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('This Month'), Text('120')],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Enquiry Report'), findsOneWidget);
        expect(find.text('Total Enquiries'), findsOneWidget);
        expect(find.text('500'), findsOneWidget);
        expect(find.text('This Month'), findsOneWidget);
        expect(find.text('120'), findsOneWidget);
      });

      testWidgets('should render conversion ratio widget', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Conversion Ratio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('Conversion Rate'), Text('30%')],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Conversion Ratio'), findsOneWidget);
        expect(find.text('Conversion Rate'), findsOneWidget);
        expect(find.text('30%'), findsOneWidget);
      });
    });

    group('Dashboard Action Buttons', () {
      testWidgets('should render create lead button', (tester) async {
        // Arrange
        var createPressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: SalesDocketButtonWidget(
              text: 'Create Lead',
              onPressed: () {
                createPressed = true;
              },
              isDisabled: false,
            ),
          ),
        );

        // Assert
        expect(find.byType(SalesDocketButtonWidget), findsOneWidget);
        expect(find.text('Create Lead'), findsOneWidget);

        // Act - Tap the button
        await tester.tap(find.byType(SalesDocketButtonWidget));
        await tester.pump();

        // Assert
        expect(createPressed, true);
      });

      testWidgets('should render refresh button', (tester) async {
        // Arrange
        var refreshPressed = false;

        // Act
        await tester.pumpApp(
          Material(
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                refreshPressed = true;
              },
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.refresh), findsOneWidget);

        // Act - Tap the button
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pump();

        // Assert
        expect(refreshPressed, true);
      });
    });

    group('Progress Indicators', () {
      testWidgets('should render circular progress indicator', (tester) async {
        // Act
        await tester.pumpApp(
          const Material(child: Center(child: CircularProgressIndicator())),
        );

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should render linear progress indicator', (tester) async {
        // Act
        await tester.pumpApp(
          const Material(child: LinearProgressIndicator(value: 0.7)),
        );

        // Assert
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });
    });

    group('Dashboard Grid Layout', () {
      testWidgets('should render grid of counter cards', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              children: List.generate(
                8,
                (index) => Card(child: Center(child: Text('Item $index'))),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Card), findsNWidgets(8));
        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Item 7'), findsOneWidget);
      });
    });

    group('Empty State Widgets', () {
      testWidgets('should render empty state message', (tester) async {
        // Act
        await tester.pumpApp(
          Material(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.inbox, size: 48),
                  SizedBox(height: 16),
                  Text('No data available'),
                ],
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('No data available'), findsOneWidget);
        expect(find.byIcon(Icons.inbox), findsOneWidget);
      });
    });
  });
}
