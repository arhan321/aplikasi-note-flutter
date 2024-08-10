import 'package:flutter/foundation.dart' show Key, kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteapp/Auth/Functions.dart';
import 'package:noteapp/Auth/SignUp.dart';
import 'package:noteapp/Utils/AppColor.dart';
import 'package:noteapp/Utils/AppTextfields.dart';
import 'package:noteapp/Utils/bigText.dart';
import 'package:noteapp/routes/route.dart';
import 'package:noteapp/Utils/snackBar.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late UserController _userController;

  @override
  void initState() {
    super.initState();
    _userController = Get.put(UserController());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(mediaQuery.size.width * 0.015),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: mediaQuery.size.height * 0.23,
                          child: Center(
                            child: CircleAvatar(
                              radius: mediaQuery.size.width * 0.2,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage("assets/1.jpg"),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: mediaQuery.size.width * 0.05),
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello",
                                style: TextStyle(
                                  fontSize: mediaQuery.size.width * 0.12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Sign into your account",
                                style: TextStyle(
                                  fontSize: mediaQuery.size.width * 0.05,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.02,
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
                          height: mediaQuery.size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Sign into your account",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: mediaQuery.size.width * 0.05),
                              ),
                            ),
                            SizedBox(
                              width: mediaQuery.size.width * 0.05,
                            )
                          ],
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() {});
                              bool success = await _userController.login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (success) {
                                Get.offNamed(RouteHelper.getInitial());
                                if (kDebugMode) {
                                  print('Login successful');
                                }
                              } else {
                                showCustomSnackBar(
                                  "Invalid email or password",
                                  title: "Login failed",
                                );
                              }
                            }
                          },
                          child: Container(
                            width: mediaQuery.size.width / 2,
                            height: mediaQuery.size.height / 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  mediaQuery.size.width * 0.1),
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
                            child: Center(
                              child: BigText(
                                text: "Sign In",
                                color: AppColor.mainBlackColor,
                                size: mediaQuery.size.width * 0.06,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offNamed(RouteHelper.guestInitial());
                          },
                          child: Container(
                            width: mediaQuery.size.width / 2,
                            height: mediaQuery.size.height / 16,
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
                                text: "Guest User",
                                color: AppColor.mainBlackColor,
                                size: mediaQuery.size.width * 0.06,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.02,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: mediaQuery.size.width * 0.05),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.to(() => const SignUp(),
                                        transition: Transition.fade),
                                  text: " Create",
                                  style: TextStyle(
                                      color: AppColor.mainBlackColor,
                                      fontSize: mediaQuery.size.width * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
