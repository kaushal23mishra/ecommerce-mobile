import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_profile_image_widget.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DashboardUserCard extends SalesdocketConsumerStatefulWidget {
  const DashboardUserCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardUserCardState();
}

class _DashboardUserCardState
    extends SalesdocketConsumerState<DashboardUserCard> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    _currentTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _updateTime());
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: appColors.primary,
        boxShadow: [
          BoxShadow(
            color: appColors.shadow,
            spreadRadius: -4, // Increased spread radius
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              _buildUserImageSection,
              horizontalSpacing(3.w),
              Expanded(child: _buildHeaderRow),
            ],
          ),
          verticalSpacing(1.5.h),
          _dateTimeWidget,
        ],
      ),
    );
  }

  Widget get _buildUserImageSection {
    final profile = ref.watch(profileProvider);

    return SalesdocketProfileImageWidget(
      imageUrl: profile?.logo,
      name: profile?.fullName,
      size: 10.w,
      bgColor: appColors.secondary,
    );
  }

  Widget get _buildHeaderRow {
    final profile = ref.watch(profileProvider);

    return Text(
      'Hey, ${profile?.fullName ?? ""}',
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: appColors.textSecondary),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get _dateTimeWidget {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 0.125.h),
                child: Icon(
                  Icons.date_range,
                  size: 4.w,
                  color: appColors.secondary,
                ),
              ),
              horizontalSpacing(1.w),
              Text(
                DateFormat('MMMM d, y').format(_currentTime),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: appColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 0.125.h),
              child: Icon(
                Icons.access_time,
                size: 4.w,
                color: appColors.secondary,
              ),
            ),
            horizontalSpacing(1.w),
            Text(
              DateFormat('hh:mm a').format(_currentTime),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: appColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }
}
