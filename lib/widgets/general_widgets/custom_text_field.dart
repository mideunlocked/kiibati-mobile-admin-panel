import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.inputAction = TextInputAction.next,
    required this.hint,
    required this.label,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final TextInputAction inputAction;
  final Widget? suffixIcon;
  final String hint;
  final String label;

  @override
  Widget build(BuildContext context) {
    var of = Theme.of(context);
    var textTheme = of.textTheme;
    var bodyMedium = textTheme.bodyMedium;
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.black26),
    );
    var primaryColor = of.primaryColor;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        style: bodyMedium,
        cursorColor: primaryColor,
        maxLines: 10,
        minLines: 1,
        textInputAction: inputAction,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: bodyMedium?.copyWith(
            color: Colors.black38,
          ),
          labelStyle: bodyMedium?.copyWith(
            color: Colors.black,
          ),
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Colors.black),
          ),
          suffixIcon: suffixIcon,
          errorBorder: outlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
