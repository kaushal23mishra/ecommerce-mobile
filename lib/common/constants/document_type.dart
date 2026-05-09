import 'package:salesdocket_mobile/common/constants/constant.dart';

class DocumentType extends Constant<String> {
  final String label;

  const DocumentType(super.val, {this.label = ""});



  static const photoId = DocumentType('photoid');
  static const addressProofOne = DocumentType('addressproof1');
  static const addressProofTwo = DocumentType('addressproof2');
  static const insuranceImage = DocumentType('image_insurance');
  static const rcFront = DocumentType('image_rc_front');
  static const rcBack = DocumentType('image_rc_back');
  static const carImage1 = DocumentType('image_car_front');
  static const carImage2 = DocumentType('image_car_back');
  static const carImage3 = DocumentType('image_car_left');
  static const carImage4 = DocumentType('image_car_right');
  static const carImage5 = DocumentType('image_car_interior');
  static const homeVisit = DocumentType('home_visit');
  static const imageOne = DocumentType(
    'home_visit',
    label: "Home Visit Image 1",
  );
  static const imageTwo = DocumentType(
    'home_visit',
    label: "Home Visit Image 2",
  );
  static const picture1 = DocumentType('imageView1', label: "Picture 1");
  static const picture2 = DocumentType('imageView2', label: "Picture 2");
  static const picture3 = DocumentType('imageView3', label: "Picture 3");
  static const blueBook = DocumentType('blue_book', label: "Blue Book");
  static const lotNo = DocumentType('lot_no', label: "Lot No");
  static const customerPic = DocumentType(
    'customer_pic',
    label: "Customer Pic",
  );

  static const purchaseOrder = DocumentType(
    'purchase_order',
    label: "Purchase Order",
  );
  static const insuranceCopy = DocumentType(
    'insurance_copy',
    label: "Insurance Copy",
  );
  static const insuranceCopy2 = DocumentType(
    'insurance_copy2',
    label: "Insurance Copy 2",
  );
  static const panCertificate = DocumentType(
    'pan_certficate',
    label: "PAN Certificate",
  );
  static const taxClearance = DocumentType(
    'tax_clearance',
    label: "TAX Clearance Copy",
  );
  static const regCompanyCertificate = DocumentType(
    'reg_company_certificate',
    label: "Company Registration Certificate",
  );
  static const regCompanyCertificate2 = DocumentType(
    'reg_company_certificate2',
    label: "Company Registration Certificate 2",
  );
  static const certificateCopy = DocumentType(
    'certificate_copy',
    label: "Banijya Certificate Copy",
  );
  static const certificateCopy2 = DocumentType(
    'certificate_copy2',
    label: "Banijya Certificate Copy 2",
  );
  static const shareCertificate = DocumentType(
    'share_certificate',
    label: "Share Certificate Copy",
  );
  static const shareCertificate2 = DocumentType(
    'share_certificate2',
    label: "Share Certificate Copy 2",
  );
  static const citizenCertificate = DocumentType(
    'citizen_certificate',
    label: "Citizenship Certificate",
  );
  static const citizenCertificate2 = DocumentType(
    'citizen_certificate2',
    label: "Citizenship Certificate 2",
  );
}

List<DocumentType> get documentTypeList => [];
