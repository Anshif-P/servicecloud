// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/add_Screen/text_fil_widget.dart';
import 'package:flutter_application_1/Screens/home_screen/screen_home.dart';
import 'package:flutter_application_1/db/functions/db.functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ScreenAdd extends StatefulWidget {
  ScreenAdd({super.key, required this.logedUser});
  final logedUser;
  @override
  State<ScreenAdd> createState() => _ScreenAddState();
}

class _ScreenAddState extends State<ScreenAdd> {
  TextEditingController _date = TextEditingController();
  TextEditingController _deviceNameController = TextEditingController();
  TextEditingController _modelNameController = TextEditingController();
  TextEditingController _serviceRequiredController = TextEditingController();
  TextEditingController _deviceConditionController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _PhoneNumberController = TextEditingController();
  TextEditingController _securityCodeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final inputKey = GlobalKey<FormState>();
  String? chooseValue;
  File? image;

  @override
  void initState() {
    super.initState();
    _PhoneNumberController.text = '+91 ';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[300],
      ),
      body: Container(
        child: Form(
          key: inputKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19),
                child: Container(
                  width: 350,
                  height: 210,
                  child: InkWell(
                    onTap: () {
                      addImage();
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (image == null)
                            Center(
                              child: Icon(Icons.flip_camera_ios_outlined,
                                  size: 60, color: Colors.grey),
                            )
                          else
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Align(
                            alignment: Alignment.topRight,
                            child: image != null
                                ? IconButton(
                                    icon:
                                        Icon(Icons.close, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        image = null;
                                      });
                                    },
                                  )
                                : SizedBox(),
                          ),
                          if (image == null)
                            Positioned(
                              bottom: 50,
                              left: 100,
                              child: Text(
                                'Take Or Choose Photo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextfieldWidget(
                hintTexts: 'Enter Customer Name',
                formController: _customerNameController,
                formFieldValidator: (value) {
                  if (value.isEmpty ||
                      RegExp(r'^[a-zA-Z0-9]$').hasMatch(value)) {
                    return 'Enter correct name ';
                  } else {
                    return null;
                  }
                },
              ),
              TextfieldWidget(
                hintTexts: 'Enter Customer Mob.No',
                keyBoardType: true,
                formController: _PhoneNumberController,
                formFieldValidator: (value) {
                  if (value!.isEmpty ||
                      RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)").hasMatch(value)) {
                    return 'Please add phone number';
                  } else {
                    return null;
                  }
                },
              ),
              TextfieldWidget(
                hintTexts: 'Enter Device',
                formController: _deviceNameController,
                formFieldValidator: (value) {
                  if (value!.isEmpty ||
                      _deviceNameController.text.trim().isEmpty) {
                    return 'Enter Device name';
                  } else {
                    return null;
                  }
                },
              ),
              TextfieldWidget(
                hintTexts: 'Enter Model Name/ ID',
                formController: _modelNameController,
                formFieldValidator: (value) {
                  if (value!.isEmpty ||
                      _modelNameController.text.trim().isEmpty) {
                    return 'Enter model name';
                  } else {
                    return null;
                  }
                },
              ),
              TextfieldWidget(
                hintTexts: 'Enter Service Required',
                formController: _serviceRequiredController,
                formFieldValidator: (value) {
                  if (value!.isEmpty ||
                      _serviceRequiredController.text.trim().isEmpty) {
                    return 'Please fill the field';
                  } else {
                    return null;
                  }
                },
              ),
              TextfieldWidget(
                hintTexts: 'Enter Device Condition',
                formController: _deviceConditionController,
                formFieldValidator: (value) {
                  if (value!.isEmpty ||
                      _deviceConditionController.text.trim().isEmpty) {
                    return 'Please fill the field';
                  } else {
                    return null;
                  }
                },
              ),
              TextfieldWidget(
                hintTexts: 'Enter Security Code',
                formController: _securityCodeController,
                formFieldValidator: (value) {
                  if (value!.isEmpty ||
                      _securityCodeController.text.trim().isEmpty) {
                    return 'Please the field';
                  } else {
                    return null;
                  }
                },
              ),
              TextfieldWidget(
                hintTexts: 'Enter Amount(Appx.)',
                formController: _amountController,
                formFieldValidator: (value) {
                  if (value!.isEmpty || _amountController.text.trim().isEmpty) {
                    return 'Please the field';
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                child: Container(
                  height: 60,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || _date.text.trim().isEmpty) {
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
                    controller: _date,
                    decoration: InputDecoration(
                      suffix: Container(
                        padding: EdgeInsets.all(0),
                        child: IconButton(
                          onPressed: () {
                            _showDate(DateTime.now(), context);
                          },
                          icon: Icon(
                            Icons.date_range_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Choose Approx Delivery Date',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
                child: ElevatedButton(
                  style: ButtonStyle(
                    //
                    minimumSize: MaterialStateProperty.all(Size(366, 51)),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xFFBC6C25),
                    ),
                  ),
                  onPressed: () {
                    textfieldvalidation(widget.logedUser);
                  },
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // date //

  void _showDate(
    DateTime tapDate,
    BuildContext context,
  ) async {
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
          _date.text = DateFormat('dd/MM/yyyy').format(value);
        }
      });
    });
  }

  // Add image from camera or gallery //

  addImage() async {
    final imagePicker = ImagePicker();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Choose Image Source"),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFFBC6C25),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              final pickedImage = await imagePicker.pickImage(
                source: ImageSource.camera,
              );
              if (pickedImage == null) {
                return;
              }
              final imageFile = File(pickedImage.path);
              setState(() {
                this.image = imageFile;
              });
            },
            child: Text("Camera"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFFBC6C25),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              final pickedImage = await imagePicker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedImage == null) {
                return;
              }
              final imageFile = File(pickedImage.path);
              setState(() {
                this.image = imageFile;
              });
            },
            child: Text("Gallery"),
          ),
        ],
      ),
    );
  }

  // image add error message

  errorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: Colors.red,
        content: Text('Add Profile Photo')));
  }

  // Add input message //

  successfullyAdded(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        margin: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Sucessfully added')));
  }

  // Text field validation   //

  textfieldvalidation(logedUser) async {
    if (image == null || image!.path.isEmpty) {
      errorMessage(context);

      return;
    }
    if (inputKey.currentState!.validate()) {
      DateTime currentDate = DateTime.now();
      String Date = DateFormat('yyyy/MM/dd').format(currentDate);

      String deviceName = _deviceNameController.text;
      String modelName = _modelNameController.text;
      String serviceRequired = _serviceRequiredController.text;
      String deviceCondition = _deviceConditionController.text;
      String customerName = _customerNameController.text;
      String phoneNumber = _PhoneNumberController.text;
      String sequrityCode = _securityCodeController.text;
      String amount = _amountController.text;
      String deliveryDate = _date.text;
      final imagefile = File(image!.path.toString());
      String deviceimage = imagefile.path;
      int id = logedUser[DatabaseHelper.columnId];
      String status = 'Processing';

      ;

      Map<String, dynamic> details = {
        DatabaseHelper.columnDeviceName: deviceName,
        DatabaseHelper.columnModelName: modelName,
        DatabaseHelper.columnServiceRequired: serviceRequired,
        DatabaseHelper.columnDeviceCondition: deviceCondition,
        DatabaseHelper.columnCustomerName: customerName,
        DatabaseHelper.columnMobNo: phoneNumber,
        DatabaseHelper.columnSecurityCode: sequrityCode,
        DatabaseHelper.columnAmount: amount,
        DatabaseHelper.columnDeliveryDate: deliveryDate,
        DatabaseHelper.columnDeviceImage: deviceimage,
        DatabaseHelper.userId: id,
        DatabaseHelper.columnServiceStatus: status,
        DatabaseHelper.columnDate: Date,
      };
      // value Notifier        //
      pendingFinishedNotifier.value = await DatabaseHelper.instance
          .getFinishedPendingDetails(widget.logedUser[DatabaseHelper.columnId]);
      // ignore: invalid_use_of_visible_for_testing_member
      pendingFinishedNotifier.notifyListeners();
      successfullyAdded(context);

      await DatabaseHelper.instance.insertInputRecord(details);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ScreenHome(
                logedusr: logedUser,
              )));
    }
  }
}
