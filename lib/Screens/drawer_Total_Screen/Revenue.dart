import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/widgets/Textwidget_details.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ScreenMainRevenueStock extends StatefulWidget {
  const ScreenMainRevenueStock({super.key, required this.logedData});
  final logedData;

  @override
  State<ScreenMainRevenueStock> createState() => _ScreenRevenueState();
}

class _ScreenRevenueState extends State<ScreenMainRevenueStock> {
  String? valuechoose;

  final List<String> listvalue = ['Today', 'Last Month', 'Custom Range'];
  Text hintText = Text('  Today');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        backgroundColor: Color(0xFFBC6C25),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          'Revenue And Stock',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            CustomTabBar(
              logedData: widget.logedData,
            )
          ],
        ),
      ),
    );
  }
}

// custom topbar //

class CustomTabBar extends StatefulWidget {
  CustomTabBar({Key? key, required this.logedData});
  final logedData;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  List pages = [];

  List<String> items = [
    'Revenue',
    'Stock',
  ];

  int current = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      RevenueWidget(logeduserl: widget.logedData),
      ScreenStock(logeduser: widget.logedData),
    ];
  }

  @override
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
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    width: 180, // Adjust the width as per your preference
                    decoration: BoxDecoration(
                      color:
                          current == index ? Color(0xFFBC6C25) : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          items[index],
                          style: TextStyle(
                              color: current == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: pages[current],
          )
        ],
      ),
    );
  }
}

///===============//

//  Stock Screen  //

class ScreenStock extends StatefulWidget {
  ScreenStock({Key? key, required this.logeduser}) : super(key: key);

  final Map<String, dynamic> logeduser;

  @override
  State<ScreenStock> createState() => _ScreenStockState();
}

class _ScreenStockState extends State<ScreenStock> {
  final stockKey = GlobalKey<FormState>();

  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: DatabaseHelper.instance
          .getStockAmount(widget.logeduser[DatabaseHelper.columnId]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there is an error retrieving the stock amount, show an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If the future completes successfully, display the stock amount
          int stockAmount = snapshot.data ?? 0; // Default value if data is null
          return Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              children: [
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * .2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "lib/image/arcticons_folder-rupee.svg",
                            width: 50,
                          ),
                          Text(
                            'Stock',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '₹ $stockAmount',
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFFBC6C25),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: TextWidget(text1st: 'Enter Stock Amount'),
                ),
                Form(
                  key: stockKey,
                  child: Container(
                    width: 350,
                    height: 51,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^\d+$').hasMatch(value) ||
                            value.trim().isEmpty) {
                          return 'Please enter a valid stock amount';
                        }
                        return null;
                      },
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFF767676),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFF767676),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    updateButtonPressed(stockAmount);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 25),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFBC6C25)),
                      minimumSize: MaterialStateProperty.all(Size(350, 51))),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  updateButtonPressed(stockAmount) async {
    if (stockKey.currentState!.validate()) {
      final tempStock = stockController.text;
      int Stock = int.parse(tempStock);
      int? currentStock = stockAmount;

      int newStock = (currentStock ?? 0) + (Stock);
      await DatabaseHelper.instance.userUpdateStock(
          id: widget.logeduser[DatabaseHelper.columnId], stock: newStock);
    }
    stockController.text = '';
    setState(() {});
  }
}

// Revenue //

class RevenueWidget extends StatefulWidget {
  RevenueWidget({super.key, required this.logeduserl});
  final logeduserl;

  @override
  State<RevenueWidget> createState() => _RevenueWidgetState();
}

class _RevenueWidgetState extends State<RevenueWidget> {
  String? valuechoose;

  final List<String> listvalue = ['Today', 'This Month', 'Custom Range'];

  Text hintText = Text('  Today');
  String? currentDate;
  String? startDate;

