import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';

var result;

// ignore: must_be_immutable
class CardWidget extends StatefulWidget {
  final image;

  final name;
  final device;
  final date;
  final current;
  final loggedUser;
  final complaint;
  final number;

  Map<String, dynamic> iputDetails;

  CardWidget({
    super.key,
    required this.image,
    required this.loggedUser,
    required this.current,
    required this.name,
    required this.device,
    required this.date,
    required this.iputDetails,
    required this.complaint,
    required this.number,
  });
  @override
  State<CardWidget> createState() => _CardWidgetState();
}

String? status;
late Color buttonColor;

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance
          .getServiceStutas(widget.iputDetails[DatabaseHelper.detailsColumnId]),
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
          List<Map<String, dynamic>>? data = snapshot.data;
          if (data != null && data.isNotEmpty) {
            // Ensure the data is not null and contains at least one element
            status = data[0][DatabaseHelper.columnServiceStatus];
          }
          if (status == 'Processing') {
            buttonColor = const Color(0xFFBCD333);
          } else if (status == 'Finished') {
            buttonColor = Color(0xFF3373D3);
          } else if (status == 'Not Repaired') {
            buttonColor = Color(0xFFCE1E1E);
          } else if (status == 'Billed') {
            buttonColor = Color(0xFF29A135);
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.26,
                        height: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(widget.image.toString()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        // color: Colors.red,
                        alignment: Alignment.center,
                        height: 75, // adjust size of the contianer
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name: ${widget.name}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.calendar_month),
                                Text(
                                  ' ${widget.date}',
                                  style: TextStyle(
                                    color: Color.fromRGBO(126, 128, 130, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(3)),
                                  width:
                                      113, // Set a fixed width for the status display area
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),

                                  child: Center(
                                    child: Text(
                                      status!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text('Device : ${widget.device}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(126, 128, 130, 1))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
