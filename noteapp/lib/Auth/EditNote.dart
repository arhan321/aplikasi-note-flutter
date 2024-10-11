import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteapp/Auth/AddNote.dart';

import 'Functions.dart';

class EditData extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  final int index;

  EditData({required this.list, required this.index});

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  late TextEditingController controllerName;
  late TextEditingController controllerNotes;
  Future<bool> editData() async {
    final UserController userController = Get.find<UserController>();
    if (userController.user.value == null) {
      return false;
    }

    final userId = userController.user.value!.id;
    final connection = await DatabaseManager().getConnection();

    try {
      await connection.query(
        'UPDATE notes SET name = ?, description = ? WHERE id = ? AND user_id = ?',
        [
          controllerName.text,
          controllerNotes.text,
          widget.list[widget.index]['id'],
          userId,
        ],
      );
    } catch (e) {
      print('Error updating data: $e');
    } finally {
      await connection.close();
    }

    return true;
  }

  @override
  void initState() {
    controllerName =
        TextEditingController(text: widget.list[widget.index]['name']);
    controllerNotes =
        TextEditingController(text: widget.list[widget.index]['description']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const Home();
              }));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Name'),
            SizedBox(
              height: mediaQuery.size.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(mediaQuery.size.width * 0.03),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: mediaQuery.size.width * 0.01,
                    spreadRadius: mediaQuery.size.width * 0.005,
                    offset: Offset(0, mediaQuery.size.width * 0.015),
                  ),
                ],
              ),
              child: TextField(
                controller: controllerName,
                style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.04,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  hintText: "Name",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(mediaQuery.size.width * 0.03),
                ),
              ),
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.02,
            ),
            const Text('Note'),
            SizedBox(
              height: mediaQuery.size.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(mediaQuery.size.width * 0.03),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: mediaQuery.size.width * 0.01,
                    spreadRadius: mediaQuery.size.width * 0.005,
                    offset: Offset(0, mediaQuery.size.width * 0.015),
                  ),
                ],
              ),
              child: TextField(
                controller: controllerNotes,
                style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.04,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  hintText: "Note",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(mediaQuery.size.width * 0.03),
                ),
              ),
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.03,
            ),
            Container(
              width: double.infinity,
              height: mediaQuery.size.height * 0.07,
              child: ElevatedButton(
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  await editData();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Home(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: mediaQuery.size.width * 0.02,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(mediaQuery.size.width * 0.03),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
