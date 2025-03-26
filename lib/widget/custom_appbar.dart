import 'package:coin_telelemedicina_web/translate/controller/translations_controller.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final bool isLeading;

  const CustomAppbar({
    super.key,
    this.title = 'Doctor Screen',
    this.isLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    TranslationsController controller = Get.find<TranslationsController>();

    return CustomContainer(
      conColor: Colors.white,
      borderRadius: BorderRadius.circular(15),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 5,
        )
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isLeading)
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              CustomText(text: title),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              CustomText(text: 'Admin@gmail.com'),
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
              CircleAvatar(radius: 25),
            ],
          ),
        ],
      ),
    );
  }
}