import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_states.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_store.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';

class MockNasaPictureUsecase extends Mock implements NasaPictureUsecase {}

void main() {
  group('NasaPictureStore', () {
    late NasaPictureStore nasaPictureStore;
    late MockNasaPictureUsecase mockNasaPictureUsecase;

    setUp(() {
      mockNasaPictureUsecase = MockNasaPictureUsecase();
      nasaPictureStore = NasaPictureStore(mockNasaPictureUsecase);
    });

    test('getData() - Success State', () async {
      when(() => mockNasaPictureUsecase.call(any()))
          .thenAnswer((_) async => Right([
                NasaPictureEntity(),
                NasaPictureEntity(),
              ]));

      nasaPictureStore.getData(page: 1);

      await untilCalled(() => mockNasaPictureUsecase.call(1));

      verify(() => mockNasaPictureUsecase.call(1)).called(1);
      expect(nasaPictureStore.state, isA<NasaPictureSuccessState>());
    });

    test('getData() - Error State', () async {
      when(() => mockNasaPictureUsecase.call(any()))
          .thenAnswer((_) async => Left(Exception()));

      nasaPictureStore.getData(page: 1);

      await untilCalled(() => mockNasaPictureUsecase.call(1));

      verify(() => mockNasaPictureUsecase.call(1)).called(1);
      expect(nasaPictureStore.state, isA<NasaPictureErrorState>());
    });
  });
}
