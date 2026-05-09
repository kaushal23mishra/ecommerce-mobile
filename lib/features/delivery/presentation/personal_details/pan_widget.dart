import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';

import 'package:salesdocket_mobile/common/constants/document_type.dart';
import 'package:salesdocket_mobile/common/entity/media.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_images_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PanWidget extends SalesdocketConsumerWidget {
  const PanWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDelivery = ref.watch(selectedDeliveryProvider);
    final documents = selectedDelivery?.documents ?? [];



    final requiredTypes = [
      DocumentType.purchaseOrder,
      DocumentType.insuranceCopy,
      DocumentType.insuranceCopy2,
      DocumentType.panCertificate,
      DocumentType.taxClearance,
      DocumentType.regCompanyCertificate,
      DocumentType.regCompanyCertificate2,
      DocumentType.certificateCopy,
      DocumentType.certificateCopy2,
      DocumentType.shareCertificate,
      DocumentType.shareCertificate2,
      DocumentType.citizenCertificate,
      DocumentType.citizenCertificate2,
    ];

    final extraTypes = [
      DocumentType.picture1,
      DocumentType.picture2,
      DocumentType.picture3,
    ];

    final showMoreDocuments = ref.watch(showMoreDeliveryDocumentsProvider);

    // Function to generate Media objects from types
    List<Media> getImages(List<DocumentType> types) {
      return types.map((type) {
        final doc = documents.firstWhereOrNull((d) => d.documentType == type.value);
        return Media(
          name: type.label,
          gridSize: 6,
          path: doc?.fileName,
          documentType: type,
          url: doc?.fileName,
        );
      }).toList();
    }

    // Function to handle image changes (same logic for both)
    void onImageChanged(int index, XFile? file, List<Media> currentImages) {
      final type = currentImages[index].documentType;
      final currentDocs = List<Document>.from(
        ref.read(selectedDeliveryProvider)?.documents ?? [],
      );

      if (file != null) {
        final existingIndex =
            currentDocs.indexWhere((d) => d.documentType == type.value);

        if (existingIndex != -1) {
          final existingDoc = currentDocs[existingIndex];
          currentDocs[existingIndex] = existingDoc.copyWith(
            fileName: file.path,
          );
        } else {
          final newDoc = Document(
            documentType: type.value,
            fileName: file.path,
          );
          currentDocs.add(newDoc);
        }
      } else {
        currentDocs.removeWhere((d) => d.documentType == type.value);
      }

      ref
          .read(selectedDeliveryProvider.notifier)
          .update((state) => state?.copyWith(documents: currentDocs));
    }

    final mainImages = getImages(requiredTypes);
    final extraImagesList = getImages(extraTypes);

    return Column(
      children: [
        SalesdocketImagesWidget(
          images: mainImages,
          onImageChanged: (index, file) => onImageChanged(index, file, mainImages),
        ),
        SizedBox(height: 2.h),
        SwitchListTile(
          value: showMoreDocuments,
          activeColor: appColors.primary,
          onChanged: (value) {
            ref.read(showMoreDeliveryDocumentsProvider.notifier).state = value;
          },
          title: Text("Add more images"),
        ),
        if (showMoreDocuments) ...[
          SizedBox(height: 2.h),
          SalesdocketImagesWidget(
            images: extraImagesList,
            onImageChanged: (index, file) => onImageChanged(index, file, extraImagesList),
          ),
        ],
      ],
    );
  }
}
