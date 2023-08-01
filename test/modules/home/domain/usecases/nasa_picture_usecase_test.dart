import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:nasa_picture/modules/home/data/services/nasa_picture_service.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';

class MockNasaPictureService extends Mock implements NasaPictureService {}

void main() {
  group('NasaPictureUsecaseImp', () {
    late NasaPictureUsecaseImp usecase;
    late NasaPictureService mockService;

    setUp(() {
      mockService = MockNasaPictureService();
      usecase = NasaPictureUsecaseImp(mockService);
    });

    test('Should return a list of NasaPictureEntity', () async {
      final mockData = [
        NasaPictureEntity(title: 'Nasa title', url: 'example.com/image.jpg')
      ];
      when(() => mockService.getData(any()))
          .thenAnswer((_) async => Right(mockData));

      final result = await usecase.call(1);

      expect(result, equals(Right(mockData)));
      verify(() => mockService.getData(any())).called(1);
    });

    test('Should return an exception when an error occurs', () async {
      final mockError = Exception('Error fetching data');
      when(() => mockService.getData(any()))
          .thenAnswer((_) async => Left(mockError));

      final result = await usecase.call(1);

      expect(result, equals(Left(mockError)));
      verify(() => mockService.getData(any())).called(1);
    });
  });
}
