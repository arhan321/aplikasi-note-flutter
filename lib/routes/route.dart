import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:noteapp/Auth/AddNote.dart';
import 'package:noteapp/Auth/SignIn.dart';
import 'package:noteapp/GuestUser/GuestPage.dart';
import 'package:noteapp/Utils/WelcomePage.dart';

class RouteHelper {
  static const String initial = "/";

  static const String guestinitial = "/guest";
  static const String signIn = "/sign-in";

  static const String welcome = "/welcomePage";
  static String welcomePage() => welcome;
  static String guestInitial() => guestinitial;
  static String getInitial() => initial;
  static String getSignInPage() => signIn;

  static List<GetPage> routes = [
    GetPage(
        name: welcome, page: () => WelcomePage(), transition: Transition.fade),
    GetPage(
        name: guestinitial,
        page: () => InfoScreen(),
        transition: Transition.fade),
    GetPage(name: initial, page: () => Home(), transition: Transition.fade),
    GetPage(
        name: signIn, page: () => const SignIn(), transition: Transition.fade),
  ];
}
