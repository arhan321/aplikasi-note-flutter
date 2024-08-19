import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:staggered_grid_view_flutter/rendering/sliver_staggered_grid.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:noteapp/Auth/DeleteNote.dart';
import 'package:noteapp/routes/route.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import 'Functions.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  Future<mysql.MySqlConnection> getConnection() async {
    final settings = mysql.ConnectionSettings(
      host: '103.127.96.16',
      port: 33306,
      user: 'root',
      password: '123',
      db: 'noteapp',
    );

    final connection = await mysql.MySqlConnection.connect(settings);
    return connection;
  }
}

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  Color selectedColor = Colors.white;

  Color selectedtextColor = Colors.black;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNotes = TextEditingController();

  Future<bool> addData() async {
    final UserController userController = Get.find<UserController>();
    if (userController.user.value == null) {
      return false;
    }

    final userId = userController.user.value!.id;
    final connection = await DatabaseManager().getConnection();

    try {
      final result = await connection.query(
        'INSERT INTO notes (name, description, color, textcolor, user_id) VALUES (?, ?, ?, ?, ?)',
        [
          controllerName.text,
          controllerNotes.text,
          selectedColor.value.toRadixString(16),
          selectedtextColor.value.toRadixString(16),
          userId,
        ],
      );

      if (result.affectedRows == 1) {
        _showSnackBar("Data added successfully");
        return true;
      } else {
        _showSnackBar("Failed to add data");
        return false;
      }
    } catch (e) {
      print('Error inserting data: $e');
      _showSnackBar("An error occurred");
      return false;
    } finally {
      await connection.close();
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTextColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a text color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedtextColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedtextColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Name'),
                SizedBox(height: mediaQuery.size.height * 0.025),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(mediaQuery.size.width * 0.025),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: mediaQuery.size.width * 0.0125,
                        spreadRadius: mediaQuery.size.width * 0.003125,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controllerName,
                    style: TextStyle(
                        fontSize: mediaQuery.size.width * 0.0375,
                        color: Colors.black),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: "Name",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.all(mediaQuery.size.width * 0.03),
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.05),
                const Text('Note'),
                SizedBox(height: mediaQuery.size.height * 0.025),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(mediaQuery.size.width * 0.025),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: mediaQuery.size.width * 0.0125,
                        spreadRadius: mediaQuery.size.width * 0.003125,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controllerNotes,
                    style: TextStyle(
                        fontSize: mediaQuery.size.width * 0.0375,
                        color: Colors.black),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: "Note",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.all(mediaQuery.size.width * 0.03),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(mediaQuery.size.width * 0.025)),
                ListTile(
                  title: Text(
                    'Select Color',
                    style: TextStyle(fontSize: mediaQuery.size.width * 0.0375),
                  ),
                  onTap: _showColorPicker,
                  trailing: Container(
                    width: mediaQuery.size.width * 0.075,
                    height: mediaQuery.size.width * 0.075,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: mediaQuery.size.width * 0.0125,
                          spreadRadius: mediaQuery.size.width * 0.003125,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Select Text Color',
                    style: TextStyle(fontSize: mediaQuery.size.width * 0.0375),
                  ),
                  onTap: _showTextColorPicker,
                  trailing: Container(
                    width: mediaQuery.size.width * 0.075,
                    height: mediaQuery.size.width * 0.075,
                    decoration: BoxDecoration(
                      color: selectedtextColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: mediaQuery.size.width * 0.0125,
                          spreadRadius: mediaQuery.size.width * 0.003125,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: mediaQuery.size.height * 0.0625,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          addData();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const Home();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          elevation: mediaQuery.size.width * 0.015625,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                mediaQuery.size.width * 0.025),
                          ),
                        ),
                        child: Text(
                          "Add Data",
                          style: TextStyle(
                              fontSize: mediaQuery.size.width * 0.0375,
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Themecontroller themeController;
  late UserController userController;

  @override
  void initState() {
    themeController = Get.put(Themecontroller());
    userController = Get.find<UserController>();
    _initializeTheme();
    super.initState();
  }

  Future<void> _initializeTheme() async {
    final themePreference = await userController.userThemePreference();
    if (themePreference == 1) {
      setState(() {
        themeController.darkTheme();
      });
    } else {
      setState(() {
        themeController.lightTheme();
      });
    }
  }

  Future<void> _toggleTheme() async {
    if (themeController.isDark) {
      setState(() {
        themeController.lightTheme();
      });
      await userController.updateUserThemePreference(0);
    } else {
      setState(() {
        themeController.darkTheme();
      });
      await userController.updateUserThemePreference(1);
    }
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final UserController userController = Get.find<UserController>();
    if (userController.user.value == null) {
      return [];
    }

    final userId = userController.user.value!.id;
    final connection = await DatabaseManager().getConnection();

    List<Map<String, dynamic>> dataList = [];

    try {
      final results = await connection
          .query('SELECT * FROM notes WHERE user_id = ?', [userId]);

      for (var row in results) {
        dataList.add(Map<String, dynamic>.from(row.fields));
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      await connection.close();
    }

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Obx(
      () => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddData(),
            ),
          ),
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ItemList(
                    list: snapshot.data!,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
        appBar: AppBar(
          title: const Center(
            child: Text(
              'My Notes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(
                themeController.isDark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        drawer: GetBuilder<UserController>(
          builder: (userController) {
            final User? user = userController.user.value;
            if (user != null) {
              return Drawer(
                backgroundColor: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: mediaQuery.size.height * 0.2,
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.size.height * 0.05,
                            horizontal: mediaQuery.size.width * 0.1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              mediaQuery.size.width * 0.025),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: mediaQuery.size.width * 0.0125,
                              spreadRadius: mediaQuery.size.width * 0.003125,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.size.height * 0.025,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              mediaQuery.size.width * 0.025),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: mediaQuery.size.width * 0.0125,
                              spreadRadius: mediaQuery.size.width * 0.003125,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            userController.logOut();
                            Get.offNamed(RouteHelper.signIn);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Drawer(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: mediaQuery.size.height * 0.15,
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.size.height * 0.1125,
                          horizontal: mediaQuery.size.width * 0.15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            mediaQuery.size.width * 0.025),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: mediaQuery.size.width * 0.0125,
                            spreadRadius: mediaQuery.size.width * 0.003125,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const UserAccountsDrawerHeader(
                        accountName: Text('Guest User'),
                        accountEmail: Text('guest@example.com'),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text(
                        'SignIn',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Get.offNamed(RouteHelper.getSignInPage());
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<Map<String, dynamic>> list;

  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return StaggeredGridView.builder(
      itemCount: list.length,
      gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        staggeredTileCount: list.length,
        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(context, list[index], mediaQuery);
      },
    );
  }

  Widget _buildItem(BuildContext context, Map<String, dynamic> item,
      MediaQueryData mediaQuery) {
    final String colorHex = _convertBlobToString(item['color']);
    final cleanColorHex =
        colorHex.startsWith('#') ? colorHex.substring(1) : colorHex;
    final Color noteColor =
        Color(int.parse(cleanColorHex, radix: 16) + 0xFF000000);

    final String colorText = _convertBlobToString(item['textcolor']);
    final cleanColorText =
        colorText.startsWith('#') ? colorText.substring(1) : colorText;
    final Color notetextColor =
        Color(int.parse(cleanColorText, radix: 16) + 0xFF000000);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => Detail(
            list: list,
            index: list.indexOf(item),
          ),
        ));
      },
      child: Padding(
        padding: EdgeInsets.all(mediaQuery.size.height * 0.01),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediaQuery.size.width * 0.1),
          ),
          color: noteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: noteColor,
                  borderRadius:
                      BorderRadius.circular(mediaQuery.size.width * 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: mediaQuery.size.width * 0.05,
                      spreadRadius: mediaQuery.size.width * 0.01,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: ListTile(
                    title: Center(
                      child: Text(item['name'],
                          style: TextStyle(
                            color: notetextColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    subtitle: Text(
                      item['description'],
                      style: TextStyle(color: notetextColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _convertBlobToString(dynamic blob) {
    if (blob is List<int>) {
      return String.fromCharCodes(blob);
    } else if (blob is String) {
      return blob;
    } else {
      throw ArgumentError('Unsupported Blob format');
    }
  }
}



// class ItemList extends StatelessWidget {
//   final List<Map<String, dynamic>> list;
//   ItemList({required this.list});

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);

//     return StaggeredGridView.builder(
//       itemCount: list.length,
//       gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         staggeredTileCount: list.length,
//         staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         return _buildItem(context, list[index], mediaQuery);
//       },
//     );
//   }

//   Widget _buildItem(BuildContext context, Map<String, dynamic> item,
//       MediaQueryData mediaQuery) {
//     final String colorHex = item['color'];
//     final cleanColorHex =
//         colorHex.startsWith('#') ? colorHex.substring(1) : colorHex;

//     final Color noteColor = Color(int.parse(cleanColorHex, radix: 16));

//     final String colorText = item['textcolor'];
//     final cleanColorText =
//         colorText.startsWith('#') ? colorText.substring(1) : colorText;

//     final Color notetextColor = Color(int.parse(cleanColorText, radix: 16));
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (BuildContext context) => Detail(
//             list: list,
//             index: list.indexOf(item),
//           ),
//         ));
//       },
//       child: Padding(
//         padding: EdgeInsets.all(mediaQuery.size.height * 0.01),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(mediaQuery.size.width * 0.1),
//           ),
//           color: noteColor,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: noteColor,
//                   borderRadius:
//                       BorderRadius.circular(mediaQuery.size.width * 0.1),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: mediaQuery.size.width * 0.05,
//                       spreadRadius: mediaQuery.size.width * 0.01,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(7.0),
//                   child: ListTile(
//                     title: Center(
//                       child: Text(item['name'],
//                           style: TextStyle(
//                             color: notetextColor,
//                             fontWeight: FontWeight.bold,
//                           )),
//                     ),
//                     subtitle: Text(
//                       item['description'],
//                       style: TextStyle(color: notetextColor),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
