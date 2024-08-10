// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/GuestUser/AddForm.dart';
import 'package:noteapp/GuestUser/editNote.dart';
import 'package:noteapp/main.dart';
import 'package:noteapp/routes/route.dart';
import 'package:staggered_grid_view_flutter/rendering/sliver_staggered_grid.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
        child: const AddPersonForm(),
      ),
    );
  }
}

class InfoScreen extends StatefulWidget {
  InfoScreen({
    super.key,
  });

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final ThemeController themeController = Get.find();
  late final Box contactBox;

  @override
  void initState() {
    super.initState();
    contactBox = Hive.box('persons');
  }

  Widget _buildItem(BuildContext context, double screenWidth) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Guest User'),
        actions: [
          IconButton(
            icon: Icon(
              themeController.isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              if (themeController.isDark) {
                themeController.lightTheme();
              } else {
                themeController.darkTheme();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                Container(
                  height: mediaQuery.size.height * 0.2,
                  padding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.05,
                      horizontal: mediaQuery.size.width * 0.1),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(mediaQuery.size.width * 0.05),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: mediaQuery.size.width * 0.02,
                        spreadRadius: mediaQuery.size.width * 0.005,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guest User',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.008),
                      Text(
                        'guest@example.com',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(mediaQuery.size.width * 0.05),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: mediaQuery.size.width * 0.02,
                        spreadRadius: mediaQuery.size.width * 0.005,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Get.offNamed(RouteHelper.getSignInPage());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddScreen(),
          ),
        ),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: StaggeredGridView.builder(
        gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          staggeredTileCount: contactBox.length,
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
        ),
        itemCount: contactBox.length,
        itemBuilder: (BuildContext context, int index) {
          var personData = contactBox.getAt(index) as Person;

          String colorHex = personData.color;
          print('Retrieved color from Hive: $colorHex');
          colorHex = colorHex.replaceAll('#', '');
          if (colorHex.length != 6) {
            colorHex = 'FFFFFF';
          }

          final int hexColor = int.parse(colorHex, radix: 16);
          final Color noteColor = Color(0xFF000000 | hexColor);

          String colorText = personData.textcolor;
          print('Retrieved color from Hive: $colorText');
          colorText = colorText.replaceAll('#', '');
          if (colorText.length != 6) {
            colorText = 'FFFFFF';
          }

          final int textColor = int.parse(colorText, radix: 16);
          final Color noteTextColor = Color(0xFF000000 | textColor);

          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CardDetailScreen(
                        index: index,
                        person: personData,
                      )),
            ),
            child: Padding(
              padding: EdgeInsets.all(mediaQuery.size.width * 0.02),
              child: Container(
                decoration: BoxDecoration(
                  color: noteColor,
                  borderRadius:
                      BorderRadius.circular(mediaQuery.size.width * 0.090),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: mediaQuery.size.width * 0.02,
                      spreadRadius: mediaQuery.size.width * 0.005,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        personData.name,
                        style: TextStyle(
                          color: noteTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      personData.description,
                      style: TextStyle(color: noteTextColor),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;

    return ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, box, widget) {
          return Column(
            children: [
              Expanded(
                child: _buildItem(context, screenWidth),
              ),
            ],
          );
        });
  }
}

class CardDetailScreen extends StatefulWidget {
  final Person person;
  final int index;

  CardDetailScreen({
    required this.person,
    required this.index,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late final Box contactBox;

  @override
  void initState() {
    super.initState();
    contactBox = Hive.box('persons');
  }

  _deleteInfo(int index) {
    contactBox.deleteAt(index);
    Navigator.pop(context);
  }

  Widget _buildItem(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    String colorHex = widget.person.color;
    colorHex = colorHex.replaceAll('#', '');
    if (colorHex.length != 6) {
      colorHex = 'FFFFFF';
    }

    final int hexColor = int.parse(colorHex, radix: 16);
    final Color noteColor = Color(0xFF000000 | hexColor);

    String colorText = widget.person.textcolor;
    colorText = colorText.replaceAll('#', '');
    if (colorText.length != 6) {
      colorText = 'FFFFFF';
    }

    final int TextColor = int.parse(colorText, radix: 16);
    final Color noteTextColor = Color(0xFF000000 | TextColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => _deleteInfo(widget.index),
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UpdateScreen(
                  index: widget.index,
                  person: widget.person,
                ),
              ));
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: noteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: mediaQuery.size.width * 0.0125,
              spreadRadius: mediaQuery.size.width * 0.003125,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Name',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.0125,
            ),
            Text(
              widget.person.name,
              style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: noteTextColor),
            ),
            SizedBox(height: mediaQuery.size.height * 0.025),
            const Text(
              'Note',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.0125,
            ),
            Text(
              widget.person.description,
              style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.045,
                  color: noteTextColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, box, widget) {
          return _buildItem(context);
        },
      ),
    );
  }
}
