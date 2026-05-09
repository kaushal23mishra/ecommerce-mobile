import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';

Future<bool> checkCallLogsForNumber(String phoneNumber) async {
  try {
    // iOS: Skip validation and directly allow "Already Spoken"
    // iOS doesn't support call_log package due to privacy restrictions
    if (Platform.isIOS) {
      debugPrint("iOS: Bypassing call log validation for 'Already Spoken'");
      return true;
    }

    // Android: Get current time and time 48 hours ago
    final now = DateTime.now();
    final fortyEightHoursAgo = now.subtract(const Duration(hours: 48));

    // Query call logs for last 48 hours
    final entries = await CallLog.query(
      dateFrom: fortyEightHoursAgo.millisecondsSinceEpoch,
      number: phoneNumber,
    );

    // Check if any call matches our criteria
    final validCall = entries.any((entry) {
      // Check if call was within last 48 hours
      final callDate = DateTime.fromMillisecondsSinceEpoch(
        entry.timestamp ?? 0,
      );
      final isWithin48Hours = callDate.isAfter(fortyEightHoursAgo);

      // Check if call duration is at least 10 seconds
      final isValidDuration = entry.duration != null && entry.duration! >= 10;

      // Check if call was outgoing
      final isOutgoing = entry.callType == CallType.outgoing;

      return isWithin48Hours && isValidDuration && isOutgoing;
    });

    return validCall;
  } catch (e) {
    debugPrint("Error checking call logs: $e");

    // On iOS, ignore errors and allow the action
    // (call_log plugin not available on iOS)
    if (Platform.isIOS) {
      debugPrint("iOS: Accepting 'Already Spoken' despite error");
      return true;
    }

    return false;
  }
}
