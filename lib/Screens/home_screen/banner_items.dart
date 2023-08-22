import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/drawer_Total_Screen/Revenue.dart';
import 'package:flutter_application_1/Screens/home_screen/app_banner.dart';
import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Map<String, dynamic>? loggeduserTemp;

class BannerItem extends StatefulWidget {
  final Appbanner appbanner;
  final ValueNotifier<Map> profiRevenueNotifier;
  final loggeduser;
  const BannerItem(
      {required this.loggeduser,
      super.key,
      required this.appbanner,
      required this.profiRevenueNotifier});

  @override
  State<BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 110),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              height: 300,
              child: widget.appbanner.carosalDetials,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(0, 109, 105, 101),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 180,
              height: 168,
              child: widget.appbanner.thumbnailurl,
            ),
          ],
        ),
      ),
    );
  }
}

//   first page -------------------------------------------//
class page1 extends StatefulWidget {
  page1({
    super.key,
    required this.loggeduser,
  });
  final Map<String, dynamic> loggeduser;

  @override
  State<page1> createState() => _page1State();
}

class _page1State extends State<page1> {
  Map<String, int>? totalFinishedBilledList;
  DateTime today = DateTime.now();
  String? revenue;
  String? profit;
  String get currentDate => DateFormat('yyyy/MM/dd').format(today);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Card(
          color: Color.fromARGB(255, 249, 242, 242),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ValueListenableBuilder<Map>(
              valueListenable: profitAndRevenueNotifier,
              builder: (context, amountMap, _) {
                revenue = amountMap['revenueAmount'].toString();
                profit = amountMap['profitAmount'].toString();
                return Container(
                  height: 270,
                  width: 366,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: Text(
                                      '₹ ${amountMap['revenueAmount']}',
                                      style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    subtitle: Text('Today Revenue'),
                                  ),
                                  Divider(
                                    endIndent: 45,
                                    indent: 10,
                                    thickness: 1,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  ListTile(
                                    title: Text(
                                      '₹ ${amountMap['profitAmount']}',
                                      style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    subtitle: Text('Today Profit'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ScreenMainRevenueStock(
                                            logedData: widget.loggeduser)));
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                width: 190,
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'view',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 43, 43, 43)),
                                    ),
                                    Icon(Icons.keyboard_double_arrow_right)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: CircularPercentIndicator(
                                radius: 63,
                                lineWidth: 15,
                                animation: true,
                                progressColor: Colors.orange,
                                percent: calculateProfitPercentage(),
                                animationDuration: 1000,
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor:
                                    Color.fromARGB(255, 250, 190, 167),
                                footer: Text(
                                  ' \nToday Profit Ratio',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 96, 96, 96)),
                                ),
                                center: Text(
                                  '${(calculateProfitPercentage() * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  double calculateProfitPercentage() {
    if (profit != null && revenue != null) {
      try {
        double profitAmount = double.parse(profit!);
        double revenueAmount = double.parse(revenue!);

        if (revenueAmount != 0) {
          return profitAmount / revenueAmount;
        }
      } catch (e) {}
    }
    return 0.0;
  }
}

//   first page -------------------------------------------//

class page2 extends StatefulWidget {
  page2({super.key, required this.loggeduser});
  final Map<String, dynamic> loggeduser;

  @override
  State<page2> createState() => _page2State();
}

class _page2State extends State<page2> {
  Map<String, int>? totalFinishedBilledList;
  DateTime today = DateTime.now();
  String? pendingCustomersCount;
  String? finishedCustomersCount;
  String get currentDate => DateFormat('yyyy/MM/dd').format(today);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Card(
          color: Color.fromARGB(255, 249, 242, 242),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ValueListenableBuilder(
            valueListenable: pendingFinishedNotifier,
            builder: (context, pendingFinishedMap, _) {
              pendingCustomersCount =
                  pendingFinishedMap['processingCount'].toString();
              finishedCustomersCount =
                  pendingFinishedMap['finishedCount'].toString();
              return Container(
                height: 270,
                width: 366,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 249, 242, 242),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  title: Text(
                                    '$pendingCustomersCount',
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  subtitle: Text('Total Pending Work'),
                                ),
                                Divider(
                                  endIndent: 45,
                                  indent: 10,
                                  thickness: 1,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                ListTile(
                                  title: Text(
                                    '$finishedCustomersCount',
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  subtitle: Text('Total Finished Work'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: CircularPercentIndicator(
                              radius: 63,
                              lineWidth: 15,
                              animation: true,
                              progressColor: Colors.orange,
                              percent: calculateProfitPercentage(),
                              animationDuration: 1000,
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor:
                                  Color.fromARGB(255, 250, 190, 167),
                              footer: Text(
                                ' \nTotal Complete Ratio',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 96, 96, 96)),
                              ),
                              center: Text(
                                '${(calculateProfitPercentage() * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  double calculateProfitPercentage() {
    if (finishedCustomersCount != null && pendingCustomersCount != null) {
      try {
        double finishedCustomers = double.parse(finishedCustomersCount!);
        double pendingCustomers = double.parse(pendingCustomersCount!);
        double totalCustomers = finishedCustomers + pendingCustomers;

        if (totalCustomers != 0) {
          return finishedCustomers / totalCustomers;
        }
      } catch (e) {}
    }
    return 0.0;
  }
}
