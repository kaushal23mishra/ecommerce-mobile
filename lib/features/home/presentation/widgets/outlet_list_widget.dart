import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/home/view_model/ho_selection_providers.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class OutletListWidget extends SalesdocketConsumerWidget {
  final List<OutletEntity> outlets;

  const OutletListWidget({
    super.key,
    required this.outlets,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (outlets.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Text(
            'No outlets available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: appColors.textDisabled,
                ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: outlets.length,
      itemBuilder: (context, index) {
        final outlet = outlets[index];
        return _buildOutletItem(context, ref, outlet);
      },
    );
  }

  Widget _buildOutletItem(
    BuildContext context,
    WidgetRef ref,
    OutletEntity outlet,
  ) {
    final selectedOutletId = ref.watch(selectedOutletIdProvider);
    final isSelected = selectedOutletId == outlet.id;

    return GestureDetector(
      onTap: () {
        ref.read(selectedOutletIdProvider.notifier).state = outlet.id;
        ref.read(selectedOutletNameProvider.notifier).state = outlet.name;
        // Clear designation selection when outlet is selected
        ref.read(selectedDesignationIdProvider.notifier).state = null;
        ref.read(selectedDesignationNameProvider.notifier).state = null;
      },
      child: Container(
        color: isSelected
            ? appColors.primary.withOpacity(0.1)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
        child: Row(
          children: [
            Icon(
              Icons.store,
              size: 5.w,
              color: isSelected
                  ? appColors.primary
                  : appColors.grayDark,
            ),
            horizontalSpacing(3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    outlet.name.toCamelCase,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? appColors.primary
                              : appColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (outlet.description != null &&
                      outlet.description!.isNotEmpty) ...[
                    verticalSpacing(0.3.h),
                    Text(
                      outlet.description!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: appColors.textDisabled,
                        fontSize: 15.sp,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
