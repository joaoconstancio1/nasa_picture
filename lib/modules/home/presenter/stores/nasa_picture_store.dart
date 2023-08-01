import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:nasa_picture/modules/home/presenter/stores/nasa_picture_states.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';

class NasaPictureStore extends Store<NasaPictureState> {
  final NasaPictureUsecase usecase;
  NasaPictureStore(this.usecase) : super(NasaPictureInitialState());

  int currentPage = 1;
  List<NasaPictureEntity> filteredNasaPictures = [];
  final TextEditingController searchController = TextEditingController();

  void getData() async {
    try {
      update(NasaPictureLoadingState());
      final result = await usecase.call(currentPage);
      result.fold(
        (l) => update(NasaPictureErrorState(exception: l)),
        (r) => update(NasaPictureSuccessState(r)),
      );
    } on Exception catch (e) {
      setError(e);
    }
  }

  void filterNasaPictures(String query) {
    final currentState = state;
    if (currentState is NasaPictureSuccessState) {
      filteredNasaPictures = currentState.entity
          .where((picture) =>
              picture.title?.toLowerCase().contains(query.toLowerCase()) == true ||
              picture.date?.toLowerCase().contains(query.toLowerCase()) == true)
          .toList();
    }
  }

  void onSearchTextChanged() {
    filterNasaPictures(searchController.text);
  }

  void loadMore() {
    currentPage++;
    getData();
    resetSearch();
  }

  void resetSearch() {
    searchController.text = '';
    filteredNasaPictures = [];
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Future<void> handleRefresh() async {
    currentPage = 1;
    getData();
    resetSearch();
  }
}
