import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/domain/repositories/nasa_picture_repository.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';

class MockNasaPictureRepository extends Mock implements NasaPictureRepository {}

void main() {
  group('NasaPictureUsecaseImp', () {
    late NasaPictureUsecaseImp usecase;
    late NasaPictureRepository repository;

    setUp(() {
      repository = MockNasaPictureRepository();
      usecase = NasaPictureUsecaseImp(repository);
    });

    test('Should return a list of NasaPictureEntity', () async {
      final mockData = [NasaPictureEntity(title: 'Nasa title', url: 'example.com/image.jpg')];
      when(() => repository.getData(any())).thenAnswer((_) async => Right(mockData));

      final result = await usecase.call(1);

      expect(result, equals(Right(mockData)));
      verify(() => repository.getData(any())).called(1);
    });

    test('Should return an exception when an error occurs', () async {
      final mockError = Exception('Error fetching data');
      when(() => repository.getData(any())).thenAnswer((_) async => Left(mockError));

      final result = await usecase.call(1);

      expect(result, equals(Left(mockError)));
      verify(() => repository.getData(any())).called(1);
    });
  });
}
