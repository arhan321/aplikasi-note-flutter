import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String color;

  @HiveField(2)
  final String textcolor;

  Person({
    required this.name,
    required this.description,
    required this.color,
    required this.textcolor,
  });
}

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 1;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    if (fields[0] is String && fields[1] is String && fields[2] is String) {
      return Person(
        name: fields[0] as String,
        description: fields[1] as String,
        color: fields[2] as String,
        textcolor: fields[3] as String,
      );
    } else {
      throw HiveError('Invalid Person data');
    }
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.textcolor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddPersonForm extends StatefulWidget {
  const AddPersonForm({Key? key}) : super(key: key);

  @override
  _AddPersonFormState createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<AddPersonForm> {
  Color selectedColor = Colors.white;
  Color selectedTextColor = Colors.black;
  final _nameController = TextEditingController();
  final controllerNotes = TextEditingController();
  final _personFormKey = GlobalKey<FormState>();

  late final Box box;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  _addInfo() async {
    Person newPerson = Person(
      name: _nameController.text,
      description: controllerNotes.text,
      color: '#${selectedColor.value.toRadixString(16).substring(2)}',
      textcolor: '#${selectedTextColor.value.toRadixString(16).substring(2)}',
    );

    box.add(newPerson);
    print('Info added to box with color: ${newPerson.color}');
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('persons');
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
          title: const Text('Select a Text color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedTextColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedTextColor = color;
                });
              },
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final borderRadius = mediaQuery.size.width * 0.05;

    return Form(
      key: _personFormKey,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
            ),
            const SizedBox(height: 10.0),
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
                    fontSize: mediaQuery.size.width * 0.04,
                    color: Colors.black),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: "Name",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Note',
            ),
            const SizedBox(height: 10.0),
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
                    fontSize: mediaQuery.size.width * 0.04,
                    color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Note",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Select Color',
                style: TextStyle(fontSize: 15),
              ),
              onTap: _showColorPicker,
              trailing: Container(
                width: mediaQuery.size.width * 0.08,
                height: mediaQuery.size.width * 0.08,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: mediaQuery.size.width * 0.025,
                      spreadRadius: mediaQuery.size.width * 0.005,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Select Text Color',
                style: TextStyle(fontSize: 15),
              ),
              onTap: _showTextColorPicker,
              trailing: Container(
                width: mediaQuery.size.width * 0.08,
                height: mediaQuery.size.width * 0.08,
                decoration: BoxDecoration(
                  color: selectedTextColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: mediaQuery.size.width * 0.025,
                      spreadRadius: mediaQuery.size.width * 0.005,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width * 0.04,
                0.0,
                mediaQuery.size.width * 0.04,
                mediaQuery.size.width * 0.06,
              ),
              child: Container(
                width: double.maxFinite,
                height: mediaQuery.size.width * 0.12,
                child: ElevatedButton(
                  onPressed: () {
                    if (_personFormKey.currentState!.validate()) {
                      setState(() {
                        _addInfo();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    elevation: mediaQuery.size.width * 0.025,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
