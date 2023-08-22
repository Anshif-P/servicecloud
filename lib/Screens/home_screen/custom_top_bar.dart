import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/billed_widget.dart';
import 'package:flutter_application_1/Screens/home_screen/finished_widget.dart';
import 'package:flutter_application_1/Screens/home_screen/not_repaired.dart';
import 'package:flutter_application_1/Screens/home_screen/processing_screen.dart';
import 'package:flutter_application_1/Screens/home_screen/show_all.dart';

// ignore: must_be_immutable
class CustomTabBar extends StatefulWidget {
  CustomTabBar({
    Key? key,
    this.logedUser,
    this.pageTotravel,
    required this.pageNotifier,
    required this.profitAndRevenueNotifier,
  });
  ValueNotifier<Map> profitAndRevenueNotifier;
  final logedUser;
  final int? pageTotravel;
  final ValueNotifier<int> pageNotifier;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

int current = 0;

class _CustomTabBarState extends State<CustomTabBar> {
  List<Widget> pages = [];

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
    current = widget.pageTotravel ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
                      widget.pageNotifier.value = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: current == index
                            ? const Color.fromARGB(255, 17, 16, 16)
                            : Color.fromARGB(255, 203, 203, 208),
                      ),
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
          ValueListenableBuilder<int>(
            valueListenable: widget.pageNotifier,
            builder: (context, index, _) {
              return Expanded(
                child: pages[current],
              );
            },
          ),
        ],
      ),
    );
  }
}
