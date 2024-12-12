import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:trip_flutter/mvvm/login/bindings/binding.dart';
import 'package:trip_flutter/mvvm/main/binding/main_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    MainBinding().dependencies();
    LoginBinding().dependencies();
  }
}
