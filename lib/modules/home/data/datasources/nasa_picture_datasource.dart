import 'package:dio/dio.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

mixin NasaPictureDataSource {
  Future<NasaPictureEntity> getData();
}

class NasaPictureDataSourceImpl implements NasaPictureDataSource {
  final Dio dio = Dio();

  @override
  Future<NasaPictureEntity> getData() async {
    try {
      final response = await dio.get(
          'https://api.nasa.gov/planetary/apod?api_key=01TCw2u3fDTduBASpGuEfNighIUcIutFX3ZjGxhr');
      final res = NasaPictureDto.fromJson(response.data);

      return res;
    } catch (e) {
      throw Exception(e);
    }
  }
}
