import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mysql1/mysql1.dart';
import 'package:noteapp/Auth/Functions.dart';
import 'package:noteapp/Utils/AppColor.dart';
import 'package:noteapp/Utils/AppTextfields.dart';
import 'package:noteapp/Utils/bigText.dart';
import 'package:noteapp/Utils/snackBar.dart';
import 'package:noteapp/routes/route.dart';

import '../GuestUser/AddForm.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserController userController = Get.put(UserController());
  bool isLoading = false;

  Future<void> sendUserDataToMySQL() async {
    String userId = userController.user.value!.id.toString();

    final box = Hive.box('person');
    final connection = await MySqlConnection.connect(ConnectionSettings(
      host: '100.100.55.20',
      port: 13306,
      user: 'root',
      password: '123',
      db: 'noteapp',
    ));

    for (int i = 0; i < box.length; i++) {
      final personData = box.getAt(i) as Person;

      await connection.query(
        'INSERT INTO notes (name, description, color, user_id) VALUES (?, ?, ?, ?)',
        [personData.name, personData.description, personData.color, userId],
      );
    }

    await connection.close();
  }

  void registration(UserController userController) {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty) {
      showCustomSnackBar(
        "Type in your name",
        title: "Name",
      );
    } else if (email.isEmpty) {
      showCustomSnackBar(
        "Type in your email address",
        title: "Email address",
      );
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar(
        "Type in your valid email address",
        title: "Valid Email address",
      );
    } else if (password.isEmpty) {
      showCustomSnackBar(
        "Type in your password",
        title: "Password",
      );
    } else if (password.length < 6) {
      showCustomSnackBar(
        "Password cannot be less than six characters",
        title: "Password",
      );
    } else {
      setState(() {
        isLoading = true;
      });
      userController.registerUser(name, email, password).then((success) {
        setState(() {
          isLoading = false;
        });
        if (success) {
          sendUserDataToMySQL();
          Get.offNamed(RouteHelper.getInitial());
        } else {
          showCustomSnackBar(
            "Registration failed. Please try again later.",
            title: "Registration",
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.050,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.23,
                      child: const Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/1.jpg"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.032,
                    ),
                    AppTextField(
                      textController: emailController,
                      hintText: "Email",
                      icon: Icons.email,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.01,
                    ),
                    AppTextField(
                      textController: passwordController,
                      hintText: "Password",
                      isObsecure: true,
                      icon: Icons.password_sharp,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.01,
                    ),
                    AppTextField(
                      textController: nameController,
                      hintText: "Name",
                      icon: Icons.person,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.01,
                    ),
                    TextButton(
                      onPressed: () async {
                        registration(userController);
                      },
                      child: Container(
                        width: mediaQuery.size.width / 2,
                        height: mediaQuery.size.height / 13,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: mediaQuery.size.width * 0.025,
                              spreadRadius: mediaQuery.size.width * 0.0075,
                              offset: const Offset(2, 1),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(
                              mediaQuery.size.width * 0.1),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: BigText(
                            text: "Sign Up",
                            color: Colors.black,
                            size: mediaQuery.size.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.015,
                    ),
                    RichText(
                      text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.back(),
                        text: "Have an account already?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: mediaQuery.size.width * 0.05),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.015,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Sign up using one of the following methods",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: mediaQuery.size.width * 0.04),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
