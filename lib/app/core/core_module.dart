import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addInstance(FirebaseDatabase.instance);
  }
}
