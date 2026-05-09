// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsHash() => r'd7d8716a82bd49874cecd0d70d5dc81f1886293b';

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

/// See also [notifications].
@ProviderFor(notifications)
const notificationsProvider = NotificationsFamily();

/// See also [notifications].
class NotificationsFamily
    extends
        Family<
          AsyncValue<
            Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>
          >
        > {
  /// See also [notifications].
  const NotificationsFamily();

  /// See also [notifications].
  NotificationsProvider call({int page = 1, GetNotificationRequest? req}) {
    return NotificationsProvider(page: page, req: req);
  }

  @override
  NotificationsProvider getProviderOverride(
    covariant NotificationsProvider provider,
  ) {
    return call(page: provider.page, req: provider.req);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'notificationsProvider';
}

/// See also [notifications].
class NotificationsProvider
    extends
        AutoDisposeFutureProvider<
          Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>
        > {
  /// See also [notifications].
  NotificationsProvider({int page = 1, GetNotificationRequest? req})
    : this._internal(
        (ref) => notifications(ref as NotificationsRef, page: page, req: req),
        from: notificationsProvider,
        name: r'notificationsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$notificationsHash,
        dependencies: NotificationsFamily._dependencies,
        allTransitiveDependencies:
            NotificationsFamily._allTransitiveDependencies,
        page: page,
        req: req,
      );

  NotificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.req,
  }) : super.internal();

  final int page;
  final GetNotificationRequest? req;

  @override
  Override overrideWith(
    FutureOr<Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>>
    Function(NotificationsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationsProvider._internal(
        (ref) => create(ref as NotificationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        req: req,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>
  >
  createElement() {
    return _NotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationsProvider &&
        other.page == page &&
        other.req == req;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, req.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NotificationsRef
    on
        AutoDisposeFutureProviderRef<
          Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>
        > {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `req` of this provider.
  GetNotificationRequest? get req;
}

class _NotificationsProviderElement
    extends
        AutoDisposeFutureProviderElement<
          Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>
        >
    with NotificationsRef {
  _NotificationsProviderElement(super.provider);

  @override
  int get page => (origin as NotificationsProvider).page;
  @override
  GetNotificationRequest? get req => (origin as NotificationsProvider).req;
}

String _$notificationViewModelHash() =>
    r'734fa4398799036df0678f996e85dc8261f4ec31';

/// See also [NotificationViewModel].
@ProviderFor(NotificationViewModel)
final notificationViewModelProvider =
    AutoDisposeAsyncNotifierProvider<NotificationViewModel, void>.internal(
      NotificationViewModel.new,
      name: r'notificationViewModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notificationViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
