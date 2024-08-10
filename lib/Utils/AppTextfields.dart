import 'package:flutter/material.dart';
import 'package:noteapp/Utils/AppColor.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final bool isObsecure;

  AppTextField({
    super.key,
    required this.hintText,
    this.isObsecure = false,
    required this.icon,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mediaQuery.size.width * 0.075),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: mediaQuery.size.width * 0.025,
            spreadRadius: mediaQuery.size.width * 0.0075,
            offset: const Offset(2, 1),
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
      child: TextField(
        obscureText: isObsecure,
        controller: textController,
        style: TextStyle(color: AppColor.mainBlackColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(
            icon,
            color: AppColor.mainBlackColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mediaQuery.size.width * 0.1),
            borderSide: const BorderSide(
              width: 1.0,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mediaQuery.size.width * 0.075),
            borderSide: const BorderSide(
              width: 1.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
