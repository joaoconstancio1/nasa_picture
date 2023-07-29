import 'package:dartz/dartz.dart';
import 'package:nasa_picture/modules/home/data/datasources/nasa_picture_datasource.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

mixin NasaPictureService {
  Future<Either<Exception, NasaPictureEntity>> getData();
}

class NasaPictureServiceImpl implements NasaPictureService {
  final NasaPictureDataSource dataSource;
  NasaPictureServiceImpl(this.dataSource);

  @override
  Future<Either<Exception, NasaPictureEntity>> getData() async {
    try {
      final result = await dataSource.getData();

      return Right(result);
    } on Exception catch (error) {
      return Left(Exception('Error: $error'));
    }
  }
}
