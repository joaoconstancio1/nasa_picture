import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture/modules/home/data/datasources/nasa_picture_datasource.dart';
import 'package:nasa_picture/modules/home/data/repositories/nasa_picture_repository_impl.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

class MockNasaPictureDataSource extends Mock implements NasaPictureDataSource {}

void main() {
  final dataSource = MockNasaPictureDataSource();
  final repository = NasaPictureRepositoryImpl(dataSource);

  test('should return a list of NasaPictureEntity when the data is fetched', () async {
    List<NasaPictureEntity> listNasaEntity = [
      NasaPictureEntity(
        title: 'Title 1',
        url: 'https://example.com/image1.jpg',
        explanation: 'Explanation 1',
      ),
      NasaPictureEntity(
        title: 'Title 2',
        url: 'https://example.com/image2.jpg',
        explanation: 'Explanation 2',
      ),
    ];

    when(() => dataSource.getData(any())).thenAnswer((_) async => listNasaEntity);

    final result = await repository.getData(1);

    expect(result, isA<Right<Exception, List<NasaPictureEntity>>>());
  });

  test('should return an error when the data is not fetched successfully', () async {
    when(() => dataSource.getData(any())).thenThrow(Exception('Error'));

    final result = await repository.getData(1);

    expect(result, isA<Left<Exception, List<NasaPictureEntity>>>());
  });
}
