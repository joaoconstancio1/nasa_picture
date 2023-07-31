import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
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

  test('should return a list of NasaPictureEntity', () async {
    final response = Response<List<NasaPictureDto>>(
      requestOptions: requestOptionsMock,
      data: [],
    );

    when(() => dio.get(any())).thenAnswer((_) async => response);

    final List<NasaPictureEntity> nasaPictureEntityList =
        await dataSource.getData();

    expect(nasaPictureEntityList, response.data);
  });

  test('should throw an exception if the response is not successful', () async {
    when(() => dio.get(any())).thenThrow(
        DioException(requestOptions: requestOptionsMock, error: 'Error'));

    try {
      await dataSource.getData();
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });
}
