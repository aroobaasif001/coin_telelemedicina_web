import 'package:coin_telelemedicina_web/controller/HomeController.dart';
import 'package:coin_telelemedicina_web/translate/translations_app.dart';
import 'package:coin_telelemedicina_web/view/auth/login_screen.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  Get.lazyPut(()=> HomeController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
        translations: TranslationsApp(),
        locale: Get.deviceLocale ?? Locale('en'),
        fallbackLocale: Locale('en'),
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
      //LoginScreen(),
    );
  }
}
