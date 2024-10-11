import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:noteapp/Auth/AddNote.dart';
import 'package:noteapp/Utils/snackBar.dart';
import 'package:noteapp/routes/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themecontroller extends GetxController {
  bool isDark = true;

  void lightTheme() {
    isDark = false;
    update();
    Get.changeTheme(ThemeData.light());
  }

  void darkTheme() {
    isDark = true;
    update();
    Get.changeTheme(ThemeData.dark());
  }
}

class User {
  final int? id;
  final String name;
  final String email;
  String? sinceMember;

  User({
    this.id,
    required this.name,
    required this.email,
    this.sinceMember,
  });
}

class UserController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  int nextId = 1;

  Future<MySqlConnection> connectToDatabase() async {
    final settings = ConnectionSettings(
      host: '100.100.55.20',
      port: 13306,
      user: 'root',
      password: '123',
      db: 'noteapp',
    );

    await Future.delayed(const Duration(milliseconds: 100));

    final connection = await MySqlConnection.connect(settings);
    return connection;
  }

  Future<bool> registerUser(String name, String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await connectToDatabase();
      var now = DateTime.now();
      var formattedDate = DateFormat('yyyy-MM-dd').format(now);

      var insertResult = await conn.query(
        'INSERT INTO users (name, email, password, since_member) VALUES (?, ?, ?, ?)',
        [name, email, password, formattedDate],
      );

      if (insertResult.affectedRows == 0) {
        return false;
      }

      var userId = insertResult.insertId;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', userId.toString());
      prefs.setString('name', name);
      prefs.setString('email', email);

      user.value = User(
        id: userId,
        name: name,
        email: email,
        sinceMember: formattedDate,
      );

      await Future.wait<dynamic>([]);

      Get.offNamed(RouteHelper.getInitial());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting user data: $e');
      }
      return false;
    } finally {
      await conn?.close();
    }
  }

  Future<bool> login(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await connectToDatabase();

      var results = await conn.query(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [email, password],
      );

      if (results.isEmpty) {
        showCustomSnackBar(
          "Incorrect email or password",
          title: "Log In",
        );
        return false;
      } else if (email.isEmpty) {
        showCustomSnackBar(
          "Type in your email address",
          title: "Email address",
        );
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar(
          "Type in your Valid email address",
          title: "Valid Email address",
        );
      } else if (password.isEmpty) {
        showCustomSnackBar(
          "Type in your password",
          title: "Password",
        );
      }
      var userData = results.first;
      var userId = userData['id'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', userId.toString());
      prefs.setString('name', userData['name']);
      prefs.setString('email', userData['email']);
      String sinceMemberString = userData['since_member']?.toString() ?? '';

      prefs.setString('since_member', sinceMemberString);

      user.value = User(
        id: userId,
        name: userData['name'],
        email: userData['email'],
        sinceMember: sinceMemberString,
      );

      await Future.wait([]);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in: $e');
      }
      return false;
    } finally {
      await conn?.close();
    }
  }

  void logOut() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('name');
      prefs.remove('email');
      prefs.remove('sinceMember');
    });

    user.value = null;
  }

  String? userSelectedColor;
  Future<String?> getUserSelectedTextColor() async {
    final connection = await DatabaseManager().getConnection();

    try {
      final results = await connection
          .query('SELECT textcolor FROM users WHERE id = ?', [user.value!.id]);
      if (results.isNotEmpty) {
        userSelectedColor = results.first['color'] as String?;
      }
    } catch (e) {
      print('Error fetching user selected color: $e');
    } finally {
      await connection.close();
    }

    return userSelectedColor;
  }

  Future<void> updateUserSelectedTextColor(String color) async {
    final connection = await DatabaseManager().getConnection();

    try {
      await connection.query('UPDATE users SET textcolor = ? WHERE id = ?',
          [color, user.value!.id]);
      userSelectedColor = color;
    } catch (e) {
      print('Error updating user selected color: $e');
    } finally {
      await connection.close();
    }
  }

  Future<String?> getUserSelectedColor() async {
    final connection = await DatabaseManager().getConnection();

    try {
      final results = await connection
          .query('SELECT color FROM users WHERE id = ?', [user.value!.id]);
      if (results.isNotEmpty) {
        userSelectedColor = results.first['color'] as String?;
      }
    } catch (e) {
      print('Error fetching user selected color: $e');
    } finally {
      await connection.close();
    }

    return userSelectedColor;
  }

  Future<void> updateUserSelectedColor(String color) async {
    final connection = await DatabaseManager().getConnection();

    try {
      await connection.query(
          'UPDATE users SET color = ? WHERE id = ?', [color, user.value!.id]);
      userSelectedColor = color;
    } catch (e) {
      print('Error updating user selected color: $e');
    } finally {
      await connection.close();
    }
  }

  Future<int> userThemePreference() async {
    final connection = await DatabaseManager().getConnection();
    int themePreference = 0;

    try {
      final results = await connection.query(
          'SELECT theme_preference FROM users WHERE id = ? ', [user.value!.id]);
      if (results.isNotEmpty) {
        themePreference = results.first['theme_preference'] as int;
      }
    } catch (e) {
    } finally {
      await connection.close();
    }

    return themePreference;
  }

  Future<void> updateUserThemePreference(int themePreference) async {
    final connection = await DatabaseManager().getConnection();

    try {
      await connection.query(
          'UPDATE users SET theme_preference = ? WHERE id = ?',
          [themePreference, user.value!.id]);
    } catch (e) {
      print('Error updating theme preference: $e');
    } finally {
      await connection.close();
    }
  }

  @override
  void onInit() {
    super.onInit();
    SharedPreferences.getInstance().then((prefs) async {
      final idString = prefs.getString('id');
      final name = prefs.getString('name');
      final email = prefs.getString('email');
      final sinceMember = prefs.getString('since_member') ?? '';

      if (idString != null && name != null && email != null) {
        final id = int.tryParse(idString);
        if (id != null) {
          user.value = User(
            id: id,
            name: name,
            email: email,
            sinceMember: sinceMember,
          );
        }
      }
    });
  }
}
