import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/billed_widget.dart';
import 'package:flutter_application_1/Screens/home_screen/custom_top_bar.dart';
import 'package:flutter_application_1/Screens/home_screen/finished_widget.dart';
import 'package:flutter_application_1/Screens/home_screen/not_repaired.dart';
import 'package:flutter_application_1/Screens/home_screen/processing_screen.dart';
import 'package:flutter_application_1/Screens/home_screen/show_all.dart';

class CustomTopbarTemp extends StatefulWidget {
  CustomTopbarTemp({
    Key? key,
    this.logedUser,
    this.pageTotravel,
    required this.notifier,
  });
  final logedUser;
  final int? pageTotravel;
  final ValueNotifier<int> notifier;
  @override
  State<CustomTopbarTemp> createState() => _CustomTopbarTempState();
}

class _CustomTopbarTempState extends State<CustomTopbarTemp> {
  List pages = [];

  List<String> items = [
    'Show All',
    'Processing',
    'Finished',
    'Billed',
    'Not Repaired',
  ];

  @override
  void initState() {
    pages = [
      ScreenShowAll(
        logedUser: widget.logedUser,
      ),
      ProcessingList(logedUser: widget.logedUser),
      FinishedScreen(logedUser: widget.logedUser),
      BilledList(logedUser: widget.logedUser),
      NotRepairedList(logedUser: widget.logedUser),
    ];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        children: [
          SizedBox(
            height: 55,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      current = index;
                      widget.notifier.value = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),

                    width: 100, // Adjust the width as per your preference
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: current == index
                              ? Colors.black
                              : Color.fromARGB(255, 203, 203, 208)),
                      color:
                          current == index ? Color(0xFFF0EFF4) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          items[index],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
