import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/drawer_Total_Screen/App_Ifo.dart';
import 'package:flutter_application_1/Screens/drawer_Total_Screen/Revenue.dart';
import 'package:flutter_application_1/Screens/drawer_Total_Screen/edit_screen.dart';
import 'package:flutter_application_1/Screens/drawer_Total_Screen/privacy_Policy.dart';
import 'package:flutter_application_1/Screens/sign_in_Screen/screen_login.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';

// ignore: must_be_immutable
class DrowerWidget extends StatelessWidget {
  DrowerWidget({super.key, required this.logeduser});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  File? image;

  final logeduser;
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFECECEC),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 170,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 25),
                  CircleAvatar(
                    backgroundImage: logeduser[DatabaseHelper.columnImage] ==
                            null
                        ? AssetImage('lib/image/unnamed.jpg')
                        : FileImage(File(logeduser[DatabaseHelper.columnImage]))
                            as ImageProvider,
                    backgroundColor: Colors.white,
                    radius: 30,
                  ),
                  SizedBox(width: 14),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2),
                        Text(
                          logeduser[DatabaseHelper.columnName] == null
                              ? 'userNotfound'
                              : logeduser[DatabaseHelper.columnName],
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        Text(
                          logeduser[DatabaseHelper.columnEmail] == null
                              ? 'Email Not Found'
                              : logeduser![DatabaseHelper.columnEmail],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFFB5B5B5),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 20,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFBC6C25)),
                            ),
                            onPressed: () {
                              if (logeduser[DatabaseHelper.columnImage] ==
                                  null) {
                                imagePath = 'lib/image/unnamed.jpg';
                              } else {
                                imagePath =
                                    logeduser[DatabaseHelper.columnImage];
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScreenEidt(
                                    logeduser: logeduser,
                                    imagePath:
                                        logeduser[DatabaseHelper.columnImage],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Edit Profile',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App info'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ScreenAppinfo(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy & policy'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScreenPrivacyPolicy()));
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('Help'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add_home_work_outlined),
            title: Text('Revenue And Stock'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      ScreenMainRevenueStock(logedData: logeduser),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Color(0xFFBC6C25),
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(color: Color(0xFFBC6C25)),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LogoutDialog(
                    logeduser: logeduser,
                  );
                },
              );
            },
          ), // ... Other list tiles ...
        ],
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key, required this.logeduser}) : super(key: key);
  final logeduser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Sign Out ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Do you want to sign out',
        style: TextStyle(color: Color(0xFF6D6D6D)),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color.fromARGB(255, 138, 135, 135),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            DatabaseHelper.instance
                .userLogoutUpdate(logeduser[DatabaseHelper.columnEmail]);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ScreenLogin()));
          },
          child: const Text(
            'Sign out',
            style: TextStyle(
              color: Color(0xFFBC6C25),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      elevation: 5,
    );
  }
}
