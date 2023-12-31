import 'package:dartz/dartz.dart';

import '../../domain/entities/nasa_picture_entity.dart';
import '../../domain/repositories/nasa_picture_repository.dart';
import '../datasources/nasa_picture_datasource.dart';

class NasaPictureRepositoryImpl implements NasaPictureRepository {
  final NasaPictureDataSource dataSource;
  NasaPictureRepositoryImpl(this.dataSource);

  @override
  Future<Either<Exception, List<NasaPictureEntity>>> getData(int page) async {
    try {
      final result = await dataSource.getData(page);

      return Right(result);
    } on Exception catch (error) {
      return Left(Exception('Error: $error'));
    }
  }
}
