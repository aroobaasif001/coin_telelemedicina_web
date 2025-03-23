import 'package:coin_telelemedicina_web/translate/controller/translations_controller.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TranslationsController controller = Get.find<TranslationsController>();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Title
            Text(
              "Admin Panel - Telemedicine App",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Right Section: Admin Email + Profile
            Row(
              spacing: 10,
              children: [
                Text(
                  "admin@email.com",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                PopupMenuButton<String>(
                  child: Obx(() => Text(
                    controller.selectedLanguage.value == 'en' ? 'English' : 'Spanish', // Display selected language
                    style: TextStyle(color: Colors.black),
                  )),
                  onSelected: (String value) {
                    controller.updateLanguage(value); // Update language
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'en',
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Colors.black),
                          SizedBox(width: 8),
                          Text('English'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'es',
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Spanish'),
                        ],
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text("A", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}