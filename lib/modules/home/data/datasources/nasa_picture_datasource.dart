import 'package:dio/dio.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:intl/intl.dart';

mixin NasaPictureDataSource {
  Future<List<NasaPictureEntity>> getData(int page);
}

class NasaPictureDataSourceImpl implements NasaPictureDataSource {
  final Dio dio;
  List<NasaPictureEntity> cachedData = [];

  NasaPictureDataSourceImpl(this.dio);

  DateTime parseDate(String dateStr) => DateTime.parse(dateStr);

  int compareByDate(NasaPictureEntity a, NasaPictureEntity b) {
    final aDate = a.date;
    final bDate = b.date;

    if (aDate == null && bDate == null) {
      return 0;
    } else if (aDate == null) {
      return 1;
    } else if (bDate == null) {
      return -1;
    } else {
      return parseDate(bDate).compareTo(parseDate(aDate));
    }
  }

  @override
  Future<List<NasaPictureEntity>> getData(int page) async {
    if (page == 1) {
      cachedData.clear();
    }

    const int subtractDate = 10;

    DateTime endDate =
        DateTime.now().subtract(Duration(days: (page - 1) * subtractDate));
    DateTime startDate = endDate.subtract(Duration(days: subtractDate));

    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

    final url =
        'https://api.nasa.gov/planetary/apod?api_key=01TCw2u3fDTduBASpGuEfNighIUcIutFX3ZjGxhr&start_date=$formattedStartDate&end_date=$formattedEndDate';

    try {
      final response = await dio.get(url);

      final List<NasaPictureDto> nasaPictureList = List<NasaPictureDto>.from(
          response.data.map((item) => NasaPictureDto.fromJson(item)));

      for (var dto in nasaPictureList) {
        if (!cachedData.any((cachedItem) => cachedItem.url == dto.url)) {
          cachedData.add(NasaPictureEntity(
            url: dto.url,
            title: dto.title,
            explanation: dto.explanation,
            date: dto.date,
          ));
        }
      }

      cachedData.sort(compareByDate);

      return List<NasaPictureEntity>.from(cachedData);
    } catch (e) {
      throw Exception(e);
    }
  }
}
