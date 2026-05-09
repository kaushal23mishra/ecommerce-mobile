import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Create a ProviderContainer for testing with optional overrides
ProviderContainer createContainer({
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(
    overrides: overrides,
    observers: observers,
  );

  // Automatically dispose container after test
  addTearDown(container.dispose);

  return container;
}

/// Mock ProviderObserver for testing provider behavior
class MockProviderObserver extends ProviderObserver {
  final List<ProviderListenable> providers = [];
  final List<Object?> values = [];
  final List<Object?> previousValues = [];

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    providers.add(provider);
    previousValues.add(previousValue);
    values.add(newValue);
  }

  void clear() {
    providers.clear();
    values.clear();
    previousValues.clear();
  }
}
