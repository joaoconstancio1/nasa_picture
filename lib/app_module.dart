import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/home/data/datasources/nasa_picture_datasource.dart';
import 'modules/home/data/dto/nasa_picture_dto.dart';
import 'modules/home/data/repositories/nasa_picture_repository_impl.dart';
import 'modules/home/domain/usecases/nasa_picture_usecase.dart';
import 'modules/home/presenter/pages/details_page.dart';
import 'modules/home/presenter/pages/home_page.dart';
import 'modules/home/presenter/stores/nasa_picture_store.dart';

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
