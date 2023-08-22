import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/Screens/add_Screen/screen_add.dart';
import 'package:flutter_application_1/Screens/home_screen/app_banner.dart';
import 'package:flutter_application_1/Screens/home_screen/banner_items.dart';
import 'package:flutter_application_1/Screens/home_screen/card_widget.dart';
import 'package:flutter_application_1/Screens/home_screen/indicator.dart';
import 'package:flutter_application_1/Screens/home_screen/search_screen.dart';
import 'package:flutter_application_1/Screens/home_screen/temp_custom_topbar.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:intl/intl.dart';

import '../drower_Screen/drower.dart';
import 'custom_top_bar.dart';
import 'show_all.dart';

ValueNotifier<Map> profitAndRevenueNotifier = ValueNotifier({});
ValueNotifier<Map> pendingFinishedNotifier = ValueNotifier({});

// new gpt //-------------------------------//
class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key, this.logedusr, this.homeCurrent});
  final logedusr;
  final homeCurrent;

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final scrollController = ScrollController();
  bool isShowTabbar = false;
  var _selectedIndex = 0;

  ValueNotifier<int> pageNotifier = ValueNotifier<int>(0);

  profitRevenueGet() async {
    final currentDate = DateTime.now();
    final tempDate = DateFormat('yyyy/MM/dd').format(currentDate);
    final startingDate = currentDate.copyWith(day: 1);
    final tempStartingDate = DateFormat('yyyy/MM/dd').format(startingDate);

    profitAndRevenueNotifier.value = await DatabaseHelper.instance
        .getRevenueProfit(widget.logedusr[DatabaseHelper.columnId],
            tempStartingDate, tempDate);
    pendingFinishedNotifier.value = await DatabaseHelper.instance
        .getFinishedPendingDetails(widget.logedusr[DatabaseHelper.columnId]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    profitRevenueGet();
    ScreenShowAll(
      logedUser: widget.logedusr,
    );
  }

  Widget build(BuildContext context) {
    loggeduserTemp = widget.logedusr;
    scrollController.addListener(scrollListner);
    if (result == true) {
      setState(() {});
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          height: 30,
          width: 130,
          child: Column(
            children: [
              isShowTabbar == false
                  ? Text(
                      'Hai ${widget.logedusr[DatabaseHelper.columnName]}',
                      style: TextStyle(
                        fontSize: 19,
                        color: const Color.fromARGB(255, 92, 89, 89),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(10),
          height: 8,
          child: CircleAvatar(
            backgroundImage: widget.logedusr[DatabaseHelper.columnImage] == null
                ? AssetImage('lib/image/unnamed.jpg')
                : FileImage(File(widget.logedusr[DatabaseHelper.columnImage]))
                    as ImageProvider,
            backgroundColor: Colors.black,
          ),
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: const Color.fromARGB(255, 67, 67, 67),
                  size: 35,
                ),
              );
            },
          ),
          Container(
            width: 5,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: 375,
                  height: 50,
                  child: TextField(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ScreenSearch(loggedUser: widget.logedusr),
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      hintText: 'Search Customers',
                      hintStyle:
                          TextStyle(color: Color(0xFF6D6D6D), fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 106, 102, 102),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 203, 203, 208)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 203, 203, 208)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 0),
                height: isShowTabbar ? 55 : 0,
                child: CustomTopbarTemp(
                  notifier: pageNotifier,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 217, 132, 5),
        onPressed: () {
          print(widget.logedusr);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScreenAdd(logedUser: widget.logedusr),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        controller: scrollController,
        children: [
          Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 16),
            height: 340,
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              controller: PageController(viewportFraction: 0.95),
              itemCount: appBannerList.length,
              itemBuilder: (context, index) {
                var banner = appBannerList[index];
                var _scale = _selectedIndex == index ? 1.0 : 0.91;
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 350),
                  tween: Tween(begin: _scale, end: _scale),
                  curve: Curves.ease,
                  child: BannerItem(
                      profiRevenueNotifier: profitAndRevenueNotifier,
                      appbanner: banner,
                      loggeduser: widget.logedusr),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                appBannerList.length,
                (index) =>
                    Indicator(isActive: _selectedIndex == index ? true : false),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          CustomTabBar(
            profitAndRevenueNotifier: profitAndRevenueNotifier,
            pageNotifier: pageNotifier,
            logedUser: widget.logedusr,
            pageTotravel: widget.homeCurrent,
          ),
        ],
      ),
      endDrawer: DrowerWidget(logeduser: widget.logedusr),
    );
  }

  scrollListner() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
    } else {}
    if (scrollController.offset > 420) {
      isShowTabbar = true;
      setState(() {});
    } else {
      isShowTabbar = false;
      setState(() {});
    }
  }
}
