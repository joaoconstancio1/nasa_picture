import 'package:dio/dio.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

mixin NasaPictureDataSource {
  Future<List<NasaPictureEntity>> getData();
}

class NasaPictureDataSourceImpl implements NasaPictureDataSource {
  final Dio dio = Dio();

  @override
  Future<List<NasaPictureEntity>> getData() async {
    const url =
        'https://api.nasa.gov/planetary/apod?api_key=01TCw2u3fDTduBASpGuEfNighIUcIutFX3ZjGxhr&start_date=2023-01-01&end_date=2023-03-01';
    try {
      final response = await dio.get(url);

      final List<NasaPictureDto> nasaPictureList = List<NasaPictureDto>.from(
          response.data.map((item) => NasaPictureDto.fromJson(item)));

      return nasaPictureList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
