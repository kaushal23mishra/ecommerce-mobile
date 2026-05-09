// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AccessoriesScreen]
class AccessoriesRoute extends PageRouteInfo<void> {
  const AccessoriesRoute({List<PageRouteInfo>? children})
    : super(AccessoriesRoute.name, initialChildren: children);

  static const String name = 'AccessoriesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccessoriesScreen();
    },
  );
}

/// generated route for
/// [AddEditReceiptScreen]
class AddEditReceiptRoute extends PageRouteInfo<void> {
  const AddEditReceiptRoute({List<PageRouteInfo>? children})
    : super(AddEditReceiptRoute.name, initialChildren: children);

  static const String name = 'AddEditReceiptRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddEditReceiptScreen();
    },
  );
}

/// generated route for
/// [ApprovalsScreen]
class ApprovalRoute extends PageRouteInfo<void> {
  const ApprovalRoute({List<PageRouteInfo>? children})
    : super(ApprovalRoute.name, initialChildren: children);

  static const String name = 'ApprovalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ApprovalsScreen();
    },
  );
}

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [BookingScreen]
class BookingRoute extends PageRouteInfo<void> {
  const BookingRoute({List<PageRouteInfo>? children})
    : super(BookingRoute.name, initialChildren: children);

  static const String name = 'BookingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BookingScreen();
    },
  );
}

/// generated route for
/// [CancelBookingScreen]
class CancelBookingRoute extends PageRouteInfo<void> {
  const CancelBookingRoute({List<PageRouteInfo>? children})
    : super(CancelBookingRoute.name, initialChildren: children);

  static const String name = 'CancelBookingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CancelBookingScreen();
    },
  );
}

/// generated route for
/// [CreateLeadResultScreen]
class CreateLeadResultRoute extends PageRouteInfo<void> {
  const CreateLeadResultRoute({List<PageRouteInfo>? children})
    : super(CreateLeadResultRoute.name, initialChildren: children);

  static const String name = 'CreateLeadResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateLeadResultScreen();
    },
  );
}

/// generated route for
/// [CreateLeadScreen]
class CreateLeadRoute extends PageRouteInfo<void> {
  const CreateLeadRoute({List<PageRouteInfo>? children})
    : super(CreateLeadRoute.name, initialChildren: children);

  static const String name = 'CreateLeadRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateLeadScreen();
    },
  );
}

/// generated route for
/// [DeliveryScreen]
class DeliveryRoute extends PageRouteInfo<void> {
  const DeliveryRoute({List<PageRouteInfo>? children})
    : super(DeliveryRoute.name, initialChildren: children);

  static const String name = 'DeliveryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DeliveryScreen();
    },
  );
}

/// generated route for
/// [FollowupHistoryScreen]
class FollowupHistoryRoute extends PageRouteInfo<void> {
  const FollowupHistoryRoute({List<PageRouteInfo>? children})
    : super(FollowupHistoryRoute.name, initialChildren: children);

  static const String name = 'FollowupHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FollowupHistoryScreen();
    },
  );
}

/// generated route for
/// [FollowupScreen]
class FollowupRoute extends PageRouteInfo<void> {
  const FollowupRoute({List<PageRouteInfo>? children})
    : super(FollowupRoute.name, initialChildren: children);

  static const String name = 'FollowupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FollowupScreen();
    },
  );
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [FullScreenMediaPage]
class FullScreenMediaPageRoute
    extends PageRouteInfo<FullScreenMediaPageRouteArgs> {
  FullScreenMediaPageRoute({
    Key? key,
    required String? mediaPath,
    List<PageRouteInfo>? children,
  }) : super(
         FullScreenMediaPageRoute.name,
         args: FullScreenMediaPageRouteArgs(key: key, mediaPath: mediaPath),
         initialChildren: children,
       );

  static const String name = 'FullScreenMediaPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FullScreenMediaPageRouteArgs>();
      return FullScreenMediaPage(key: args.key, mediaPath: args.mediaPath);
    },
  );
}

class FullScreenMediaPageRouteArgs {
  const FullScreenMediaPageRouteArgs({this.key, required this.mediaPath});

  final Key? key;

  final String? mediaPath;

  @override
  String toString() {
    return 'FullScreenMediaPageRouteArgs{key: $key, mediaPath: $mediaPath}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FullScreenMediaPageRouteArgs) return false;
    return key == other.key && mediaPath == other.mediaPath;
  }

