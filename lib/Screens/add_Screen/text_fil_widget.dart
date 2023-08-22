import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextfieldWidget extends StatefulWidget {
  final String hintTexts;
  bool keyBoardType;
  FormFieldValidator formFieldValidator;
  TextEditingController formController = TextEditingController();

  TextfieldWidget({
    super.key,
    this.keyBoardType = false,
    required this.hintTexts,
    required this.formController,
    required this.formFieldValidator,
  });

  @override
  State<TextfieldWidget> createState() => _TextfieldWidgetState();
}

class _TextfieldWidgetState extends State<TextfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        keyboardType: widget.keyBoardType == true
            ? TextInputType.number
            : TextInputType.text,
        controller: widget.formController,
        validator: widget.formFieldValidator,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintTexts,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        onEditingComplete: () {
          FocusScope.of(context).nextFocus(); // Move focus to the next field
        },
      ),
    );
  }
}
