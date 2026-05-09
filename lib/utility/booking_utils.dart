import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/document_type.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/entity/personal_details_images.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

class BookingUtils with UiComponentWidget {
  @override
  bool get isMounted => true;

  static bool isNewFile(String? path) {
    return path != null && path.isNotEmpty && !isUrl(path);
  }

  static List<Document> getFollowupImages(FollowupImages? images) {
    return [
      if (images?.imagesOne != null)
        Document(
          documentType: DocumentType.imageTwo.value,
          documentName: images?.imagesOne,
          fileName: images?.imagesOne,
        ),
      if (images?.imagesTwo != null)
        Document(
          documentType: DocumentType.imageTwo.value,
          documentName: images?.imagesTwo,
          fileName: images?.imagesTwo,
        ),
    ].where((document) => isNewFile(document.documentName)).toList();
  }





  static List<Document> getExchangeImages(ExchangeProductImages? images) {
    final carImages = images?.carImages ?? {};

    return [
      Document(
        documentType: DocumentType.insuranceImage.value,
        fileName: images?.insuranceImage,
      ),
      Document(
        documentType: DocumentType.rcFront.value,
        fileName: images?.blueBookImage ?? images?.rcFrontImage,
      ),
      Document(
        documentType: DocumentType.rcBack.value,
        fileName: images?.lotNoImage ?? images?.rcBackImage,
      ),
      Document(
        documentType: DocumentType.carImage1.value,
        fileName: carImages[1],
      ),
      Document(
        documentType: DocumentType.carImage2.value,
        fileName: carImages[2],
      ),
      Document(
        documentType: DocumentType.carImage3.value,
        fileName: carImages[3],
      ),
      Document(
        documentType: DocumentType.carImage4.value,
        fileName: carImages[4],
      ),
      Document(
        documentType: DocumentType.carImage5.value,
        fileName: carImages[5],
      ),
    ].where((document) => isNewFile(document.fileName)).toList();
  }

  static String? getDocument(DocumentType type, List<Document>? documents) =>
      (documents ?? [])
          .firstWhereOrNull((doc) => doc.documentType == type.value)
          ?.fileName;
}
