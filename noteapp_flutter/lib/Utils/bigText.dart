import 'package:flutter/material.dart';
import 'package:noteapp/Utils/dimensions.dart';

// ignore: must_be_immutable
class BigText extends StatelessWidget {
  BigText({
    super.key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.overFlow = TextOverflow.ellipsis,
    this.size = 20,
  });
  final Color color;
  final String text;
  double size;
  TextOverflow overFlow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? Dimensions.font20 : size,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
