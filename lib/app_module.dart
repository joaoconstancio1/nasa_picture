import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_picture/modules/home/ui/home_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (context, args) => const HomePage()),
  ];
}
