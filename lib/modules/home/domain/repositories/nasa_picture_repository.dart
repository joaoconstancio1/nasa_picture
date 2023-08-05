import 'package:dartz/dartz.dart';
import '../entities/nasa_picture_entity.dart';

mixin NasaPictureRepository {
  Future<Either<Exception, List<NasaPictureEntity>>> getData(int page);
}
