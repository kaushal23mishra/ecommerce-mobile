import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

/// Helper widget for testing push notifications
/// Usage: Add a button in dev builds to open this screen
/// This helps verify:
/// 1. FCM token is generated
/// 2. Notifications can be received
/// 3. Notification handling is working
class TestNotificationHelper extends StatefulWidget {
  const TestNotificationHelper({super.key});

  @override
  State<TestNotificationHelper> createState() => _TestNotificationHelperState();
}

class _TestNotificationHelperState extends State<TestNotificationHelper> {
  String? _fcmToken;
  String _lastNotificationTitle = 'None';
  String _lastNotificationBody = 'None';
  String _lastNotificationData = 'None';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getFcmToken();
    _setupNotificationListeners();
  }

  Future<void> _getFcmToken() async {
    setState(() => _isLoading = true);
    try {
      final token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _fcmToken = token;
        _isLoading = false;
      });
      Loggy('TestNotificationHelper').debug('FCM Token: $token');
    } catch (e) {
      setState(() => _isLoading = false);
      Loggy('TestNotificationHelper').error('Error getting FCM token: $e');
    }
  }

  void _setupNotificationListeners() {
    // Listen to foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Loggy('TestNotificationHelper').info('Foreground notification received');
      setState(() {
        _lastNotificationTitle = message.notification?.title ?? 'No title';
        _lastNotificationBody = message.notification?.body ?? 'No body';
        _lastNotificationData = message.data.toString();
      });
    });

    // Listen to notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Loggy('TestNotificationHelper').info('Notification tapped');
      setState(() {
        _lastNotificationTitle = message.notification?.title ?? 'No title';
        _lastNotificationBody = message.notification?.body ?? 'No body';
        _lastNotificationData = message.data.toString();
      });
    });
  }

  void _copyToken() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('FCM Token copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Push Notifications')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'FCM Token',
                      _fcmToken ?? 'Loading...',
                      onTap: _copyToken,
                      showCopy: true,
                    ),
                    verticalSpacing(2.h),
                    _buildInstructions(),
                    verticalSpacing(2.h),
                    _buildSection(
                      'Last Notification Title',
                      _lastNotificationTitle,
                    ),
                    verticalSpacing(2.h),
                    _buildSection(
                      'Last Notification Body',
                      _lastNotificationBody,
                    ),
                    verticalSpacing(2.h),
                    _buildSection(
                      'Last Notification Data',
                      _lastNotificationData,
                    ),
                    verticalSpacing(2.h),
                    _buildTestInstructions(),
                  ],
                ),
              ),
    );
  }

  Widget _buildSection(
    String title,
    String content, {
    VoidCallback? onTap,
    bool showCopy = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (showCopy)
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: onTap,
                tooltip: 'Copy to clipboard',
              ),
          ],
        ),
        verticalSpacing(1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            content,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to Test:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          verticalSpacing(1.h),
          _buildStep('1', 'Copy the FCM token above'),
          _buildStep('2', 'Send it to your backend team'),
          _buildStep('3', 'Ask them to send a test notification to this token'),
          _buildStep('4', 'The notification will appear above when received'),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          horizontalSpacing(2.w),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildTestInstructions() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Backend Test Command (curl):',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orange[900],
            ),
          ),
          verticalSpacing(1.h),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              '''curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT/messages:send \\
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \\
  -H "Content-Type: application/json" \\
  -d '{
    "message": {
      "token": "${_fcmToken ?? 'YOUR_FCM_TOKEN'}",
      "notification": {
        "title": "Test from Backend",
        "body": "This is a test notification"
      },
      "data": {
        "type": "lead_created",
        "lead_id": "123"
      }
    }
  }'
              ''',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
          verticalSpacing(1.h),
          Text(
            'Or use Firebase Console: Firebase Console > Cloud Messaging > Send test message',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }
}
