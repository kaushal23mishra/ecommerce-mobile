import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/features/accessories/presentation/accessories_screen.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/approvals_screen.dart';
import 'package:salesdocket_mobile/features/auth/presentation/auth_screen.dart';
import 'package:salesdocket_mobile/features/auth/presentation/forgot_password.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_screen.dart';
import 'package:salesdocket_mobile/features/cancel_booking/presentation/cancel_booking_screen.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_screen.dart';
import 'package:salesdocket_mobile/features/followup/presentation/followup_screen.dart';
import 'package:salesdocket_mobile/features/followup_history/presentation/followup_history_screen.dart';
import 'package:salesdocket_mobile/features/home/presentation/home_screen.dart';
import 'package:salesdocket_mobile/features/inactive_booking/presentation/inactive_booking_screen.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/create_lead_screen.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead_result/create_lead_result_screen.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_filter/lead_filter_screen.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_list_screen.dart';
import 'package:salesdocket_mobile/features/lead_analysis/presentation/lead_analysis_screen.dart';
import 'package:salesdocket_mobile/features/media/presentation/full_screen_media_page.dart';
import 'package:salesdocket_mobile/features/notification/presentation/notification_screen.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/prospect_screen.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/presentation/reactivate_lead_screen.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/add_edit_receipt_screen.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/receipt_list/receipt_list_screen.dart';
import 'package:salesdocket_mobile/features/schemes/presentation/schemes_screen.dart';
import 'package:salesdocket_mobile/features/share/presentation/select_leads/select_leads_screen.dart';
import 'package:salesdocket_mobile/features/splash/presentation/splash_screen.dart';
import 'package:salesdocket_mobile/features/transfer_lead/presentation/transfer_lead_screen.dart';
import 'package:salesdocket_mobile/routing/auth_guard.dart';

import '../features/share/presentation/share_document_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen, Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AccessoriesRoute.page),
    AutoRoute(page: AddEditReceiptRoute.page),
    AutoRoute(page: ApprovalRoute.page),
    AutoRoute(page: AuthRoute.page),
    AutoRoute(page: BookingRoute.page),
    AutoRoute(page: CancelBookingRoute.page),
    AutoRoute(page: CreateLeadResultRoute.page),
    AutoRoute(page: CreateLeadRoute.page),
    AutoRoute(page: DeliveryRoute.page),
    AutoRoute(page: FollowupHistoryRoute.page),
    AutoRoute(page: FollowupRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: FullScreenMediaPageRoute.page),
    AutoRoute(page: HomeRoute.page, guards: [AuthGuard()]),
    AutoRoute(page: InactiveBookingRoute.page),
    AutoRoute(page: LeadAnalysisRoute.page),
    AutoRoute(page: LeadFilterRoute.page),
    AutoRoute(page: LeadListRoute.page),
    AutoRoute(page: NotificationRoute.page),
    AutoRoute(page: ProspectRoute.page),
    AutoRoute(page: ReactivateLeadRoute.page),
    AutoRoute(page: ReceiptListRoute.page),
    AutoRoute(page: SchemesRoute.page),
    AutoRoute(page: SelectLeadsRoute.page),
    AutoRoute(page: ShareDocumentRoute.page),
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: TransferLeadRoute.page),
  ];
}

final AppRouter appRouter = AppRouter();