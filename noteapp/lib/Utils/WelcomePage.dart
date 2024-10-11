import 'package:flutter/material.dart';
import 'package:animated_introduction/animated_introduction.dart';
import 'package:get/get.dart';
import 'package:noteapp/routes/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to NotesApp",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset("assets/2.png"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('hasSeenWelcomeScreen', true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeUI(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: mediaQuery.size.width * 0.015625,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(mediaQuery.size.width * 0.025),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Get Started"),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    title: 'Welcome to the Note App!',
    description:
        'Organize your life with the Note App. Easily add, edit, and delete notes. Sign up to save your data and access it across devices.',
    imageAsset: 'assets/3.jpg',
  ),
  const SingleIntroScreen(
    title: 'Add and Edit Notes',
    description:
        'Create new notes and edit existing ones with ease. The Note App helps you keep track of important information.',
    imageAsset: 'assets/4.jpg',
  ),
  const SingleIntroScreen(
    title: 'Delete and Save',
    description:
        'Need to remove a note? No problem. Delete notes when you no longer need them. Sign up to save your data securely.',
    imageAsset: 'assets/5.jpg',
  ),
];

/// Example page
class WelcomeUI extends StatelessWidget {
  const WelcomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
      slides: pages,
      indicatorType: IndicatorType.circle,
      onDone: () {
        Get.toNamed(RouteHelper.getSignInPage());
      },
    );
  }
}
