import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/card_widget.dart';

import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:lottie/lottie.dart';

import '../Details_Screen/Screen_details.dart';

class ScreenShowAll extends StatefulWidget {
  ScreenShowAll({
    super.key,
    required this.logedUser,
  });
  final logedUser;

  @override
  State<ScreenShowAll> createState() => _ScreenShowAllState();
}

class _ScreenShowAllState extends State<ScreenShowAll> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper.instance.getLogedUserInputDetails(
            widget.logedUser[DatabaseHelper.columnId]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the future to complete, show a loading indicator
            return CircularProgressIndicator(
              color: Colors.transparent,
            );
          } else if (snapshot.hasError) {
            // If there is an error retrieving the data, show an error message
            return Text('Error: ${snapshot.error}');
          } else {
            // If the future completes successfully, display the ListView
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Container(
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      Lottie.asset('lib/image/lottie.json'),
                      Text('No data found')
                    ],
                  ));
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                int reversedIndex = snapshot.data!.length - index - 1;
                Map<String, dynamic> detail = snapshot.data![reversedIndex];
                return InkWell(
                  onTap: () async {
                    final bool refresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ScreenDetails(
                            inputDetails: detail,
                            current: 0,
                            loggedUser: widget.logedUser,
                          );
                        },
                      ),
                    );
                    if (refresh) {
                      setState(() {});
                    }
                  },
                  child: CardWidget(
                    number: detail[DatabaseHelper.columnMobNo],
                    complaint: detail[DatabaseHelper.columnServiceRequired],
                    image: detail[DatabaseHelper.columnDeviceImage],
                    loggedUser: widget.logedUser,
                    current: 0,
                    date: detail[DatabaseHelper.columnDate],
                    device: detail[DatabaseHelper.columnModelName],
                    name: detail[DatabaseHelper.columnCustomerName],
                    iputDetails: snapshot.data![index],
                  ),
                );
              },
            );
          }
        });
  }
}
