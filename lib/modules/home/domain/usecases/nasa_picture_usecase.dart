import 'package:dartz/dartz.dart';
import 'package:nasa_picture/modules/home/data/services/nasa_picture_service.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

abstract class NasaPictureUsecase {
  Future<Either<Exception, NasaPictureEntity>> call();
}

class NasaPictureUsecaseImp implements NasaPictureUsecase {
  final NasaPictureService service;

  NasaPictureUsecaseImp(this.service);

  @override
  Future<Either<Exception, NasaPictureEntity>> call() async {
    return await service.getData();
  }
}