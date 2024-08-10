// ignore_for_file: file_names

import 'package:get/get.dart';
// height 683.42
//width    441.42

class Dimensions {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  static double pageView = screenHeight / 2.13;
  static double pageViewContainers = screenHeight / 3.10;
  static double pageViewTextController = screenHeight / 5.69;

//dynamic height for padding and margin
  static double height5 = screenHeight / 136.684;
  static double height10 = screenHeight / 70.34;
  static double height15 = screenHeight / 47.56;
  static double height20 = screenHeight / 36.17;
  static double height30 = screenHeight / 22.78;
  static double height45 = screenHeight / 15.83;

//dynamic width for padding and marging

  static double width10 = screenHeight / 70.34;
  static double width15 = screenHeight / 47.56;
  static double width20 = screenHeight / 36.17;
  static double width30 = screenHeight / 22.78;
  static double width45 = screenHeight / 15.83;

//fonts
  static double font16 = screenHeight / 42.71;
  static double font26 = screenHeight / 26.28;
  static double font20 = screenHeight / 36.17;

//radius
  static double radius15 = screenHeight / 47.56;
  static double radius20 = screenHeight / 36.17;
  static double radius30 = screenHeight / 22.78;

  // icon size
  static double iconSize24 = screenHeight / 28.46;
  static double iconSize16 = screenHeight / 42.71;

  //list view size
  // ignore: non_constant_identifier_names
  static double ListViewImgSize = screenWidth / 3.67;
  // ignore: non_constant_identifier_names
  static double ListViewTextContainerSize = screenWidth / 4.41;

  // popular food -
  static double popularFoodImgSize = screenHeight / 1.95;

  // bottom height - 120
  static double bottomHeightBar = screenHeight / 5.69;
  static double splashImg = screenHeight / 3.38;
}
