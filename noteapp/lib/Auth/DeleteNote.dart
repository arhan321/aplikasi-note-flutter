// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noteapp/Auth/AddNote.dart';
import 'package:noteapp/Auth/EditNote.dart';

class Detail extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  int index;
  Detail({required this.index, required this.list});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<void> deleteData() async {
    final connection = await DatabaseManager().getConnection();

    try {
      const query = 'DELETE FROM notes WHERE id = ?';
      final result =
          await connection.query(query, [widget.list[widget.index]['id']]);
      if (result.affectedRows! > 0) {
        _showSnackBar(context, "Data successfully deleted");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Home();
        }));
      } else {
        _showSnackBar(context, "Failed to delete data $context");
        print('"Failed to delete data $context"');
      }
    } catch (e) {
      print("Error deleting data: $e");
      _showSnackBar(context, "An error occurred while deleting data");
    } finally {
      await connection.close();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget _buildItem(BuildContext context, MediaQueryData mediaQuery) {
    final String colorHex = widget.list[widget.index]['color'];
    final Color noteColor = Color(int.parse(colorHex, radix: 16));

    final String colorText = widget.list[widget.index]['textcolor'];
    final Color noteTextColor = Color(int.parse(colorText, radix: 16));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Home();
              }));
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => EditData(
                        list: widget.list,
                        index: widget.index,
                      ),
                    ),
                  ),
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () => deleteData(), icon: const Icon(Icons.delete)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
        decoration: BoxDecoration(
          color: noteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: mediaQuery.size.width * 0.025,
              spreadRadius: mediaQuery.size.width * 0.005,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Name',
                style: TextStyle(color: noteTextColor),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.list[widget.index]['name'],
                style: TextStyle(
                    fontSize: mediaQuery.size.width * 0.06,
                    color: noteTextColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Note',
                style: TextStyle(
                  color: noteTextColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.list[widget.index]['description'],
                style: TextStyle(
                    fontSize: mediaQuery.size.width * 0.06,
                    color: noteTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        Expanded(
          child: _buildItem(context, mediaQuery),
        ),
      ],
    );
  }
}
