import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_ui_component/core/sizer/sizer.dart';
import 'package:salesdocket_ui_component/widget/salesdocket_image_widget.dart';
import 'package:salesdocket_ui_component/widget/salesdocket_spacing.dart';
import '../../../../../generated/assets.gen.dart';

extension CallNowNavigationPopupExtension on BuildContext {
  void callNowNavigationPopupExtension({
    required WidgetRef ref,
    required Future<void> Function() onProspectSheet,
    required Future<void> Function() onBooking,
    required Future<void> Function() onDashboard,
  }) {
    showDialog(
      context: this,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "How do you want to proceed?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => context.router.maybePop(),
                    ),
                  ],
                ),
                verticalSpacing(2.h),

                // Options (Register & Booking)
                IntrinsicHeight(
                  child: Row(
                    children: [
                      _optionTile(
                        context,
                        title: "Register",
                        imagePath: Assets.images.registration.path,
                        onTap: onProspectSheet,
                      ),
                      SizedBox(width: 4.w),
                      _optionTile(
                        context,
                        title: "Booking",
                        imagePath: Assets.images.booking.path,
                        onTap: onBooking,
                      ),
                      SizedBox(width: 4.w),
                      _optionTile(
                        context,
                        title: "Dashboard",
                        imagePath: Assets.images.appLogo.path,
                        onTap: onDashboard,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Reusable Widget for Register & Booking Options
  Widget _optionTile(
    BuildContext context, {
    required String title,
    required String imagePath,
    required Future<void> Function() onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          context.router.maybePop();
          await onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SalesDocketImageWidget(imagePath: imagePath, width: 20.w),
            verticalSpacing(0.5.h),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontSize: 15.sp),
            ),
            verticalSpacing(2.h),
          ],
        ),
      ),
    );
  }
}
