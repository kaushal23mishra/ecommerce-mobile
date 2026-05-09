import 'dart:async';
import 'dart:io';
import 'package:call_log/call_log.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/followup/view_model/followup_view_model.dart';
import '../../generated/locale_keys.g.dart';

// Provider to track call start time for iOS
final callStartTimeProvider = StateProvider<DateTime?>((ref) => null);

// Helper function to handle app resume for iOS calls (can be called from anywhere)
void handleIOSCallResume(WidgetRef ref) {
  if (!Platform.isIOS) return;

  final callInProgress = ref.read(callInProgressProvider);
  final callStartTime = ref.read(callStartTimeProvider);

  if (callInProgress && callStartTime != null) {
    final callEndTime = DateTime.now();
    final duration = callEndTime.difference(callStartTime).inSeconds;

    debugPrint("iOS call ended. Duration: $duration seconds");

    ref.read(callDurationProvider.notifier).state = duration;
    ref.read(callInProgressProvider.notifier).state = false;
    ref.read(callStartTimeProvider.notifier).state = null;

    ref.read(callStatusProvider.notifier).state =
        LocaleKeys.lblSpokeToCustomer.tr();
    debugPrint("iOS: Spoke to customer enabled (duration: $duration s)");

  }
}

mixin ContactEvents {
  Future<void> makePhoneCall(String mobile, WidgetRef ref) async {
    if (mobile.isEmpty) {
      debugPrint("Invalid Mobile Number!");
      return;
    }

    // Reset states
    ref.read(callDurationProvider.notifier).state = null;
    ref.read(callStatusProvider.notifier).state = null;

    if (Platform.isIOS) {
      await _makePhoneCallIOS(mobile, ref);
    } else {
      await _makePhoneCallAndroid(mobile, ref);
    }
  }

  Future<void> _makePhoneCallAndroid(String mobile, WidgetRef ref) async {
    final permission = await Permission.phone.request();
    if (!permission.isGranted) {
      debugPrint("Phone permission not granted.");
      return;
    }

    bool callInitiated = false;
    try {
      callInitiated = await const MethodChannel('com.agbe.idealmotors/call').invokeMethod('makeDirectCall', {'number': mobile}) ?? false;
    } catch (e) {
      debugPrint("Error making direct call: $e");
    }

    if (callInitiated) {
      await _monitorCallLog(mobile, ref);
    }
  }

  Future<void> _makePhoneCallIOS(String mobile, WidgetRef ref) async {
    try {
      // Store call start time
      ref.read(callStartTimeProvider.notifier).state = DateTime.now();
      ref.read(callInProgressProvider.notifier).state = true;

      // Use url_launcher for iOS directly
      debugPrint("iOS: Initiating call to $mobile");
      final uri = Uri.parse('tel:$mobile');
      final callInitiated = await launchUrl(uri);

      if (callInitiated) {
        debugPrint("iOS call initiated successfully to: $mobile");
      } else {
        // Phone calls don't work on iOS Simulator - only on real devices
        // For simulator testing, we'll simulate the call being initiated
        debugPrint(
          "⚠️ Phone call failed on iOS (expected on simulator). "
          "Call tracking will still work when you manually tap back to the app after 10+ seconds.",
        );
        // Keep call in progress state so duration tracking works
        debugPrint(
          "💡 Simulating call for testing. App will track duration when you return from background.",
        );
      }
    } catch (e) {
      debugPrint("Error making phone call on iOS: $e");
      // On simulator, keep the call tracking active even if the actual call fails
      debugPrint(
        "💡 Keeping call tracking active for simulator testing. "
        "Duration will be tracked when app resumes.",
      );
    }
  }


  Future<void> _monitorCallLog(String phoneNumber, WidgetRef ref) async {
    const checkInterval = Duration(seconds: 1);
    final callStartTime = DateTime.now();

    while (true) {
      await Future.delayed(checkInterval);

      try {
        final entries = await CallLog.query(
          dateFrom:
              callStartTime
                  .subtract(const Duration(seconds: 5))
                  .millisecondsSinceEpoch,
          number: phoneNumber,
        );

        if (entries.isEmpty) continue;

        // Find the most recent call entry
        final callEntry = entries.firstWhere(
          (entry) => entry.duration != null,
          orElse: () => CallLogEntry(),
        );

        // Case 1: Call was never picked up (duration == 0)
        if (callEntry.duration == 0) {
          // ref.read(callStatusProvider.notifier).state = LocaleKeys.lblBusy.tr();
          return;
        }

        // Case 2: Call was picked up (duration > 0)
        if (callEntry.duration != null && callEntry.duration! > 0) {
          final duration = callEntry.duration!;
          ref.read(callDurationProvider.notifier).state = duration;
          ref.read(callStatusProvider.notifier).state =
              LocaleKeys.lblSpokeToCustomer.tr();
          return;
        }

        continue;
      } catch (e) {
        debugPrint("Error monitoring call log: $e");
        break;
      }
    }
  }
}
