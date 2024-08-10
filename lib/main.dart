import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/GuestUser/AddForm.dart';
import 'package:noteapp/routes/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth/Functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool hasSeenWelcomeScreen = prefs.getBool('hasSeenWelcomeScreen') ?? false;

  if (!hasSeenWelcomeScreen) {
    await Hive.initFlutter();
    Hive.registerAdapter(PersonAdapter());
    await Hive.openBox('persons');
    final themeController = Get.put(ThemeController());
    await themeController.loadThemePreference();
    Get.put(UserController());
    Get.put(Themecontroller());
    runApp(WelcomeApp());
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(PersonAdapter());
    await Hive.openBox('persons');
    final themeController = Get.put(ThemeController());
    await themeController.loadThemePreference();
    Get.put(UserController());
    Get.put(Themecontroller());
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  final Themecontroller _themeController = Get.put(Themecontroller());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: _themeController.isDark ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: _determineInitialRoute(),
      getPages: RouteHelper.routes,
    );
  }

  String _determineInitialRoute() {
    final UserController userController = Get.find();
    final User? user = userController.user.value;

    if (user != null) {
      return RouteHelper.initial;
    } else {
      return RouteHelper.getSignInPage();
    }
  }
}

class ThemeController extends GetxController {
  final String _themeBoxName = 'theme';

  bool isDark = true;

  void lightTheme() {
    isDark = false;
    update();
    _saveThemePreference();
    Get.changeTheme(ThemeData.light());
  }

  void darkTheme() {
    isDark = true;
    update();
    _saveThemePreference();
    Get.changeTheme(ThemeData.dark());
  }

  Future<void> _saveThemePreference() async {
    final themeBox = await Hive.openBox(_themeBoxName);
    await themeBox.put('isDark', isDark);
  }

  Future<void> loadThemePreference() async {
    final themeBox = await Hive.openBox(_themeBoxName);
    final bool? storedIsDark = themeBox.get('isDark');
    if (storedIsDark != null) {
      isDark = storedIsDark;
      update();
      Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());
    }
  }
}

class WelcomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteHelper.welcome,
      getPages: RouteHelper.routes,
    );
  }
}
