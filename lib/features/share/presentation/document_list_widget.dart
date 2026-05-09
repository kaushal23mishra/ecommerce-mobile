import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/share/view_model/share_document_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DocumentListWidget extends SalesdocketConsumerWidget {
  const DocumentListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error =
        ref
            .watch(sendDocumentFormErrorsProvider)
            .get(SendDocumentFormFields.documents)
            ?.message;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _listWidget(ref),
        if (error != null && error.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              error,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: appColors.error),
            ),
          ),
      ],
    );
  }

  Widget _listWidget(WidgetRef ref) {
    final documents = ref.watch(shareFilteredDocumentsProvider);
    final selectedDocuments = ref.watch(selectedShareDocumentsProvider);

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final document = documents[index];
        final isSelected = selectedDocuments.contains(document.id);

        return GestureDetector(
          onTap: () {
            final newDocuments = selectedDocuments.toList();
            final documentId = document.id;
            if (documentId == null) return;

            if (isSelected) {
              newDocuments.remove(documentId);
            } else {
              newDocuments.add(documentId);
            }
            ref
                .read(selectedShareDocumentsProvider.notifier)
                .update((state) => state = newDocuments);
            ref
                .read(sendDocumentFormErrorsProvider.notifier)
                .remove(SendDocumentFormFields.documents);
          },
          child: Container(
            color: appColors.background,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0.2.h),
                  child: _checkedWidget(isSelected),
                ),
                horizontalSpacing(4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.documentName ?? "",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: appColors.textPrimary),
                      ),
                      verticalSpacing(0.5.h),
                      Text(
                        document.documentType ?? "",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: appColors.textDisabled,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: documents.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget _checkedWidget(bool isSelected) {
    return isSelected
        ? SvgPicture.asset(
          Assets.svg.icCheckboxRounded.path,
          width: 5.w,
          height: 5.w,
        )
        : Container(
          width: 5.w,
          height: 5.w,
          decoration: BoxDecoration(
            border: Border.all(color: appColors.textPrimary, width: 0.2.w),
            borderRadius: BorderRadius.circular(1.w),
          ),
        );
  }
}
