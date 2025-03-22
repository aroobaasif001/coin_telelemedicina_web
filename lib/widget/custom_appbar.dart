import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final bool isLeading;
  
  const CustomAppbar({super.key,
    this.title = 'Doctor Screen',  this.isLeading = false});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
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
           Row(
             children: [
               if (isLeading)
                 IconButton(
                     onPressed: () {
                       Navigator.pop(context);
                     },
                     icon: Icon(Icons.arrow_back)),
               CustomText(text: title),
             ],
           ),
          Row(
            spacing: 5,
            children: [
              CustomText(text: 'Admin@gmail.com'),
              CircleAvatar(radius: 25)
            ],
          ),
        ],
      ),
    );
  }
}