  @override
  int get hashCode => key.hashCode ^ mediaPath.hashCode;
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [InactiveBookingScreen]
class InactiveBookingRoute extends PageRouteInfo<void> {
  const InactiveBookingRoute({List<PageRouteInfo>? children})
    : super(InactiveBookingRoute.name, initialChildren: children);

  static const String name = 'InactiveBookingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InactiveBookingScreen();
    },
  );
}

/// generated route for
/// [LeadAnalysisScreen]
class LeadAnalysisRoute extends PageRouteInfo<void> {
  const LeadAnalysisRoute({List<PageRouteInfo>? children})
    : super(LeadAnalysisRoute.name, initialChildren: children);

  static const String name = 'LeadAnalysisRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeadAnalysisScreen();
    },
  );
}

/// generated route for
/// [LeadFilterScreen]
class LeadFilterRoute extends PageRouteInfo<LeadFilterRouteArgs> {
  LeadFilterRoute({
    Key? key,
    required dynamic Function() onFilterApplied,
    List<PageRouteInfo>? children,
  }) : super(
         LeadFilterRoute.name,
         args: LeadFilterRouteArgs(key: key, onFilterApplied: onFilterApplied),
         initialChildren: children,
       );

  static const String name = 'LeadFilterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LeadFilterRouteArgs>();
      return LeadFilterScreen(
        key: args.key,
        onFilterApplied: args.onFilterApplied,
      );
    },
  );
}

class LeadFilterRouteArgs {
  const LeadFilterRouteArgs({this.key, required this.onFilterApplied});

  final Key? key;

  final dynamic Function() onFilterApplied;

  @override
  String toString() {
    return 'LeadFilterRouteArgs{key: $key, onFilterApplied: $onFilterApplied}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LeadFilterRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [LeadListScreen]
class LeadListRoute extends PageRouteInfo<void> {
  const LeadListRoute({List<PageRouteInfo>? children})
    : super(LeadListRoute.name, initialChildren: children);

  static const String name = 'LeadListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeadListScreen();
    },
  );
}

/// generated route for
/// [NotificationScreen]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationScreen();
    },
  );
}

/// generated route for
/// [ProspectScreen]
class ProspectRoute extends PageRouteInfo<void> {
  const ProspectRoute({List<PageRouteInfo>? children})
    : super(ProspectRoute.name, initialChildren: children);

  static const String name = 'ProspectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProspectScreen();
    },
  );
}

/// generated route for
/// [ReactivateLeadScreen]
class ReactivateLeadRoute extends PageRouteInfo<void> {
  const ReactivateLeadRoute({List<PageRouteInfo>? children})
    : super(ReactivateLeadRoute.name, initialChildren: children);

  static const String name = 'ReactivateLeadRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReactivateLeadScreen();
    },
  );
}

/// generated route for
/// [ReceiptListScreen]
class ReceiptListRoute extends PageRouteInfo<void> {
  const ReceiptListRoute({List<PageRouteInfo>? children})
    : super(ReceiptListRoute.name, initialChildren: children);

  static const String name = 'ReceiptListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReceiptListScreen();
    },
  );
}

/// generated route for
/// [SchemesScreen]
class SchemesRoute extends PageRouteInfo<void> {
  const SchemesRoute({List<PageRouteInfo>? children})
    : super(SchemesRoute.name, initialChildren: children);

  static const String name = 'SchemesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SchemesScreen();
    },
  );
}

/// generated route for
/// [SelectLeadsScreen]
class SelectLeadsRoute extends PageRouteInfo<void> {
  const SelectLeadsRoute({List<PageRouteInfo>? children})
    : super(SelectLeadsRoute.name, initialChildren: children);

  static const String name = 'SelectLeadsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectLeadsScreen();
    },
  );
}

/// generated route for
/// [ShareDocumentScreen]
class ShareDocumentRoute extends PageRouteInfo<void> {
  const ShareDocumentRoute({List<PageRouteInfo>? children})
    : super(ShareDocumentRoute.name, initialChildren: children);

  static const String name = 'ShareDocumentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShareDocumentScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [TransferLeadScreen]
class TransferLeadRoute extends PageRouteInfo<void> {
  const TransferLeadRoute({List<PageRouteInfo>? children})
    : super(TransferLeadRoute.name, initialChildren: children);

  static const String name = 'TransferLeadRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TransferLeadScreen();
    },
  );
}
