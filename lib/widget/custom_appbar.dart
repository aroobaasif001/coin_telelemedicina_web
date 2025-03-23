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
            children: [
              CustomText(text: 'Admin@gmail.com'),
              SizedBox(width: 10), // Add some spacing between the email and the avatar
              PopupMenuButton<String>(
                icon: Icon(Icons.language, color: Colors.black),
                onSelected: (String value) {
                  Get.updateLocale(Locale(value));
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
                        Text('Español'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10), // Add some spacing between the language button and the avatar
              CircleAvatar(radius: 25),
            ],
          ),
        ],
      ),
    );
  }
}