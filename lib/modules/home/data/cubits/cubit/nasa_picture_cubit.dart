import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_picture/modules/home/data/cubits/states/nasa_picture_states.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';

class NasaPictureCubit extends Cubit<NasaPictureState> {
  final NasaPictureUsecase usecase;
  NasaPictureCubit(this.usecase) : super(NasaPictureInitialState());

  void getData() async {
    emit(NasaPictureLoadingState());
    final result = await usecase.call();

    result.fold((l) => emit(NasaPictureErrorState(exception: l)), (r) {
      emit(NasaPictureSuccessState(r));
    });
  }
}
