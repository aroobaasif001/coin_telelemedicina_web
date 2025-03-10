import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          conColor: Colors.white,
          borderRadius: BorderRadius.circular(15),
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
            )
          ],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: 'Doctor'),
              Row(
                children: [
                  CustomText(text: 'Admin@gmail.com'),
                  CircleAvatar(radius: 25)
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
