import 'package:flutter/material.dart';


class AppColor {
  static Color primary = Color(0xff147769);
   static Color cyanColor = Color(0xff00b5d7);
    static Color whiteColor = Color.fromARGB(255, 255, 255, 255);
    static Color greenColor = Colors.green;
    static Color redColor =   Colors.red;


// Define a gradient using primary color and a variation
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,

    colors: [
      primary.withOpacity(0.5),
      primary.withOpacity(0.8),
      primary,
      Color(0xff0f5b4d), // A darker shade to create contrast
    ],
  );

}