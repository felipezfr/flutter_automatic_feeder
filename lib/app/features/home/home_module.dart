import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';

import 'data/repositories/home_repository_impl.dart';
import 'interactor/controller/home_controller.dart';
import 'interactor/repositories/i_home_repository.dart';
import 'ui/home_page.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IHomeRepository>(HomeRepositoryImpl.new);
    i.addLazySingleton(HomeController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}
