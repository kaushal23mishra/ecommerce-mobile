import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class Share extends SalesdocketConsumerStatefulWidget {
  const Share({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareState();
}

class _ShareState extends SalesdocketConsumerState<Share> {
  @override
  Widget build(BuildContext context) {
    final items = _actionItems;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.w,
        ),
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: () {
              if (item.action != null) {
                item.action!(context);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: appColors.secondary,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(color: appColors.border, width: 0.3.w),
              ),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.fabIcon, size: 5.h, color: appColors.primary),
                  verticalSpacing(2.5.w),
                  Text(
                    item.title ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static List<MenuItem> get _actionItems {
    return [
      MenuItem(
        title: "Share Documents",
        fabIcon: Icons.file_copy_outlined,
        action: (context) {
          context.router.push(const ShareDocumentRoute());
        },
      ),
    ];
  }
}
