// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Details_Screen/show_image.dart';

import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:flutter_application_1/Screens/widgets/Textwidget_details.dart';
import 'package:flutter_application_1/Screens/widgets/choiceChips.dart';
import 'package:flutter_application_1/Screens/widgets/dropButton.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenDetails extends StatefulWidget {
  ScreenDetails(
      {Key? key,
      required this.inputDetails,
      this.current,
      required this.loggedUser})
      : super(key: key);
  final current;
  final loggedUser;
  final Map<String, dynamic> inputDetails;

  @override
  State<ScreenDetails> createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  TextEditingController spareAmountController = TextEditingController();
  TextEditingController serviceAmountController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  final custSerChargeKey = GlobalKey<FormState>();
  String? status;
  String? value;
  int? spare;
  int? service;
  int? total;
  String? comments;
  int? detailcolumnId;
  String? securityCode;
  String? aproxAmount;
  int? spareUpdateCheck;
  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            service = data[0][DatabaseHelper.columnServiceCharge];
            spare = data[0][DatabaseHelper.columnSpareCharge];
            comments = data[0][DatabaseHelper.columnComments];
            detailcolumnId = data[0][DatabaseHelper.detailsColumnId];
            aproxAmount = data[0][DatabaseHelper.columnAmount];
            securityCode = data[0][DatabaseHelper.columnSecurityCode];
            total = (service ?? 0) + (spare ?? 0);

            serviceAmountController.text =
                service == 0 ? '' : service.toString();
            spareAmountController.text = spare == 0 ? '' : spare.toString();
            spareUpdateCheck = spare ?? 0;

            commentsController.text = comments ?? '';
            String inputDate =
                widget.inputDetails[DatabaseHelper.columnDeliveryDate];
            DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(inputDate);
            formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);
          }

          return WillPopScope(
            onWillPop: () async {
              if (status == 'Billed' &&
                  spareAmountController.text.isEmpty &&
                  serviceAmountController.text.isEmpty) {
                setState(() {});
                _showErrorSnackBar(
                    'Please fill in the service charge and spare amount');
                return false;
              } else {
                Navigator.of(context).pop(true);

                return true;
              }
            },
            child: Scaffold(
              backgroundColor: Color(0xFFECECEC),
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      if (status == 'Billed' &&
                          spareAmountController.text.isEmpty &&
                          serviceAmountController.text.isEmpty) {
                        setState(() {});
                        _showErrorSnackBar(
                            'Please fill in the service charge and spare amount');
                      } else {
                        Navigator.of(context).pop(true);
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                elevation: 0,
                backgroundColor: Color(0xFFECECEC),
              ),
              body: ListView(children: [
                Container(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 40,
                                          bottom: 14),
                                      child: Text(
                                        widget.inputDetails[
                                            DatabaseHelper.columnCustomerName],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 30,
                                          bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          DropButtonWidget(
                                              inputDetails: widget.inputDetails,
                                              onStatusChanged: (newStatus) {
                                                setState(() {
                                                  // Do anything you want when the status changes
                                                });
                                              }
                                              //
                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 190,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(text1st: 'Device :'),
                                          TextWidget(
                                              text1st: widget.inputDetails[
                                                  DatabaseHelper
                                                      .columnDeviceName]),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          TextWidget(text1st: 'Condition :'),
                                          TextWidget(
                                              text1st: widget.inputDetails[
                                                  DatabaseHelper
                                                      .columnDeviceCondition]),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          TextWidget(text1st: 'Mob.No :'),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  final Uri url = Uri(
                                                    scheme: 'tel',
                                                    path: widget.inputDetails[
                                                        DatabaseHelper
                                                            .columnMobNo],
                                                  );
                                                  if (await canLaunchUrl(url)) {
                                                    launchUrl(url);
                                                  } else {
                                                    print('cannot Call');
                                                  }
                                                },
                                                child: Text(
                                                    widget.inputDetails[
                                                        DatabaseHelper
                                                            .columnMobNo],
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: const Color
                                                                .fromARGB(255,
                                                            28, 129, 212))),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          TextWidget(
                                              text1st: 'Approx Amount :'),
                                          TextWidget(text1st: aproxAmount),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 150,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          TextWidget(text1st: 'Model :'),
                                          TextWidget(
                                              text1st: widget.inputDetails[
                                                  DatabaseHelper
                                                      .columnModelName]),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          TextWidget(
                                              text1st: 'Delivery Date :'),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.date_range_outlined,
                                                size: 20,
                                                color: Color(0xFFBC6C25),
                                              ),
                                              Text(
                                                formattedDate!,
                                                style: TextStyle(
                                                    color: Color(0xFF6D6D6D)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          TextWidget(
                                              text1st: 'Security Code :'),
                                          TextWidget(
                                            text1st: securityCode,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //  Top card endedd  //

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * .9,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Form(
                              key: custSerChargeKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24, horizontal: 20),
                                      child: Text(
                                        widget.inputDetails[DatabaseHelper
                                            .columnServiceRequired],
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFBC6C25),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),

                                  //  Display repaire Endedd  //

                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                        ),
                                        child: Container(
                                          width: 140,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE0F0E9),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 14,
                                                ),
                                                Icon(
                                                  Icons.folder_open_sharp,
                                                  size: 45,
                                                ),
                                                Text(
                                                  'Total',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  total.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20,
                                                    color: Color(0xFFBC6C25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      //   Total Amount Card  ended //

                                      InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        ScreenShowPicture(
                                                          loggeduser:
                                                              widget.loggedUser,
                                                          imagepath: widget
                                                                  .inputDetails[
                                                              DatabaseHelper
                                                                  .columnDeviceImage],
                                                        )));
                                          },
                                          // deatails page's gridview image . like stack
                                          child: ShowStackImage(
                                              image: widget.inputDetails[
                                                  DatabaseHelper
                                                      .columnDeviceImage]))

                                      // Photo card endedd   //
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, top: 15),
                                    child: TextWidget(
                                        text1st: 'Choose Spare used'),
                                  ),

                                  ChoiceChipsWidget(
                                      inputDetails: widget.inputDetails),

                                  //   choice chips   Endedd  //

                                  Column(
                                    children: [
                                      Container(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Add Spare Charge',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF6D6D6D),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 64,
                                            ),
                                            Text(
                                              'Add Service Charge',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF6D6D6D),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 140,
                                            height: 50,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Amount is required';
                                                }

                                                // Use the provided regex pattern to validate the amount
                                                if (!RegExp(r"^(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)$")
                                                        .hasMatch(value) &&
                                                    status == 'Billed') {
                                                  return 'Enter a valid amount';
                                                }

                                                return null; // Return null if the input is valid
                                              },
                                              controller: spareAmountController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF767676),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF767676),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Add Spare Field endedd   //
                                          ),
                                          Container(
                                            width: 140,
                                            height: 50,
                                            child: TextFormField(
                                              controller:
                                                  serviceAmountController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Amount is required';
                                                }

                                                // Use the provided regex pattern to validate the amount
                                                if (!RegExp(r"^(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)$")
                                                        .hasMatch(value) &&
                                                    status == 'Billed') {
                                                  return 'Enter a valid amount';
                                                }

                                                return null; // Return null if the input is valid
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF767676),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF767676),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Add Service charge endedd   //
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        'Add Comments',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF6D6D6D),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: 310,
                                        child: TextFormField(
                                          validator: (value) {
                                            return null;
                                          },
                                          controller: commentsController,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color(0xFF767676),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color(0xFF767676),
                                              ),
                                            ),
                                          ),
                                        ),

                                        //   Add commments endedd    //
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Container(
                                    width: 310,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (custSerChargeKey.currentState!
                                            .validate()) {
                                          int? spareAmount = int.tryParse(
                                              spareAmountController.text);
                                          if (spareAmount == null) {
                                            spareAmount = 0;
                                          }
                                          int? serviceAmount = int.tryParse(
                                              serviceAmountController.text);
                                          if (serviceAmount == null) {
                                            serviceAmount = 0;
                                          }
                                          String? comments =
                                              commentsController.text;
                                          if (comments.isEmpty) {
                                            comments = 'No Commets';
                                          }
                                          DatabaseHelper.instance
                                              .updateServiceChargeSpareCharge(
                                                  widget.inputDetails[
                                                      DatabaseHelper
                                                          .detailsColumnId],
                                                  spareAmount,
                                                  serviceAmount,
                                                  comments);

                                          // update stock amount //

                                          final tempLoged = await DatabaseHelper
                                              .instance
                                              .getLogedUser();
                                          final totalStock = tempLoged![
                                                  DatabaseHelper.columnStock]
                                              as int;

                                          spareAmount =
                                              spareAmount - spareUpdateCheck!;

                                          int? newStock =
                                              totalStock - spareAmount;

                                          DatabaseHelper.instance
                                              .userUpdateStock(
                                                  id: widget.loggedUser[
                                                      DatabaseHelper.columnId],
                                                  stock: newStock);

                                          final newRevenue =
                                              spareAmount + serviceAmount;

                                          DatabaseHelper.instance
                                              .updateProfitRevenue(
                                                  detailcolumnId,
                                                  newRevenue,
                                                  serviceAmount);

                                          // Navigator.pop(context);
                                          final currentDate = DateTime.now();
                                          final tempDate =
                                              DateFormat('yyyy/MM/dd')
                                                  .format(currentDate);
                                          final startingDate =
                                              currentDate.copyWith(day: 1);
                                          final tempStartingDate =
                                              DateFormat('yyyy/MM/dd')
                                                  .format(startingDate);

                                          profitAndRevenueNotifier.value =
                                              await DatabaseHelper.instance
                                                  .getRevenueProfit(
                                                      widget.loggedUser[
                                                          DatabaseHelper
                                                              .columnId],
                                                      tempStartingDate,
                                                      tempDate);
                                          profitAndRevenueNotifier
                                              // ignore: invalid_use_of_visible_for_testing_member
                                              .notifyListeners();
                                          Navigator.of(context).pop(true);
                                        }
                                      },
                                      child: Text('Submit'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFFBC6C25)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          );
        }
      },
    );
  }

  //new //
  void _showErrorSnackBar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      backgroundColor: Colors.red, // Set the background color of the snackbar
      behavior: SnackBarBehavior.floating, // Set the behavior of the snackbar
      shape: RoundedRectangleBorder(
        // Optional: Add rounded corners to the snackbar
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: Color(0xFFBC6C25)), // Optional: Add border to the snackbar
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
