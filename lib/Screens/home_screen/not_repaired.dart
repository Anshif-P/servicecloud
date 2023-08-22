import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/card_widget.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:lottie/lottie.dart';

class NotRepairedList extends StatelessWidget {
  const NotRepairedList({super.key, required this.logedUser});
  final logedUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper.instance
            .getSortedList(logedUser[DatabaseHelper.columnId], 'Not Repaired'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the future to complete, show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there is an error retrieving the data, show an error message
            return Text('Error: ${snapshot.error}');
          } else {
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
            // If the future completes successfully, display the ListView
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                int reversedIndex = snapshot.data!.length - index - 1;
                Map<String, dynamic> detail = snapshot.data![reversedIndex];
                return CardWidget(
                  number: detail[DatabaseHelper.columnMobNo],
                  complaint: detail[DatabaseHelper.columnServiceRequired],
                  image: detail[DatabaseHelper.columnDeviceImage],
                  loggedUser: logedUser,
                  current: 4,
                  date: detail[DatabaseHelper.columnDate],
                  device: detail[DatabaseHelper.columnModelName],
                  name: detail[DatabaseHelper.columnCustomerName],
                  iputDetails: snapshot.data![index],
                );
              },
            );
          }
        });
  }
}
