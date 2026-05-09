import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class QuerySuccessMessageWidget extends SalesdocketStatelessWidget {
  const QuerySuccessMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SalesDocketImageWidget(
          imagePath: Assets.svg.icCircleCheck.path,
          width: 15.w,
        ),
        verticalSpacing(2.h),
        Text(
          LocaleKeys.enquirySavedSuccessfully.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
