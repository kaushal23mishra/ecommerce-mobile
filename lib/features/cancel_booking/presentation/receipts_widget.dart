import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_image_container.dart';
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ReceiptsWidget extends SalesdocketConsumerWidget {
  const ReceiptsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelBookingRequest = ref.watch(cancelBookingRequestProvider);
    final documents = cancelBookingRequest?.documents ?? [];
    final addMoreReceipt = ref.watch(addMoreReceiptProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesdocketImageContainer(
          title: LocaleKeys.receipt.tr(),
          onImageChanged: (file) {
            final newDocuments = documents.toList();
            if (file == null) {
              newDocuments.removeAt(0);
            } else {
              // Extract file extension from the path
              final extension = file.path.split('.').last.toUpperCase();
              final document = Document(
                fileName: file.path,
                documentType: extension,
              );
              if (newDocuments.isEmpty) {
                newDocuments.add(document);
              } else {
                newDocuments.insert(0, document);
              }
            }

            ref
                .read(cancelBookingRequestProvider.notifier)
                .update(
                  (state) => state = state?.copyWith(documents: newDocuments),
                );
          },
          path: documents.firstOrNull?.fileName,
          height: 20.h,
        ),
        verticalSpacing(1.h),
        if (documents.isNotEmpty)
          SalesdocketSwitchWidget(
            label: LocaleKeys.addMore.tr(),
            onChanged: (value) {
              ref
                  .read(addMoreReceiptProvider.notifier)
                  .update((state) => state = value);
            },
            hasSpace: true,
            value: addMoreReceipt,
          ),
        if (documents.isNotEmpty && addMoreReceipt)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: SalesdocketImageContainer(
              title: LocaleKeys.receipt.tr(),
              onImageChanged: (file) {
                final newDocuments = documents.toList();
                if (file == null) {
                  newDocuments.removeLast();
                } else {
                  // Extract file extension from the path
                  final extension = file.path.split('.').last.toUpperCase();
                  final document = Document(
                    fileName: file.path,
                    documentType: extension,
                  );
                  if (newDocuments.length == 1) {
                    newDocuments.add(document);
                  } else {
                    newDocuments.insert(1, document);
                  }
                }

                ref
                    .read(cancelBookingRequestProvider.notifier)
                    .update(
                      (state) =>
                          state = state?.copyWith(documents: newDocuments),
                    );
              },
              path: documents.elementAtOrNull(1)?.fileName,
              height: 20.h,
            ),
          ),
      ],
    );
  }
}
