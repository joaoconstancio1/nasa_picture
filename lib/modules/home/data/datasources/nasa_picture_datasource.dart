import 'package:dio/dio.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:intl/intl.dart';

mixin NasaPictureDataSource {
  Future<List<NasaPictureEntity>> getData(int page);
}

class NasaPictureDataSourceImpl implements NasaPictureDataSource {
  final Dio dio;

  NasaPictureDataSourceImpl(this.dio);

  @override
  Future<List<NasaPictureEntity>> getData(int page) async {
    DateTime endDate = DateTime.now();

    DateTime startDate = endDate.subtract(Duration(days: 15 * page));

    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

    final url =
        'https://api.nasa.gov/planetary/apod?api_key=01TCw2u3fDTduBASpGuEfNighIUcIutFX3ZjGxhr&start_date=$formattedStartDate&end_date=$formattedEndDate';
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
