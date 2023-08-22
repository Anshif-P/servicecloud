import 'package:flutter/material.dart';

class EmailPassField extends StatelessWidget {
  final TextEditingController formController;
  final String hintText;
  final String? Function(String?) validatorField;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;
  EmailPassField({
    required this.formController,
    required this.hintText,
    required this.validatorField,
    this.obscureText = false,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: formController,
      validator: validatorField,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFBC6C25),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFBC6C25),
          ),
        ),
      ),
      onEditingComplete: () {
        FocusScope.of(context).nextFocus(); // Move focus to the next field
      },
    );
  }
}
