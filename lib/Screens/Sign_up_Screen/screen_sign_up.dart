import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:flutter_application_1/Screens/sign_in_Screen/screen_login.dart';
import 'package:flutter_application_1/Screens/widgets/email_pass_textfield_widget.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';

class ScreenSignUp extends StatefulWidget {
  ScreenSignUp({Key? key}) : super(key: key);

  @override
  _ScreenSignUpState createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final signupkey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: [
        Container(
          height: MediaQuery.of(context).size.height,
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
                      key: signupkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 34, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Create your account',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EmailPassField(
                              formController: nameController,
                              hintText: 'Full Name',
                              validatorField: (value) {
                                if (value!.isEmpty ||
                                    RegExp(r'^[a-zA-Z0-9]$').hasMatch(value)) {
                                  return 'Enter correct name ';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EmailPassField(
                              hintText: 'Email Address',
                              formController: emailController,
                              validatorField: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                        .hasMatch(value)) {
                                  return 'Enter correct Email ';
                                } else if (DatabaseHelper.instance
                                    .isUsernameAvailable()) {
                                  return 'Email is already taken';
                                }
                                return null;
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
                                    !RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
                                        .hasMatch(value)) {
                                  return 'Enter correct Password ';
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
                              await DatabaseHelper.instance.UserEmailAvailable(
                                  emailController.text.trim());
                              if (signupkey.currentState!.validate()) {
                                String name = nameController.text;
                                String email = emailController.text;
                                String password = passwordController.text;

                                // Create a map containing the user data
                                Map<String, dynamic> userData = {
                                  'name': name,
                                  'email': email,
                                  'password': password,
                                  'logincheck': 1,
                                };

                                // Insert the user data into the database
                                await DatabaseHelper.instance
                                    .insertRecord(userData);
                                final user = await DatabaseHelper.instance
                                    .getLogedUser();

                                // Navigate to the home screen or perform any other desired action
                                showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                          child: CircularProgressIndicator(),
                                        ));
                                await Future.delayed(Duration(seconds: 2));
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenHome(logedusr: user)),
                                );
                              }
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 25),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFBC6C25)),
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
                                    builder: (context) => ScreenLogin()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Text(
                                  '  Log In',
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
      ]),
    );
  }
}
