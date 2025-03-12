import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'app_colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLeading;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.isLeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 60,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leadingWidth: 52,
      leading: isLeading
          ? Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 12,
                bottom: 12,
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                constraints: const BoxConstraints(
                  minHeight: 32,
                  minWidth: 32,
                ),
                padding: EdgeInsets.zero,
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0XFFF7F1F1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    "assets/images/img_frame_1000004609.svg",
                  ),
                ),
              ),
            )
          : SizedBox(),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}