import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_store.dart';
import 'package:nasa_picture/modules/home/data/datasources/nasa_picture_datasource.dart';
import 'package:nasa_picture/modules/home/data/dto/nasa_picture_dto.dart';
import 'package:nasa_picture/modules/home/data/services/nasa_picture_service.dart';
import 'package:nasa_picture/modules/home/domain/usecases/nasa_picture_usecase.dart';
import 'package:nasa_picture/modules/home/ui/details_page.dart';
import 'package:nasa_picture/modules/home/ui/home_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => NasaPictureDataSourceImpl()),
    Bind((i) => NasaPictureDto()),
    Bind((i) => NasaPictureUsecaseImp(i())),
    Bind((i) => NasaPictureServiceImpl(i())),
    Bind((i) => NasaPictureStore(i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (context, args) => HomePage(
        store: context.read(),
      ),
    ),
    ChildRoute(
      '/details',
      child: (context, args) => DetailsPage(entity: args.data),
    ),
  ];
}
