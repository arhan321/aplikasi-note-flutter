import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/GuestUser/AddForm.dart';
import 'package:noteapp/GuestUser/GuestPage.dart';

class UpdatePersonForm extends StatefulWidget {
  final int index;
  final Person person;

  const UpdatePersonForm({
    super.key,
    required this.index,
    required this.person,
  });

  @override
  _UpdatePersonFormState createState() => _UpdatePersonFormState();
}

class _UpdatePersonFormState extends State<UpdatePersonForm> {
  Color selectedColor = Colors.white;

  Color selectedTextColor = Colors.black;
  final _personFormKey = GlobalKey<FormState>();

  late final _nameController;
  late final controllerNotes;
  late final Box box;

  _updateInfo() {
    Person newPerson = Person(
      name: _nameController.text,
      description: controllerNotes.text,
      color: '#${selectedColor.value.toRadixString(16).substring(2)}',
      textcolor: '#${selectedTextColor.value.toRadixString(16).substring(2)}',
    );

    box.putAt(widget.index, newPerson);

    print('Info updated in box!');
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('persons');
    _nameController = TextEditingController(text: widget.person.name);
    controllerNotes = TextEditingController(text: widget.person.description);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final borderRadius = mediaQuery.size.width * 0.05;

    return Form(
      key: _personFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Name'),
          SizedBox(
            height: mediaQuery.size.height * 0.015,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: mediaQuery.size.width * 0.025,
                  spreadRadius: mediaQuery.size.width * 0.005,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: _nameController,
              style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.04, color: Colors.black),
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black),
                hintText: "Name",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.03,
          ),
          const Text('Note'),
          SizedBox(
            height: mediaQuery.size.height * 0.015,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: mediaQuery.size.width * 0.025,
                  spreadRadius: mediaQuery.size.width * 0.005,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: controllerNotes,
              style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.04, color: Colors.black),
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black),
                hintText: "Note",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.03,
          ),
          Container(
            width: double.maxFinite,
            height: mediaQuery.size.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                if (_personFormKey.currentState!.validate()) {
                  _updateInfo();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => InfoScreen()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: mediaQuery.size.width * 0.025,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: const Text('Update'),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateScreen extends StatefulWidget {
  final int index;
  final Person person;

  const UpdateScreen({
    super.key,
    required this.index,
    required this.person,
  });

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late final Box contactBox;

  @override
  void initState() {
    super.initState();
    contactBox = Hive.box('persons');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Update Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
        child: UpdatePersonForm(
          index: widget.index,
          person: widget.person,
        ),
      ),
    );
  }
}
