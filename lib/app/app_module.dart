import 'package:flutter_modular/flutter_modular.dart';

import 'core/core_module.dart';
import 'features/home/home_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
  }
}
