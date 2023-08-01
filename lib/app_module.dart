import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_store.dart';
import 'package:nasa_picture/modules/home/data/datasources/nasa_picture_datasource.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/data/repositories/nasa_picture_repository_impl.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';
import 'package:nasa_picture/modules/home/ui/details_page.dart';
import 'package:nasa_picture/modules/home/ui/home_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => Dio()),
    Bind((i) => NasaPictureDataSourceImpl(i())),
    Bind((i) => NasaPictureDto()),
    Bind((i) => NasaPictureUsecaseImp(i())),
    Bind((i) => NasaPictureRepositoryImpl(i())),
    Bind((i) => NasaPictureStore(i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (context, args) => const HomePage(),
    ),
    ChildRoute(
      '/details',
      child: (context, args) => DetailsPage(entity: args.data),
    ),
  ];
}
