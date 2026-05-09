import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/document_type.dart';
import 'package:salesdocket_mobile/common/entity/media.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_images_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PanWidget extends SalesdocketConsumerWidget {
  const PanWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBooking = ref.watch(selectedBookingProvider);
    final documents = selectedBooking?.documents ?? [];

    final requiredTypes = [
      DocumentType.purchaseOrder,
    ];

    final images = requiredTypes.map((type) {
      final doc = documents.firstWhereOrNull((d) => d.documentType == type.value);
      return Media(
        name: type.label,
        gridSize: 6,
        path: doc?.fileName,
        documentType: type,
        url: doc?.fileName,
      );
    }).toList();

    return SalesdocketImagesWidget(
      images: images,
      onImageChanged: (index, file) {
        final type = images[index].documentType;
        final currentDocs = List<Document>.from(
          ref.read(selectedBookingProvider)?.documents ?? [],
        );

        if (file != null) {
          final existingIndex =
              currentDocs.indexWhere((d) => d.documentType == type.value);

          if (existingIndex != -1) {
            final existingDoc = currentDocs[existingIndex];
            currentDocs[existingIndex] = existingDoc.copyWith(
              fileName: file.path,
              // Preserve other fields if necessary, though copyWith usually handles it.
              // Importantly, we might need to signify this is a local file now.
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
            .read(selectedBookingProvider.notifier)
            .update((state) => state?.copyWith(documents: currentDocs));
      },
    );
  }
}
