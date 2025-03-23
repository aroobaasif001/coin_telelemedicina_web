import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationsController extends GetxController {
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  // Load language from SharedPreferences (works in Web)
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('language');

    if (lang != null) {
      updateLanguage(lang, isInit: true);
    } else {
      updateLanguage('en', isInit: true); // Default to English
    }
  }

  // Update language and store preference
  Future<void> updateLanguage(String lang, {bool isInit = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang); // Save selected language in storage

    if (lang == 'en') {
      Get.updateLocale(const Locale('en'));
      selectedLanguage.value = 'English';
    } else if (lang == 'es') {
      Get.updateLocale(const Locale('es'));
      selectedLanguage.value = 'Spanish';
    }

    if (!isInit) update(); // Only refresh UI when language is changed manually
  }
}
