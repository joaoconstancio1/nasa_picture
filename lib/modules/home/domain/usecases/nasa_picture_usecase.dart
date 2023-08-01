import 'package:dartz/dartz.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/domain/repositories/nasa_picture_repository.dart';

abstract class NasaPictureUsecase {
  Future<Either<Exception, List<NasaPictureEntity>>> call(int page);
}

class NasaPictureUsecaseImp implements NasaPictureUsecase {
  final NasaPictureRepository repository;

  NasaPictureUsecaseImp(this.repository);

  @override
  Future<Either<Exception, List<NasaPictureEntity>>> call(int page) async {
    return await repository.getData(page);
  }
}
