// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_lead_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUsers3Hash() => r'5875901db7d64e7c9743cdad7c00461a04684acb';

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

/// See also [getUsers3].
@ProviderFor(getUsers3)
const getUsers3Provider = GetUsers3Family();

/// See also [getUsers3].
class GetUsers3Family
    extends Family<AsyncValue<Result<ApiResponse<List<User>?>?>>> {
  /// See also [getUsers3].
  const GetUsers3Family();

  /// See also [getUsers3].
  GetUsers3Provider call({int page = 1}) {
    return GetUsers3Provider(page: page);
  }

  @override
  GetUsers3Provider getProviderOverride(covariant GetUsers3Provider provider) {
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
  String? get name => r'getUsers3Provider';
}

/// See also [getUsers3].
class GetUsers3Provider
    extends AutoDisposeFutureProvider<Result<ApiResponse<List<User>?>?>> {
  /// See also [getUsers3].
  GetUsers3Provider({int page = 1})
    : this._internal(
        (ref) => getUsers3(ref as GetUsers3Ref, page: page),
        from: getUsers3Provider,
        name: r'getUsers3Provider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$getUsers3Hash,
        dependencies: GetUsers3Family._dependencies,
        allTransitiveDependencies: GetUsers3Family._allTransitiveDependencies,
        page: page,
      );

  GetUsers3Provider._internal(
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
    FutureOr<Result<ApiResponse<List<User>?>?>> Function(GetUsers3Ref provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUsers3Provider._internal(
        (ref) => create(ref as GetUsers3Ref),
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
  AutoDisposeFutureProviderElement<Result<ApiResponse<List<User>?>?>>
  createElement() {
    return _GetUsers3ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUsers3Provider && other.page == page;
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
mixin GetUsers3Ref
    on AutoDisposeFutureProviderRef<Result<ApiResponse<List<User>?>?>> {
  /// The parameter `page` of this provider.
  int get page;
}

class _GetUsers3ProviderElement
    extends AutoDisposeFutureProviderElement<Result<ApiResponse<List<User>?>?>>
    with GetUsers3Ref {
  _GetUsers3ProviderElement(super.provider);

  @override
  int get page => (origin as GetUsers3Provider).page;
}

String _$transferLeadViewModelHash() =>
    r'273230506adbd2cb736b42965841178b6a7bf8cc';

/// See also [TransferLeadViewModel].
@ProviderFor(TransferLeadViewModel)
final transferLeadViewModelProvider =
    AutoDisposeAsyncNotifierProvider<TransferLeadViewModel, void>.internal(
      TransferLeadViewModel.new,
      name: r'transferLeadViewModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$transferLeadViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TransferLeadViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
