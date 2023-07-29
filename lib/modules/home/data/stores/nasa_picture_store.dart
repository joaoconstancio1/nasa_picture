import 'package:flutter_triple/flutter_triple.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_states.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';

class NasaPictureStore extends Store<NasaPictureState> {
  final NasaPictureUsecase usecase;
  NasaPictureStore(this.usecase) : super(NasaPictureInitialState());

  void getData() async {
    try {
      setLoading(true);
      final result = await usecase.call();
      result.fold((l) => update(NasaPictureErrorState(exception: l)), (r) {
        update(NasaPictureSuccessState(r));
      });
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
