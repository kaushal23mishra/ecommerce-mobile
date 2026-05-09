// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followup_history_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leadHistoryHash() => r'ba793e4f0013f3e32fae9aae91368c14aca9b181';

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

/// See also [leadHistory].
@ProviderFor(leadHistory)
const leadHistoryProvider = LeadHistoryFamily();

/// See also [leadHistory].
class LeadHistoryFamily
    extends
        Family<
          AsyncValue<Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>>
        > {
  /// See also [leadHistory].
  const LeadHistoryFamily();

  /// See also [leadHistory].
  LeadHistoryProvider call({required int leadId, int page = 1}) {
    return LeadHistoryProvider(leadId: leadId, page: page);
  }

  @override
  LeadHistoryProvider getProviderOverride(
    covariant LeadHistoryProvider provider,
  ) {
    return call(leadId: provider.leadId, page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'leadHistoryProvider';
}

/// See also [leadHistory].
class LeadHistoryProvider
    extends
        AutoDisposeFutureProvider<
          Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>
        > {
  /// See also [leadHistory].
  LeadHistoryProvider({required int leadId, int page = 1})
    : this._internal(
        (ref) => leadHistory(ref as LeadHistoryRef, leadId: leadId, page: page),
        from: leadHistoryProvider,
        name: r'leadHistoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$leadHistoryHash,
        dependencies: LeadHistoryFamily._dependencies,
        allTransitiveDependencies: LeadHistoryFamily._allTransitiveDependencies,
        leadId: leadId,
        page: page,
      );

  LeadHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leadId,
    required this.page,
  }) : super.internal();

  final int leadId;
  final int page;

  @override
  Override overrideWith(
    FutureOr<Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>> Function(
      LeadHistoryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LeadHistoryProvider._internal(
        (ref) => create(ref as LeadHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leadId: leadId,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>
  >
  createElement() {
    return _LeadHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LeadHistoryProvider &&
        other.leadId == leadId &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leadId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LeadHistoryRef
    on
        AutoDisposeFutureProviderRef<
          Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>
        > {
  /// The parameter `leadId` of this provider.
  int get leadId;

  /// The parameter `page` of this provider.
  int get page;
}

class _LeadHistoryProviderElement
    extends
        AutoDisposeFutureProviderElement<
          Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>
        >
    with LeadHistoryRef {
  _LeadHistoryProviderElement(super.provider);

  @override
  int get leadId => (origin as LeadHistoryProvider).leadId;
  @override
  int get page => (origin as LeadHistoryProvider).page;
}

String _$followupHistoryViewModelHash() =>
    r'76e6af2f2f7ee8d1e7f5737fb1ba21e383c9f2a0';

/// See also [FollowupHistoryViewModel].
@ProviderFor(FollowupHistoryViewModel)
final followupHistoryViewModelProvider =
    AutoDisposeAsyncNotifierProvider<FollowupHistoryViewModel, void>.internal(
      FollowupHistoryViewModel.new,
      name: r'followupHistoryViewModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$followupHistoryViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FollowupHistoryViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
