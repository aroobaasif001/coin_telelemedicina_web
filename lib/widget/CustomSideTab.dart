import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'CustomText.dart';
import 'custom_container.dart';

class CustomSideTab extends StatelessWidget {
  final bool isSelectedTap;
  final String iconPath;
  final String text;
  final void Function()? onTap;
  const CustomSideTab({super.key,
    required this.isSelectedTap,
    required this.iconPath, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 60,
      conColor: isSelectedTap ? AppTheme.primaryColor : Colors.transparent,
      borderRadius: isSelectedTap
          ? BorderRadius.circular(100)
          : BorderRadius.circular(0),
      child: Center(
        child: ListTile(
          leading: Image(
            height: 30,
            width: 30,
            color: isSelectedTap
                ? Colors.white
                : Colors.black.withOpacity(.6),
            image: AssetImage(iconPath),
          ),
          title: CustomText(
            text: text,
            fontFamily: 'Poppins',
            fontSize: isSelectedTap?18:14,
            fontWeight: FontWeight.w500,
            color: isSelectedTap
                ? Colors.white
                : Colors.black.withOpacity(.6),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}