import 'package:dio/dio.dart';
import 'package:nasa_picture/env.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:intl/intl.dart';

mixin NasaPictureDataSource {
  Future<List<NasaPictureEntity>> getData(int page);
}

class NasaPictureDataSourceImpl implements NasaPictureDataSource {
  final Dio dio;
  late List<NasaPictureEntity> cachedData;

  NasaPictureDataSourceImpl(this.dio) {
    cachedData = [];
  }

  @override
  Future<List<NasaPictureEntity>> getData(int page) async {
    if (page == 1) {
      cachedData.clear();
    }

    const int subtractDate = 10;

    DateTime endDate = DateTime.now().subtract(Duration(days: (page - 1) * subtractDate));
    DateTime startDate = endDate.subtract(const Duration(days: subtractDate));

    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

    final baseUrl = EnvImpl().baseUrl;
    final url = '$baseUrl&start_date=$formattedStartDate&end_date=$formattedEndDate';

    try {
      final response = await dio.get(url);

      final List<NasaPictureDto> nasaPictureList =
          List<NasaPictureDto>.from(response.data.map((item) => NasaPictureDto.fromJson(item)));

      final Set<String> urlSet = Set<String>.from(cachedData.map((e) => e.url));

      for (var dto in nasaPictureList) {
        if (!urlSet.contains(dto.url)) {
          cachedData.add(NasaPictureEntity(
            url: dto.url,
            title: dto.title,
            explanation: dto.explanation,
            date: dto.date,
          ));
        }
      }

      cachedData.sort((a, b) => b.date!.compareTo(a.date!));

      return List<NasaPictureEntity>.from(cachedData);
    } catch (e) {
      throw Exception(e);
    }
  }
}
