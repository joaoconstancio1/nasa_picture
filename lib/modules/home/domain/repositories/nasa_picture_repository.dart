import 'package:dartz/dartz.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

mixin NasaPictureRepository {
  Future<Either<Exception, List<NasaPictureEntity>>> getData(int page);
}
