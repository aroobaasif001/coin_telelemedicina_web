import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationsController extends GetxController {
  RxString selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  // Load language from SharedPreferences
  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString('selectedLanguage') ?? 'en';
    selectedLanguage.value = savedLang;
    Get.updateLocale(Locale(savedLang));
  }

  // Update language and store preference
  Future<void> updateLanguage(String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', langCode);
    selectedLanguage.value = langCode;
    Get.updateLocale(Locale(langCode));
  }
}