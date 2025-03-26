import 'package:coin_telelemedicina_web/controller/HomeController.dart';
import 'package:coin_telelemedicina_web/translate/controller/translations_controller.dart';
import 'package:coin_telelemedicina_web/translate/translations_app.dart';
import 'package:coin_telelemedicina_web/view/auth/login_screen.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/view/screens/disabalityScreens/controller/disbality_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize controllers
  Get.lazyPut(() => HomeController());
  Get.put(DisabilityController());

  final translationsController = Get.put(TranslationsController());
  await translationsController.loadLanguage(); // Load saved language

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final translationsController = Get.find<TranslationsController>();

    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      translations: TranslationsApp(),
      locale: translationsController.selectedLanguage.value == 'en'
          ? const Locale('en')
          : const Locale('es'),
      fallbackLocale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
      home: HomeScreen(),
    );
  }
}