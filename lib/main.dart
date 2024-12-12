import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_flutter/mvvm/binding/initial_binding.dart';
import 'package:trip_flutter/mvvm/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      initialRoute: AppPages.init,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
    );
  }
}
