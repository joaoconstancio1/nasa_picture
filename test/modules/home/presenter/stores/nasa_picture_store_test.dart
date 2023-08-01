import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture/modules/home/presenter/stores/nasa_picture_states.dart';
import 'package:nasa_picture/modules/home/presenter/stores/nasa_picture_store.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';

class MockNasaPictureUsecase extends Mock implements NasaPictureUsecase {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('NasaPictureStore', () {
    late NasaPictureStore store;
    late MockNasaPictureUsecase usecase;

    setUp(() {
      usecase = MockNasaPictureUsecase();
      store = NasaPictureStore(usecase);
    });

    test('getData() - Success State', () async {
      when(() => usecase.call(any())).thenAnswer((_) async => Right([
            NasaPictureEntity(),
            NasaPictureEntity(),
          ]));

      store.getData();

      await untilCalled(() => usecase.call(1));

      verify(() => usecase.call(1)).called(1);
      expect(store.state, isA<NasaPictureSuccessState>());
    });

    test('getData() - Error State', () async {
      when(() => usecase.call(any())).thenAnswer((_) async => Left(Exception()));

      store.getData();

      await untilCalled(() => usecase.call(1));

      verify(() => usecase.call(1)).called(1);
      expect(store.state, isA<NasaPictureErrorState>());
    });

    test('filterNasaPictures should filter pictures based on query', () {
      store.update(NasaPictureSuccessState([
        NasaPictureEntity(title: 'Picture 1', date: '2023-08-01'),
        NasaPictureEntity(title: 'Picture 2', date: '2023-08-02'),
      ]));

      store.filterNasaPictures('Picture 1');

      expect(store.filteredNasaPictures, hasLength(1));
      expect(store.filteredNasaPictures[0].title, contains('Picture 1'));
    });
    test('loadMore should increment currentPage and call getData and resetSearch', () async {
      when(() => usecase.call(any())).thenAnswer((_) async => const Right([]));

      final initialPage = store.currentPage;

      store.loadMore();

      expect(store.currentPage, initialPage + 1);
      verify(() => usecase.call(initialPage + 1));
      expect(store.filteredNasaPictures, isEmpty);
      expect(store.searchController.text, '');
    });
    test('resetSearch should reset the searchController and filteredNasaPictures', () {
      store.filteredNasaPictures = [
        NasaPictureEntity(title: 'Picture 1', date: '2023-08-01'),
        NasaPictureEntity(title: 'Picture 2', date: '2023-08-02'),
      ];
      store.searchController.text = 'search query';

      store.resetSearch();

      expect(store.filteredNasaPictures, isEmpty);
      expect(store.searchController.text, '');
    });
    test('handleRefresh should reset currentPage and call getData and resetSearch', () async {
      when(() => usecase.call(any())).thenAnswer((_) async => const Right([]));
      store.currentPage = 5;
      store.filteredNasaPictures = [
        NasaPictureEntity(title: 'Picture 1', date: '2023-08-01'),
        NasaPictureEntity(title: 'Picture 2', date: '2023-08-02'),
      ];
      store.searchController.text = 'search query';

      store.handleRefresh();

      expect(store.currentPage, 1);
      verify(() => usecase.call(1));
      expect(store.filteredNasaPictures, isEmpty);
      expect(store.searchController.text, '');
    });
  });
}
