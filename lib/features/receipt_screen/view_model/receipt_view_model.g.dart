// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deliveryLeadPendingReasonsHash() =>
    r'3e16bf2689f0ccc49760dd9660b138ced7c53cd8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [deliveryLeadPendingReasons].
@ProviderFor(deliveryLeadPendingReasons)
const deliveryLeadPendingReasonsProvider = DeliveryLeadPendingReasonsFamily();

/// See also [deliveryLeadPendingReasons].
class DeliveryLeadPendingReasonsFamily
    extends Family<AsyncValue<DeliveryLeadPendingData>> {
  /// See also [deliveryLeadPendingReasons].
  const DeliveryLeadPendingReasonsFamily();

  /// See also [deliveryLeadPendingReasons].
  DeliveryLeadPendingReasonsProvider call(int leadId) {
    return DeliveryLeadPendingReasonsProvider(leadId);
  }

  @override
  DeliveryLeadPendingReasonsProvider getProviderOverride(
    covariant DeliveryLeadPendingReasonsProvider provider,
  ) {
    return call(provider.leadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deliveryLeadPendingReasonsProvider';
}

/// See also [deliveryLeadPendingReasons].
class DeliveryLeadPendingReasonsProvider
    extends AutoDisposeFutureProvider<DeliveryLeadPendingData> {
  /// See also [deliveryLeadPendingReasons].
  DeliveryLeadPendingReasonsProvider(int leadId)
    : this._internal(
        (ref) => deliveryLeadPendingReasons(
          ref as DeliveryLeadPendingReasonsRef,
          leadId,
        ),
        from: deliveryLeadPendingReasonsProvider,
        name: r'deliveryLeadPendingReasonsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$deliveryLeadPendingReasonsHash,
        dependencies: DeliveryLeadPendingReasonsFamily._dependencies,
        allTransitiveDependencies:
            DeliveryLeadPendingReasonsFamily._allTransitiveDependencies,
        leadId: leadId,
      );

  DeliveryLeadPendingReasonsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leadId,
  }) : super.internal();

  final int leadId;

  @override
  Override overrideWith(
    FutureOr<DeliveryLeadPendingData> Function(
      DeliveryLeadPendingReasonsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeliveryLeadPendingReasonsProvider._internal(
        (ref) => create(ref as DeliveryLeadPendingReasonsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leadId: leadId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DeliveryLeadPendingData> createElement() {
    return _DeliveryLeadPendingReasonsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeliveryLeadPendingReasonsProvider &&
        other.leadId == leadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeliveryLeadPendingReasonsRef
    on AutoDisposeFutureProviderRef<DeliveryLeadPendingData> {
  /// The parameter `leadId` of this provider.
  int get leadId;
}

class _DeliveryLeadPendingReasonsProviderElement
    extends AutoDisposeFutureProviderElement<DeliveryLeadPendingData>
    with DeliveryLeadPendingReasonsRef {
  _DeliveryLeadPendingReasonsProviderElement(super.provider);

  @override
  int get leadId => (origin as DeliveryLeadPendingReasonsProvider).leadId;
}

String _$deliveryLeadPendingDisplayReasonsHash() =>
    r'f7a2d4a05db5e28da49c966802e84a765c4c98fc';

/// See also [deliveryLeadPendingDisplayReasons].
@ProviderFor(deliveryLeadPendingDisplayReasons)
const deliveryLeadPendingDisplayReasonsProvider =
    DeliveryLeadPendingDisplayReasonsFamily();

/// See also [deliveryLeadPendingDisplayReasons].
class DeliveryLeadPendingDisplayReasonsFamily
    extends Family<AsyncValue<List<ReceiptReason>>> {
  /// See also [deliveryLeadPendingDisplayReasons].
  const DeliveryLeadPendingDisplayReasonsFamily();

  /// See also [deliveryLeadPendingDisplayReasons].
  DeliveryLeadPendingDisplayReasonsProvider call(int leadId) {
    return DeliveryLeadPendingDisplayReasonsProvider(leadId);
  }

  @override
  DeliveryLeadPendingDisplayReasonsProvider getProviderOverride(
    covariant DeliveryLeadPendingDisplayReasonsProvider provider,
  ) {
    return call(provider.leadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deliveryLeadPendingDisplayReasonsProvider';
}

/// See also [deliveryLeadPendingDisplayReasons].
class DeliveryLeadPendingDisplayReasonsProvider
    extends AutoDisposeFutureProvider<List<ReceiptReason>> {
  /// See also [deliveryLeadPendingDisplayReasons].
  DeliveryLeadPendingDisplayReasonsProvider(int leadId)
    : this._internal(
        (ref) => deliveryLeadPendingDisplayReasons(
          ref as DeliveryLeadPendingDisplayReasonsRef,
          leadId,
        ),
        from: deliveryLeadPendingDisplayReasonsProvider,
        name: r'deliveryLeadPendingDisplayReasonsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$deliveryLeadPendingDisplayReasonsHash,
        dependencies: DeliveryLeadPendingDisplayReasonsFamily._dependencies,
        allTransitiveDependencies:
            DeliveryLeadPendingDisplayReasonsFamily._allTransitiveDependencies,
        leadId: leadId,
      );

  DeliveryLeadPendingDisplayReasonsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leadId,
  }) : super.internal();

  final int leadId;

  @override
  Override overrideWith(
    FutureOr<List<ReceiptReason>> Function(
      DeliveryLeadPendingDisplayReasonsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeliveryLeadPendingDisplayReasonsProvider._internal(
        (ref) => create(ref as DeliveryLeadPendingDisplayReasonsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leadId: leadId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ReceiptReason>> createElement() {
    return _DeliveryLeadPendingDisplayReasonsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeliveryLeadPendingDisplayReasonsProvider &&
        other.leadId == leadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeliveryLeadPendingDisplayReasonsRef
    on AutoDisposeFutureProviderRef<List<ReceiptReason>> {
  /// The parameter `leadId` of this provider.
  int get leadId;
}

class _DeliveryLeadPendingDisplayReasonsProviderElement
    extends AutoDisposeFutureProviderElement<List<ReceiptReason>>
    with DeliveryLeadPendingDisplayReasonsRef {
  _DeliveryLeadPendingDisplayReasonsProviderElement(super.provider);

  @override
  int get leadId =>
      (origin as DeliveryLeadPendingDisplayReasonsProvider).leadId;
}

String _$deliveryLeadPaymentTypeOptionsHash() =>
    r'19423c4d241c2175fdb17717f56c3174ee9b0002';

/// See also [deliveryLeadPaymentTypeOptions].
@ProviderFor(deliveryLeadPaymentTypeOptions)
const deliveryLeadPaymentTypeOptionsProvider =
    DeliveryLeadPaymentTypeOptionsFamily();

/// See also [deliveryLeadPaymentTypeOptions].
class DeliveryLeadPaymentTypeOptionsFamily
    extends Family<AsyncValue<List<String>>> {
  /// See also [deliveryLeadPaymentTypeOptions].
  const DeliveryLeadPaymentTypeOptionsFamily();

  /// See also [deliveryLeadPaymentTypeOptions].
  DeliveryLeadPaymentTypeOptionsProvider call(int leadId) {
    return DeliveryLeadPaymentTypeOptionsProvider(leadId);
  }

  @override
  DeliveryLeadPaymentTypeOptionsProvider getProviderOverride(
    covariant DeliveryLeadPaymentTypeOptionsProvider provider,
  ) {
    return call(provider.leadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deliveryLeadPaymentTypeOptionsProvider';
}

/// See also [deliveryLeadPaymentTypeOptions].
class DeliveryLeadPaymentTypeOptionsProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [deliveryLeadPaymentTypeOptions].
  DeliveryLeadPaymentTypeOptionsProvider(int leadId)
    : this._internal(
        (ref) => deliveryLeadPaymentTypeOptions(
          ref as DeliveryLeadPaymentTypeOptionsRef,
          leadId,
        ),
        from: deliveryLeadPaymentTypeOptionsProvider,
        name: r'deliveryLeadPaymentTypeOptionsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$deliveryLeadPaymentTypeOptionsHash,
        dependencies: DeliveryLeadPaymentTypeOptionsFamily._dependencies,
        allTransitiveDependencies:
            DeliveryLeadPaymentTypeOptionsFamily._allTransitiveDependencies,
        leadId: leadId,
      );

  DeliveryLeadPaymentTypeOptionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leadId,
  }) : super.internal();

  final int leadId;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(DeliveryLeadPaymentTypeOptionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeliveryLeadPaymentTypeOptionsProvider._internal(
        (ref) => create(ref as DeliveryLeadPaymentTypeOptionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leadId: leadId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _DeliveryLeadPaymentTypeOptionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeliveryLeadPaymentTypeOptionsProvider &&
        other.leadId == leadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeliveryLeadPaymentTypeOptionsRef
    on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `leadId` of this provider.
  int get leadId;
}

class _DeliveryLeadPaymentTypeOptionsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with DeliveryLeadPaymentTypeOptionsRef {
  _DeliveryLeadPaymentTypeOptionsProviderElement(super.provider);

  @override
  int get leadId => (origin as DeliveryLeadPaymentTypeOptionsProvider).leadId;
}

String _$deliveryLeadHasPendingAmountHash() =>
    r'b54e7aac0363bca8671fd22703c0b876391d11fb';

/// See also [deliveryLeadHasPendingAmount].
@ProviderFor(deliveryLeadHasPendingAmount)
const deliveryLeadHasPendingAmountProvider =
    DeliveryLeadHasPendingAmountFamily();

/// See also [deliveryLeadHasPendingAmount].
class DeliveryLeadHasPendingAmountFamily extends Family<bool?> {
  /// See also [deliveryLeadHasPendingAmount].
  const DeliveryLeadHasPendingAmountFamily();

  /// See also [deliveryLeadHasPendingAmount].
  DeliveryLeadHasPendingAmountProvider call(int leadId) {
    return DeliveryLeadHasPendingAmountProvider(leadId);
  }

  @override
  DeliveryLeadHasPendingAmountProvider getProviderOverride(
    covariant DeliveryLeadHasPendingAmountProvider provider,
  ) {
    return call(provider.leadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deliveryLeadHasPendingAmountProvider';
}

/// See also [deliveryLeadHasPendingAmount].
class DeliveryLeadHasPendingAmountProvider extends AutoDisposeProvider<bool?> {
  /// See also [deliveryLeadHasPendingAmount].
  DeliveryLeadHasPendingAmountProvider(int leadId)
    : this._internal(
        (ref) => deliveryLeadHasPendingAmount(
          ref as DeliveryLeadHasPendingAmountRef,
          leadId,
        ),
        from: deliveryLeadHasPendingAmountProvider,
        name: r'deliveryLeadHasPendingAmountProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$deliveryLeadHasPendingAmountHash,
        dependencies: DeliveryLeadHasPendingAmountFamily._dependencies,
        allTransitiveDependencies:
            DeliveryLeadHasPendingAmountFamily._allTransitiveDependencies,
        leadId: leadId,
      );

  DeliveryLeadHasPendingAmountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leadId,
  }) : super.internal();

  final int leadId;

  @override
  Override overrideWith(
    bool? Function(DeliveryLeadHasPendingAmountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeliveryLeadHasPendingAmountProvider._internal(
        (ref) => create(ref as DeliveryLeadHasPendingAmountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leadId: leadId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool?> createElement() {
    return _DeliveryLeadHasPendingAmountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeliveryLeadHasPendingAmountProvider &&
        other.leadId == leadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeliveryLeadHasPendingAmountRef on AutoDisposeProviderRef<bool?> {
  /// The parameter `leadId` of this provider.
  int get leadId;
}

class _DeliveryLeadHasPendingAmountProviderElement
    extends AutoDisposeProviderElement<bool?>
    with DeliveryLeadHasPendingAmountRef {
  _DeliveryLeadHasPendingAmountProviderElement(super.provider);

  @override
  int get leadId => (origin as DeliveryLeadHasPendingAmountProvider).leadId;
}

String _$deliveryReceiptMenuVisibilityHash() =>
    r'4ebd2146c395eec74436d751ebe58ebfba0a08ac';

/// See also [deliveryReceiptMenuVisibility].
@ProviderFor(deliveryReceiptMenuVisibility)
const deliveryReceiptMenuVisibilityProvider =
    DeliveryReceiptMenuVisibilityFamily();

/// See also [deliveryReceiptMenuVisibility].
class DeliveryReceiptMenuVisibilityFamily
    extends Family<DeliveryReceiptMenuVisibility> {
  /// See also [deliveryReceiptMenuVisibility].
  const DeliveryReceiptMenuVisibilityFamily();

  /// See also [deliveryReceiptMenuVisibility].
  DeliveryReceiptMenuVisibilityProvider call(int leadId) {
    return DeliveryReceiptMenuVisibilityProvider(leadId);
  }

  @override
  DeliveryReceiptMenuVisibilityProvider getProviderOverride(
    covariant DeliveryReceiptMenuVisibilityProvider provider,
  ) {
    return call(provider.leadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deliveryReceiptMenuVisibilityProvider';
}

/// See also [deliveryReceiptMenuVisibility].
class DeliveryReceiptMenuVisibilityProvider
    extends AutoDisposeProvider<DeliveryReceiptMenuVisibility> {
  /// See also [deliveryReceiptMenuVisibility].
  DeliveryReceiptMenuVisibilityProvider(int leadId)
    : this._internal(
        (ref) => deliveryReceiptMenuVisibility(
          ref as DeliveryReceiptMenuVisibilityRef,
          leadId,
        ),
        from: deliveryReceiptMenuVisibilityProvider,
        name: r'deliveryReceiptMenuVisibilityProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$deliveryReceiptMenuVisibilityHash,
        dependencies: DeliveryReceiptMenuVisibilityFamily._dependencies,
        allTransitiveDependencies:
            DeliveryReceiptMenuVisibilityFamily._allTransitiveDependencies,
        leadId: leadId,
      );

  DeliveryReceiptMenuVisibilityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leadId,
  }) : super.internal();

  final int leadId;

  @override
  Override overrideWith(
    DeliveryReceiptMenuVisibility Function(
      DeliveryReceiptMenuVisibilityRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeliveryReceiptMenuVisibilityProvider._internal(
        (ref) => create(ref as DeliveryReceiptMenuVisibilityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leadId: leadId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<DeliveryReceiptMenuVisibility> createElement() {
    return _DeliveryReceiptMenuVisibilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeliveryReceiptMenuVisibilityProvider &&
        other.leadId == leadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeliveryReceiptMenuVisibilityRef
    on AutoDisposeProviderRef<DeliveryReceiptMenuVisibility> {
  /// The parameter `leadId` of this provider.
  int get leadId;
}

class _DeliveryReceiptMenuVisibilityProviderElement
    extends AutoDisposeProviderElement<DeliveryReceiptMenuVisibility>
    with DeliveryReceiptMenuVisibilityRef {
  _DeliveryReceiptMenuVisibilityProviderElement(super.provider);

  @override
  int get leadId => (origin as DeliveryReceiptMenuVisibilityProvider).leadId;
}

String _$receiptAmountCapHash() => r'73702cac5db353ad8fffb7dfe2c25af473992010';

/// See also [receiptAmountCap].
@ProviderFor(receiptAmountCap)
final receiptAmountCapProvider = AutoDisposeProvider<int>.internal(
  receiptAmountCap,
  name: r'receiptAmountCapProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$receiptAmountCapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReceiptAmountCapRef = AutoDisposeProviderRef<int>;
String _$receiptViewModelHash() => r'e5d7e764b0e55a6fec3db3454c87d38a9b33ec03';

/// See also [ReceiptViewModel].
@ProviderFor(ReceiptViewModel)
final receiptViewModelProvider =
    AutoDisposeAsyncNotifierProvider<ReceiptViewModel, void>.internal(
      ReceiptViewModel.new,
      name: r'receiptViewModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$receiptViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReceiptViewModel = AutoDisposeAsyncNotifier<void>;
String _$receiptLeadHash() => r'429a63ec6148213c0c7ede48c8ed324e7c8f4728';

/// See also [ReceiptLead].
@ProviderFor(ReceiptLead)
final receiptLeadProvider =
    AutoDisposeNotifierProvider<ReceiptLead, Lead?>.internal(
      ReceiptLead.new,
      name: r'receiptLeadProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$receiptLeadHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReceiptLead = AutoDisposeNotifier<Lead?>;
String _$receiptSourceHash() => r'260c3046b887041a9c90d69b8734d3e427eea598';

/// See also [ReceiptSource].
@ProviderFor(ReceiptSource)
final receiptSourceProvider =
    AutoDisposeNotifierProvider<ReceiptSource, ReceiptType>.internal(
      ReceiptSource.new,
      name: r'receiptSourceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$receiptSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReceiptSource = AutoDisposeNotifier<ReceiptType>;
String _$sendReceiptRequestHash() =>
    r'77651f3e9c7d5255f826f9bf33a258718dc37c55';

/// See also [SendReceiptRequest].
@ProviderFor(SendReceiptRequest)
final sendReceiptRequestProvider =
    AutoDisposeNotifierProvider<SendReceiptRequest, Receipt?>.internal(
      SendReceiptRequest.new,
      name: r'sendReceiptRequestProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sendReceiptRequestHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SendReceiptRequest = AutoDisposeNotifier<Receipt?>;
String _$receiptFormErrorsHash() => r'540e7e4fffdcf78ed9126ea95d9ade4359039ef5';

/// See also [ReceiptFormErrors].
@ProviderFor(ReceiptFormErrors)
final receiptFormErrorsProvider = AutoDisposeNotifierProvider<
  ReceiptFormErrors,
  List<FormFieldError>
>.internal(
  ReceiptFormErrors.new,
  name: r'receiptFormErrorsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$receiptFormErrorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReceiptFormErrors = AutoDisposeNotifier<List<FormFieldError>>;
String _$canEditReceiptHash() => r'5a850cb1dc4d4804579313f043de6ea694fe629a';

/// See also [CanEditReceipt].
@ProviderFor(CanEditReceipt)
final canEditReceiptProvider =
    AutoDisposeNotifierProvider<CanEditReceipt, bool>.internal(
      CanEditReceipt.new,
      name: r'canEditReceiptProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$canEditReceiptHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CanEditReceipt = AutoDisposeNotifier<bool>;
String _$receiptsHash() => r'e5bf75c5f44623fb5590354aa59318684bf630d4';

/// See also [Receipts].
@ProviderFor(Receipts)
final receiptsProvider =
    AutoDisposeNotifierProvider<Receipts, List<Receipt>>.internal(
      Receipts.new,
      name: r'receiptsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$receiptsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Receipts = AutoDisposeNotifier<List<Receipt>>;
String _$loadingReceiptsStateHash() =>
    r'93fb3efb2024c86d82b3ab729e33e2aa67b8a317';

/// See also [LoadingReceiptsState].
@ProviderFor(LoadingReceiptsState)
final loadingReceiptsStateProvider =
    AutoDisposeNotifierProvider<LoadingReceiptsState, bool>.internal(
      LoadingReceiptsState.new,
      name: r'loadingReceiptsStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$loadingReceiptsStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoadingReceiptsState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
