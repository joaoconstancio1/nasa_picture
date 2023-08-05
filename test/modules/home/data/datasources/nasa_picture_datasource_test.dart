import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture/modules/home/data/datasources/nasa_picture_datasource.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

class MockDio extends Mock implements Dio {}

class RequestOptionsMock extends Mock implements RequestOptions {}

void main() {
  late NasaPictureDataSourceImpl dataSource;
  late MockDio dio;
  late RequestOptions requestOptionsMock;

  setUp(() {
    dio = MockDio();
    dataSource = NasaPictureDataSourceImpl(dio);
    requestOptionsMock = RequestOptionsMock();
  });

  final List<Map<String, dynamic>> testResponseData = [
    {
      'url': 'https://example.com/pic1.jpg',
      'title': 'Picture 1',
      'explanation': 'This is picture 1',
      'date': '2023-08-01',
    },
  ];

  test('should return a list of NasaPictureEntity', () async {
    final response = Response<List<NasaPictureDto>>(
      requestOptions: requestOptionsMock,
      data: [],
    );

    when(() => dio.get(any())).thenAnswer((_) async => response);

    final List<NasaPictureEntity> nasaPictureEntityList = await dataSource.getData(1);

    expect(nasaPictureEntityList, response.data);
  });

  test('should throw an exception if the response is not successful', () async {
    when(() => dio.get(any()))
        .thenThrow(DioException(message: 'error', requestOptions: requestOptionsMock));

    expect(() async => await dataSource.getData(1), throwsException);
  });

  test('getData should calculate correct date range for different pages', () async {
    when(() => dio.get(any())).thenAnswer((_) async =>
        Response(data: testResponseData, statusCode: 200, requestOptions: requestOptionsMock));

    const subtractDate = 10;
    final endDatePage1 = DateTime.now().subtract(Duration());
    final startDatePage1 = endDatePage1.subtract(Duration(days: subtractDate));
    final formattedEndDatePage1 = DateFormat('yyyy-MM-dd').format(endDatePage1);
    final formattedStartDatePage1 = DateFormat('yyyy-MM-dd').format(startDatePage1);

    await dataSource.getData(1);

    verify(() => dio.get(captureAny()))
        .captured
        .first
        .endsWith('start_date=$formattedStartDatePage1&end_date=$formattedEndDatePage1');
  });
}
