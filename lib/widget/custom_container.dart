import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? conColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final DecorationImage? image;
  final BoxBorder? border;
  final BoxShape shape;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.conColor,
    this.borderRadius,
    this.child,
    this.image,
    this.border,
    this.shape = BoxShape.rectangle,
    this.alignment,
    this.boxShadow,
    this.gradient,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      height: height,
      width: width,
      decoration: BoxDecoration(
          gradient: gradient,
          image: image,
          color: conColor,
          borderRadius: borderRadius,
          shape: shape,
          border: border,
          boxShadow: boxShadow),
      child: child,
    );
  }
}
