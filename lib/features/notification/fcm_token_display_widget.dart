import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

/// Simple widget to display and copy FCM token
/// Use this to quickly get your FCM token for testing
///
/// Usage:
/// Add to any screen temporarily:
/// ```dart
/// FcmTokenDisplayWidget()
/// ```
class FcmTokenDisplayWidget extends StatefulWidget {
  const FcmTokenDisplayWidget({super.key});

  @override
  State<FcmTokenDisplayWidget> createState() => _FcmTokenDisplayWidgetState();
}

class _FcmTokenDisplayWidgetState extends State<FcmTokenDisplayWidget> {
  String? _token;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _token = token;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _token = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _copyToken() {
    if (_token != null && !_token!.startsWith('Error')) {
      Clipboard.setData(ClipboardData(text: _token!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('FCM Token copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = UiComponentManager().appColors;
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: appColors.blueLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: appColors.blueMedium!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.blue[700]),
              horizontalSpacing(2.w),
              Text(
                'FCM Token (for testing)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: appColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (!_isLoading && _token != null && !_token!.startsWith('Error'))
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _copyToken,
                  tooltip: 'Copy token',
                  color: appColors.secondary,
                ),
            ],
          ),
          verticalSpacing(1.h),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: appColors.secondary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                _token ?? 'No token',
                style: TextStyle(fontSize: 10.sp, fontFamily: 'monospace'),
              ),
            ),
          verticalSpacing(1.h),
          Text(
            'Use this token to test notifications from Firebase Console',
            style: TextStyle(
              fontSize: 10.sp,
              color: appColors.blueDark,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple button to show FCM token in a dialog
class ShowFcmTokenButton extends StatelessWidget {
  const ShowFcmTokenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showTokenDialog(context),
      icon: const Icon(Icons.notifications),
      label: const Text('Show FCM Token'),
    );
  }

  Future<void> _showTokenDialog(BuildContext context) async {
    final token = await FirebaseMessaging.instance.getToken();
    final appColors = UiComponentManager().appColors;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('FCM Token'),
            content: SelectableText(
              token ?? 'No token available',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: appColors.secondary),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (token != null) {
                    Clipboard.setData(ClipboardData(text: token));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Token copied')),
                    );
                  }
                },
                child: const Text('Copy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
