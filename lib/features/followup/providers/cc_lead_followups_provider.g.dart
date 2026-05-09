// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cc_lead_followups_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cCLeadFollowupsHash() => r'0018459addba4faccfb1c8b9f1755ce80a8be45b';

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

abstract class _$CCLeadFollowups
    extends BuildlessAutoDisposeAsyncNotifier<List<CCLeadFollowup>> {
  late final int ccLeadId;

  FutureOr<List<CCLeadFollowup>> build(int ccLeadId);
}

/// Provider for fetching CC lead followup history
/// Returns the 4 latest followups for the given CC lead ID
/// (1 current + 3 past followups to display)
///
/// Copied from [CCLeadFollowups].
@ProviderFor(CCLeadFollowups)
const cCLeadFollowupsProvider = CCLeadFollowupsFamily();

/// Provider for fetching CC lead followup history
/// Returns the 4 latest followups for the given CC lead ID
/// (1 current + 3 past followups to display)
///
/// Copied from [CCLeadFollowups].
class CCLeadFollowupsFamily extends Family<AsyncValue<List<CCLeadFollowup>>> {
  /// Provider for fetching CC lead followup history
  /// Returns the 4 latest followups for the given CC lead ID
  /// (1 current + 3 past followups to display)
  ///
  /// Copied from [CCLeadFollowups].
  const CCLeadFollowupsFamily();

  /// Provider for fetching CC lead followup history
  /// Returns the 4 latest followups for the given CC lead ID
  /// (1 current + 3 past followups to display)
  ///
  /// Copied from [CCLeadFollowups].
  CCLeadFollowupsProvider call(int ccLeadId) {
    return CCLeadFollowupsProvider(ccLeadId);
  }

  @override
  CCLeadFollowupsProvider getProviderOverride(
    covariant CCLeadFollowupsProvider provider,
  ) {
    return call(provider.ccLeadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cCLeadFollowupsProvider';
}

/// Provider for fetching CC lead followup history
/// Returns the 4 latest followups for the given CC lead ID
/// (1 current + 3 past followups to display)
///
/// Copied from [CCLeadFollowups].
class CCLeadFollowupsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CCLeadFollowups,
          List<CCLeadFollowup>
        > {
  /// Provider for fetching CC lead followup history
  /// Returns the 4 latest followups for the given CC lead ID
  /// (1 current + 3 past followups to display)
  ///
  /// Copied from [CCLeadFollowups].
  CCLeadFollowupsProvider(int ccLeadId)
    : this._internal(
        () => CCLeadFollowups()..ccLeadId = ccLeadId,
        from: cCLeadFollowupsProvider,
        name: r'cCLeadFollowupsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$cCLeadFollowupsHash,
        dependencies: CCLeadFollowupsFamily._dependencies,
        allTransitiveDependencies:
            CCLeadFollowupsFamily._allTransitiveDependencies,
        ccLeadId: ccLeadId,
      );

  CCLeadFollowupsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ccLeadId,
  }) : super.internal();

  final int ccLeadId;

  @override
  FutureOr<List<CCLeadFollowup>> runNotifierBuild(
    covariant CCLeadFollowups notifier,
  ) {
    return notifier.build(ccLeadId);
  }

  @override
  Override overrideWith(CCLeadFollowups Function() create) {
    return ProviderOverride(
      origin: this,
      override: CCLeadFollowupsProvider._internal(
        () => create()..ccLeadId = ccLeadId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ccLeadId: ccLeadId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CCLeadFollowups, List<CCLeadFollowup>>
  createElement() {
    return _CCLeadFollowupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CCLeadFollowupsProvider && other.ccLeadId == ccLeadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ccLeadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CCLeadFollowupsRef
    on AutoDisposeAsyncNotifierProviderRef<List<CCLeadFollowup>> {
  /// The parameter `ccLeadId` of this provider.
  int get ccLeadId;
}

class _CCLeadFollowupsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CCLeadFollowups,
          List<CCLeadFollowup>
        >
    with CCLeadFollowupsRef {
  _CCLeadFollowupsProviderElement(super.provider);

  @override
  int get ccLeadId => (origin as CCLeadFollowupsProvider).ccLeadId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
