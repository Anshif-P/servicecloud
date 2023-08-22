// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';

// ignore: must_be_immutable
class DropButtonWidget extends StatefulWidget {
  DropButtonWidget(
      {Key? key, required this.inputDetails, required this.onStatusChanged})
      : super(key: key);
  Map<String, dynamic> inputDetails;
  final Function(String?) onStatusChanged;

  @override
  _DropButtonWidgetState createState() => _DropButtonWidgetState();
}

class _DropButtonWidgetState extends State<DropButtonWidget> {
  String? valueChoose;
  List<String> listItem = ["Processing", "Finished", "Billed", "Not Repaired"];
  String? status;

  Color buttonColor = const Color(0xFFBCD333);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getServiceStutas(
          widget.inputDetails[DatabaseHelper.detailsColumnId]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator
          return CircularProgressIndicator();
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

          return Container(
            constraints: BoxConstraints(maxHeight: 30),
            decoration: BoxDecoration(
              color: buttonColor,
              border: Border.all(color: buttonColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              focusColor: buttonColor,
              dropdownColor: Color(0xFFBC6C25),
              hint: Padding(
                padding: const EdgeInsets.only(left: 9),
                child: Text(
                  status == null ? 'Processing' : status!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: valueChoose,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (String? newValue) async {
                await DatabaseHelper.instance.updateStutas(
                    widget.inputDetails[DatabaseHelper.detailsColumnId],
                    newValue!);
                pendingFinishedNotifier.value = await DatabaseHelper.instance
                    .getFinishedPendingDetails(
                        widget.inputDetails[DatabaseHelper.userId]);
                // ignore: invalid_use_of_visible_for_testing_member
                pendingFinishedNotifier.notifyListeners();

                widget.onStatusChanged(
                    newValue); // Call the callback function to update the status
                setState(() {
                  valueChoose = newValue;
                  if (newValue == 'Processing') {
                    buttonColor = const Color(0xFFBCD333);
                  } else if (newValue == 'Finished') {
                    buttonColor = Color(0xFF3373D3);
                  } else if (newValue == 'Not Repaired') {
                    buttonColor = Color(0xFFCE1E1E);
                  } else if (newValue == 'Billed') {
                    buttonColor = Color(0xFF29A135);
                  }
                });
              },
              underline: Container(),
              items: listItem.map((String valueItem) {
                return DropdownMenuItem<String>(
                  value: valueItem,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      valueItem,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