  Map<String, int>? thisMonthProReveList;
  Map<String, int>? todayReveProfit;
  Map<String, int>? customProfitRevenue;
  DateTime Date = DateTime.now();
  String? revenueShow;
  String? profitShow;
  bool visibileCheck = false;
  TextEditingController _dateStart = TextEditingController();
  TextEditingController _dateEnd = TextEditingController();
  final revenueProfitValidationKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    toGetTodayProReve();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                height: 55,
                child: DropdownButton<String>(
                  //Drop down widget .......
                  underline: SizedBox(),
                  hint: hintText,
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_downward_rounded),
                  ),
                  value: valuechoose,
                  items: listvalue.map((String newvalue) {
                    return DropdownMenuItem<String>(
                      value: newvalue,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(newvalue),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newvalue) async {
                    // Format the date using intl package
                    currentDate = DateFormat('yyyy/MM/dd').format(Date);
                    // Get the first day of the current month
                    DateTime firstDayOfMonth =
                        DateTime(Date.year, Date.month, 1);

                    // Format the date using intl package
                    startDate =
                        DateFormat('yyyy/MM/dd').format(firstDayOfMonth);
                    print('hello');
                    print(currentDate);
                    if (newvalue == 'This Month') {
                      thisMonthProReveList = await DatabaseHelper.instance
                          .getRevenueProfit(
                              widget.logeduserl[DatabaseHelper.columnId],
                              startDate,
                              currentDate);
                      print('total List');
                      print(thisMonthProReveList);

                      setState(() {
                        if (thisMonthProReveList != null &&
                            thisMonthProReveList!.isNotEmpty) {
                          revenueShow =
                              thisMonthProReveList!['revenueAmount'].toString();
                          profitShow =
                              thisMonthProReveList!['profitAmount'].toString();
                          print('hooooRvenu$revenueShow');
                        }
                      });
                    } else if (newvalue == 'Today') {
                      toGetTodayProReve();
                    }
                    setState(() {
                      valuechoose = newvalue;
                      if (newvalue == 'Custom Range') {
                        visibileCheck = true;
                      } else {
                        visibileCheck = false;
                      }
                    });
                  },
                  //close Drop down
                ),
              ),
            ),

            //  Visibility Widget  ========//

            Form(
              key: revenueProfitValidationKey,
              child: Visibility(
                  visible: visibileCheck,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 0),
                    child: Column(children: [
                      Container(
                        height: 60,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                _dateStart.text.trim().isEmpty) {
                              return 'Please fill the field';
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .nextFocus(); // Move focus to the next field
                          },
                          readOnly: true,
                          controller: _dateStart,
                          onChanged: (value) {
                            _dateEnd.text = value;
                          },
                          decoration: InputDecoration(
                            suffix: Container(
                              padding: EdgeInsets.all(0),
                              child: IconButton(
                                onPressed: () {
                                  _showDate1(
                                      DateTime.now(), context, _dateStart);
                                },
                                icon: Icon(
                                  Icons.date_range_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Choose Startin Date',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 60,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty ||
                                _dateEnd.text.trim().isEmpty) {
                              return 'Please fill the field';
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .nextFocus(); // Move focus to the next field
                          },
                          readOnly: true,
                          onChanged: (value) {
                            _dateEnd.text = value;
                          },
                          controller: _dateEnd,
                          decoration: InputDecoration(
                            suffix: Container(
                              padding: EdgeInsets.all(0),
                              child: IconButton(
                                onPressed: () {
                                  _showDate2(DateTime.now(), context, _dateEnd);
                                },
                                icon: Icon(
                                  Icons.date_range_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Choose Ending Date',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (revenueProfitValidationKey.currentState!
                                .validate()) {
                              setState(() {});
                              customProfitRevenue = await DatabaseHelper
                                  .instance
                                  .getRevenueProfit(
                                      widget
                                          .logeduserl[DatabaseHelper.columnId],
                                      _dateStart.text,
                                      _dateEnd.text);
                              setState(() {
                                if (customProfitRevenue != null &&
                                    customProfitRevenue!.isNotEmpty) {
                                  revenueShow =
                                      customProfitRevenue!['revenueAmount']
                                          .toString();
                                  profitShow =
                                      customProfitRevenue!['profitAmount']
                                          .toString();
                                }
                              });
                            }
                          },
                          child: Text('Submit'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color(0xFFBC6C25),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * .2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "lib/image/arcticons_folder-rupee.svg",
                          width: 50,
                        ),
                        Text(
                          'Revenue',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          revenueShow ?? '0',
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFFBC6C25),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 246, 225, 209),
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * .2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, left: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "lib/image/arcticons_folder-rupee.svg",
                          width: 50,
                        ),
                        Text(
                          'Profit',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          profitShow ?? '0',
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFFBC6C25),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // to show Date //
  void _showDate1(DateTime tapDate, BuildContext context, date) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        if (value == null) {
          return;
        } else {
          date.text = DateFormat('yyyy/MM/dd').format(value);
        }
      });
    });
  }

  void _showDate2(DateTime tapDate, BuildContext context, date) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        if (value == null) {
          return;
        } else {
          date.text = DateFormat('yyyy/MM/dd').format(value);
        }
      });
    });
  }

  // toGet Today profit and revenue  //
  toGetTodayProReve() async {
    final date = DateTime.now();
    final todayDate = DateFormat('yyyy/MM/dd').format(date);

    todayReveProfit = await DatabaseHelper.instance.getRevenueProfit(
        widget.logeduserl[DatabaseHelper.columnId], todayDate, todayDate);
    setState(() {
      if (todayReveProfit != null && todayReveProfit != null) {
        revenueShow = todayReveProfit!['revenueAmount'].toString();
        profitShow = todayReveProfit!['profitAmount'].toString();
      }
    });
  }
}
