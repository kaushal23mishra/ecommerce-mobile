// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:salesdocket_core/salesdocket_core.dart';
// import 'package:salesdocket_core/src/constants/api_end_points.dart';
// import 'package:salesdocket_core/src/data_source/reports/remote/reports_data_source_impl.dart';
//
// class MockDio extends Mock implements Dio {}
//
// void main() {
//   late MockDio mockDio;
//   late ReportsDataSourceImpl dataSource;
//
//   setUpAll(() {
//     registerFallbackValue(RequestOptions(path: ''));
//   });
//
//   setUp(() {
//     mockDio = MockDio();
//     dataSource = ReportsDataSourceImpl(dio: mockDio, ref: ref);
//   });
//
//   group('ReportsDataSourceImpl', () {
//     group('deliveredReport', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsDelivery;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'data': {'total': 100, 'completed': 80},
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.deliveredReport();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test('should return DeliveredReport when response is valid', () async {
//         // Arrange
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {'total': 100, 'delivered': 80},
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         final result = await dataSource.deliveredReport();
//
//         // Assert
//         expect(result, isA<DeliveredReport>());
//       });
//
//       test('should propagate DioException when request fails', () async {
//         // Arrange
//         when(() => mockDio.get<Map<String, dynamic>>(any())).thenThrow(
//           DioException(
//             requestOptions: RequestOptions(path: ''),
//             type: DioExceptionType.connectionError,
//           ),
//         );
//
//         // Act & Assert
//         expect(
//           () => dataSource.deliveredReport(),
//           throwsA(isA<DioException>()),
//         );
//       });
//     });
//
//     group('deliveredReportBreakup', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsDeliveryBreakups;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'breakups': [
//               {'model': 'Swift', 'count': 50},
//               {'model': 'Baleno', 'count': 30},
//             ],
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.deliveredReportBreakup();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test('should return DeliveredReport when response is valid', () async {
//         // Arrange
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'breakups': [
//               {'model': 'Swift', 'count': 50},
//             ],
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         final result = await dataSource.deliveredReportBreakup();
//
//         // Assert
//         expect(result, isA<DeliveredReport>());
//       });
//
//       test('should handle timeout error', () async {
//         // Arrange
//         when(() => mockDio.get<Map<String, dynamic>>(any())).thenThrow(
//           DioException(
//             requestOptions: RequestOptions(path: ''),
//             type: DioExceptionType.connectionTimeout,
//           ),
//         );
//
//         // Act & Assert
//         expect(
//           () => dataSource.deliveredReportBreakup(),
//           throwsA(
//             isA<DioException>().having(
//               (e) => e.type,
//               'type',
//               DioExceptionType.connectionTimeout,
//             ),
//           ),
//         );
//       });
//     });
//
//     group('enquiryReport', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsEnquiry;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {'total': 500, 'thisMonth': 120},
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.enquiryReport();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test('should return EnquiryReport when response is valid', () async {
//         // Arrange
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {'total': 500, 'thisMonth': 120},
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         final result = await dataSource.enquiryReport();
//
//         // Assert
//         expect(result, isA<EnquiryReport>());
//       });
//
//       test('should handle server error', () async {
//         // Arrange
//         when(() => mockDio.get<Map<String, dynamic>>(any())).thenThrow(
//           DioException(
//             requestOptions: RequestOptions(path: ''),
//             type: DioExceptionType.badResponse,
//             response: Response(
//               requestOptions: RequestOptions(path: ''),
//               statusCode: 500,
//             ),
//           ),
//         );
//
//         // Act & Assert
//         expect(
//           () => dataSource.enquiryReport(),
//           throwsA(
//             isA<DioException>().having(
//               (e) => e.response?.statusCode,
//               'statusCode',
//               500,
//             ),
//           ),
//         );
//       });
//     });
//
//     group('enquiryReportBreakup', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsEnquiryBreakups;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'breakups': [
//               {'source': 'Walk-in', 'count': 100},
//               {'source': 'Phone', 'count': 80},
//             ],
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.enquiryReportBreakup();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test('should return EnquiryReport when response is valid', () async {
//         // Arrange
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'breakups': [
//               {'source': 'Walk-in', 'count': 100},
//             ],
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         final result = await dataSource.enquiryReportBreakup();
//
//         // Assert
//         expect(result, isA<EnquiryReport>());
//       });
//     });
//
//     group('conversionRatioReport', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsConversionRatio;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {'totalEnquiries': 500, 'totalBookings': 150, 'ratio': 0.3},
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.conversionRatioReport();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test(
//         'should return ConversionRatioReport when response is valid',
//         () async {
//           // Arrange
//           final tResponse = Response(
//             requestOptions: RequestOptions(path: ''),
//             data: {'totalEnquiries': 500, 'totalBookings': 150, 'ratio': 0.3},
//           );
//
//           when(
//             () => mockDio.get<Map<String, dynamic>>(any()),
//           ).thenAnswer((_) async => tResponse);
//
//           // Act
//           final result = await dataSource.conversionRatioReport();
//
//           // Assert
//           expect(result, isA<ConversionRatioReport>());
//         },
//       );
//     });
//
//     group('conversionRatioReportBreakup', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsConversionRatioBreakups;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'breakups': [
//               {'month': 'Jan', 'ratio': 0.25},
//               {'month': 'Feb', 'ratio': 0.30},
//             ],
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.conversionRatioReportBreakup();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test(
//         'should return ConversionRatioReport when response is valid',
//         () async {
//           // Arrange
//           final tResponse = Response(
//             requestOptions: RequestOptions(path: ''),
//             data: {
//               'breakups': [
//                 {'month': 'Jan', 'ratio': 0.25},
//               ],
//             },
//           );
//
//           when(
//             () => mockDio.get<Map<String, dynamic>>(any()),
//           ).thenAnswer((_) async => tResponse);
//
//           // Act
//           final result = await dataSource.conversionRatioReportBreakup();
//
//           // Assert
//           expect(result, isA<ConversionRatioReport>());
//         },
//       );
//     });
//
//     group('leadsAgingReport', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsLeadsAging;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'aging': [
//               {'range': '0-7 days', 'count': 50},
//               {'range': '8-30 days', 'count': 30},
//             ],
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.leadsAgingReport();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test('should return LeadAgingReport when response is valid', () async {
//         // Arrange
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {
//             'aging': [
//               {'range': '0-7 days', 'count': 50},
//             ],
//           },
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         final result = await dataSource.leadsAgingReport();
//
//         // Assert
//         expect(result, isA<LeadAgingReport>());
//       });
//     });
//
//     group('eprVsRegisteredReport', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsEprVsRegisteredLeads;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {'epr': 500, 'registered': 450, 'difference': 50},
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.eprVsRegisteredReport();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test(
//         'should return EprVsRegisteredReport when response is valid',
//         () async {
//           // Arrange
//           final tResponse = Response(
//             requestOptions: RequestOptions(path: ''),
//             data: {'epr': 500, 'registered': 450, 'difference': 50},
//           );
//
//           when(
//             () => mockDio.get<Map<String, dynamic>>(any()),
//           ).thenAnswer((_) async => tResponse);
//
//           // Act
//           final result = await dataSource.eprVsRegisteredReport();
//
//           // Assert
//           expect(result, isA<EprVsRegisteredReport>());
//         },
//       );
//     });
//
//     group('followupsReport', () {
//       test('should make GET request to correct endpoint', () async {
//         // Arrange
//         const url = APIEndPoints.reportsFollowups;
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {'total': 200, 'pending': 50, 'completed': 150},
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         await dataSource.followupsReport();
//
//         // Assert
//         verify(() => mockDio.get<Map<String, dynamic>>(url)).called(1);
//       });
//
//       test('should return FollowupsReport when response is valid', () async {
//         // Arrange
//         final tResponse = Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {'total': 200, 'pending': 50, 'completed': 150},
//         );
//
//         when(
//           () => mockDio.get<Map<String, dynamic>>(any()),
//         ).thenAnswer((_) async => tResponse);
//
//         // Act
//         final result = await dataSource.followupsReport();
//
//         // Assert
//         expect(result, isA<FollowupsReport>());
//       });
//
//       test('should handle unauthorized error', () async {
//         // Arrange
//         when(() => mockDio.get<Map<String, dynamic>>(any())).thenThrow(
//           DioException(
//             requestOptions: RequestOptions(path: ''),
//             type: DioExceptionType.badResponse,
//             response: Response(
//               requestOptions: RequestOptions(path: ''),
//               statusCode: 401,
//             ),
//           ),
//         );
//
//         // Act & Assert
//         expect(
//           () => dataSource.followupsReport(),
//           throwsA(
//             isA<DioException>().having(
//               (e) => e.response?.statusCode,
//               'statusCode',
//               401,
//             ),
//           ),
//         );
//       });
//     });
//   });
// }
