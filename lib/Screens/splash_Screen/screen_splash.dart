import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:flutter_application_1/Screens/sign_in_Screen/screen_login.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    checking();
    super.initState();
  }

  Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: Color(0xFFBC6C25),
        body: Container(
          width: double.infinity,
          height: height,
          color: Color(0xFFBC6C25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/image/repair (1).png',
                        width: 100,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Service',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                          Text(
                            'Cloud',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ));
  }

  checking() async {
    user = await DatabaseHelper.instance.getLogedUser();
    if (user == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ScreenLogin()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ScreenHome(logedusr: user)));
    }
  }
}
