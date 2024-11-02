import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final String hintText;
  final bool obsecureText;
  final String? Function(String?)? validator;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.prefixIcon,
      required this.hintText,
      required this.obsecureText,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: primaryColor, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: errorColor, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: errorColor, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            hintStyle: const TextStyle(
              color: hintTextColor,
            )).copyWith(
          prefixIcon: Icon(
            prefixIcon,
            color: primaryColor,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
