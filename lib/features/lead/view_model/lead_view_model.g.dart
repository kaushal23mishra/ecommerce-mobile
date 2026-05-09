// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leadsHash() => r'130d2c5b9096ed05951b067d705c77a700f1593c';

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

/// See also [leads].
@ProviderFor(leads)
const leadsProvider = LeadsFamily();

/// See also [leads].
class LeadsFamily
    extends Family<AsyncValue<Result<ApiResponse<ApiResponse<List<Lead>?>?>>>> {
  /// See also [leads].
  const LeadsFamily();

  /// See also [leads].
  LeadsProvider call({int page = 1}) {
    return LeadsProvider(page: page);
  }

  @override
  LeadsProvider getProviderOverride(covariant LeadsProvider provider) {
    return call(page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'leadsProvider';
}

/// See also [leads].
class LeadsProvider
    extends
        AutoDisposeFutureProvider<
          Result<ApiResponse<ApiResponse<List<Lead>?>?>>
        > {
  /// See also [leads].
  LeadsProvider({int page = 1})
    : this._internal(
        (ref) => leads(ref as LeadsRef, page: page),
        from: leadsProvider,
        name: r'leadsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$leadsHash,
        dependencies: LeadsFamily._dependencies,
        allTransitiveDependencies: LeadsFamily._allTransitiveDependencies,
        page: page,
      );

  LeadsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
  }) : super.internal();

  final int page;

  @override
  Override overrideWith(
    FutureOr<Result<ApiResponse<ApiResponse<List<Lead>?>?>>> Function(
      LeadsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LeadsProvider._internal(
        (ref) => create(ref as LeadsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    Result<ApiResponse<ApiResponse<List<Lead>?>?>>
  >
  createElement() {
    return _LeadsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LeadsProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LeadsRef
    on
        AutoDisposeFutureProviderRef<
          Result<ApiResponse<ApiResponse<List<Lead>?>?>>
        > {
  /// The parameter `page` of this provider.
  int get page;
}

class _LeadsProviderElement
    extends
        AutoDisposeFutureProviderElement<
          Result<ApiResponse<ApiResponse<List<Lead>?>?>>
        >
    with LeadsRef {
  _LeadsProviderElement(super.provider);

  @override
  int get page => (origin as LeadsProvider).page;
}

String _$leadViewModelHash() => r'fc568df25194e09e1e834ca358308e5aff9bcdb7';

/// See also [LeadViewModel].
@ProviderFor(LeadViewModel)
final leadViewModelProvider =
    AutoDisposeAsyncNotifierProvider<LeadViewModel, void>.internal(
      LeadViewModel.new,
      name: r'leadViewModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$leadViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LeadViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
