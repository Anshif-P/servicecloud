import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ScreenEidt extends StatefulWidget {
  ScreenEidt({super.key, required this.logeduser, required this.imagePath});
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emaiController = TextEditingController();
  Map<String, dynamic>? logeduser;
  String? imagePath;

  @override
  State<ScreenEidt> createState() => _ScreenEidtState();
}

class _ScreenEidtState extends State<ScreenEidt> {
  final emailNameupkey = GlobalKey<FormState>();

  File? image;
  @override
  void initState() {
    super.initState();

    final imagePath = widget.logeduser?[DatabaseHelper.columnImage];
    image = imagePath != null ? File(imagePath) : null;
  }

  @override
  Widget build(BuildContext context) {
    widget.nameController.text = widget.logeduser![DatabaseHelper.columnName];
    widget.emaiController.text = widget.logeduser![DatabaseHelper.columnEmail];

    return Scaffold(
        backgroundColor: Color(0xFFECECEC),
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: Color(0xFFBC6C25),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: emailNameupkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: image == null
                          ? AssetImage('lib/image/unnamed.jpg')
                          : FileImage(File(image!.path)) as ImageProvider,
                      backgroundColor: Colors.white,
                      radius: 50,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {
                          _showImageSourceOptions();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(8),
                        ),
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: widget.nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: widget.emaiController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                            .hasMatch(value)) {
                      return 'Enter correct Email ';
                    } else if (DatabaseHelper.instance.isUsernameAvailable()) {
                      return 'Email is already taken';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFBC6C25)),
                  ),
                  onPressed: () async {
                    if (emailNameupkey.currentState!.validate()) {
                      final imageTemp = image?.path ??
                          widget.logeduser?[DatabaseHelper.columnImage];
                      final data =
                          await DatabaseHelper.instance.updateNameEmailPhoto(
                        widget.logeduser![DatabaseHelper.columnId],
                        widget.nameController.text,
                        widget.emaiController.text,
                        imageTemp,
                      );
                      widget.logeduser = data;
                      setState(() {});
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ScreenHome(
                                logedusr: widget.logeduser,
                              )));
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ));
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFBC6C25)),
                ),
                onPressed: () {
                  pickAndSetProfilePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Text('Gallery'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFBC6C25)),
                ),
                onPressed: () {
                  pickAndSetProfilePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Text('Camera'),
              ),
            ],
          ),
        );
      },
    );
  }

  void pickAndSetProfilePhoto(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
}
