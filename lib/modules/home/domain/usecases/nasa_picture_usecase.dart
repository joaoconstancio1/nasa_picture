import 'package:dartz/dartz.dart';
import '../entities/nasa_picture_entity.dart';
import '../repositories/nasa_picture_repository.dart';

abstract class NasaPictureUsecase {
  Future<Either<Exception, List<NasaPictureEntity>>> call(int page);
}

class NasaPictureUsecaseImp implements NasaPictureUsecase {
  final NasaPictureRepository repository;

  NasaPictureUsecaseImp(this.repository);

  @override
  Future<Either<Exception, List<NasaPictureEntity>>> call(int page) async =>
      await repository.getData(page);
}
