import 'package:dartz/dartz.dart';
import 'package:nasa_picture/modules/home/data/services/nasa_picture_service.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

abstract class NasaPictureUsecase {
  Future<Either<Exception, List<NasaPictureEntity>>> call(int page);
}

class NasaPictureUsecaseImp implements NasaPictureUsecase {
  final NasaPictureService service;

  NasaPictureUsecaseImp(this.service);

  @override
  Future<Either<Exception, List<NasaPictureEntity>>> call(int page) async {
    return await service.getData(page);
  }
}
