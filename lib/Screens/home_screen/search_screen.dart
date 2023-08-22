import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/card_widget.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:lottie/lottie.dart';

class ScreenSearch extends StatefulWidget {
  ScreenSearch({super.key, required this.loggedUser});
  final loggedUser;

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  List<Map<String, dynamic>> filterList = [];
  List<Map<String, dynamic>> allDetailsList = [];
  bool isFoundResult = false;

  @override
  void initState() {
    super.initState();
    filteredList(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 93, 91, 91),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Search for Customers',
          style: TextStyle(
            fontSize: 12,
            color: const Color.fromARGB(255, 50, 48, 48),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            width: 375,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 1, // Spread radius of the shadow
                  blurRadius: 5, // Blur radius of the shadow
                  offset: Offset(0, 3), // Offset of the shadow
                ),
              ],

              // Border radius of the container
            ),
            child: TextField(
              onChanged: (value) {
                filteredList(value);
              },
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                hintText: 'Search Customers',
                hintStyle: TextStyle(color: Color(0xFF6D6D6D), fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 106, 102, 102),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 203, 203, 208)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 203, 203, 208)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isFoundResult == true
          ? ListView.builder(
              itemCount: filterList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> detail = filterList[index];
                return CardWidget(
                    number: detail[DatabaseHelper.columnMobNo],
                    complaint: detail[DatabaseHelper.columnServiceRequired],
                    image: detail[DatabaseHelper.columnDeviceImage],
                    loggedUser: widget.loggedUser,
                    current: 0,
                    name: detail[DatabaseHelper.columnCustomerName],
                    device: detail[DatabaseHelper.columnDeviceName],
                    date: detail[DatabaseHelper.columnDeliveryDate],
                    iputDetails: filterList[index]);
              })
          : Center(
              child: Container(
                height: 290,
                width: 200,
                child: Column(
                  children: [
                    Lottie.asset('lib/image/lottie.json'),
                    Text(
                      'No data found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  filteredList(String? search) async {
    if (search == null) {
      allDetailsList = await DatabaseHelper.instance.getLogedUserInputDetails(
        widget.loggedUser[DatabaseHelper.columnId],
      );
      setState(() {});
    } else if (search.isNotEmpty) {
      String searchLowerCase = search.toLowerCase();

      filterList = allDetailsList.where((details) {
        String customerName = details['customerName'].toString().toLowerCase();
        String mobileNumber = details['mobNo'].toString().toLowerCase();

        return customerName.contains(searchLowerCase) ||
            mobileNumber.contains(searchLowerCase);
      }).toList();

      if (filterList.isEmpty) {
        isFoundResult = false;
      } else {
        isFoundResult = true;
      }
      setState(() {});
    } else {
      setState(() {});
      isFoundResult = false;
    }
  }
}
