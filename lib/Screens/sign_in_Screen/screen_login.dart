import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Sign_up_Screen/screen_sign_up.dart';
import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:flutter_application_1/Screens/widgets/email_pass_textfield_widget.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';

class ScreenLogin extends StatefulWidget {
  ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final loginKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(340),
                                ),
                                color: Color(0xFFBC6C25)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Form(
                        key: loginKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Sign into your account',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: EmailPassField(
                                hintText: 'Email',
                                formController: emailController,
                                validatorField: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                          .hasMatch(value)) {
                                    return 'Enter correct Email ';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: EmailPassField(
                                hintText: 'Password',
                                formController: passwordController,
                                validatorField: (value) {
                                  if (value!.isEmpty ||
                                      RegExp(r'^[a-zA-Z0-9]$')
                                          .hasMatch(value)) {
                                    return 'Enter correct name ';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: !_passwordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFFBC6C25),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (loginKey.currentState!.validate()) {
                                  String enteredEmail = emailController.text;
                                  String enteredPassword =
                                      passwordController.text;

                                  // Retrieve the user record from the database based on the entered email
                                  List<Map<String, dynamic>> dbRecords =
                                      await DatabaseHelper.instance
                                          .getAllUsers();
                                  Map<String, dynamic> userRecord =
                                      dbRecords.firstWhere(
                                          (record) =>
                                              record[
                                                  DatabaseHelper.columnEmail] ==
                                              enteredEmail,
                                          orElse: () => {});
                                  print(userRecord);

                                  if (userRecord.isNotEmpty) {
                                    // User found in the database
                                    String storedPassword = userRecord[
                                        DatabaseHelper.columnPassword];

                                    if (enteredPassword == storedPassword) {
                                      // Password matches, navigate to home screen
                                      await DatabaseHelper.instance
                                          .userLogInUpdate(enteredEmail);

                                      final user = await DatabaseHelper.instance
                                          .getLogedUser();
                                      showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ));
                                      await Future.delayed(
                                          Duration(seconds: 2));

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ScreenHome(logedusr: user),
                                        ),
                                      );
                                    } else {
                                      // Incorrect password
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Invalid Password'),
                                          content: Text(
                                              'The entered password is incorrect.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    // User not found
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('User Not Found'),
                                        content: Text(
                                            'No user found with the entered email.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(fontSize: 25),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFBC6C25),
                                  ),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(366, 51))),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ScreenSignUp()),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't  have  an  account?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '  Sign Up',
                                    style: TextStyle(
                                        color: Color(0xFFBC6C25),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
