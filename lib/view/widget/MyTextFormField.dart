// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.perfixIcon,
    this.validator,
    this.suffixIcon,
    this.typeInput,
    this.obscureText = false,
  });
  final String hintText;
  final TextEditingController controller;
  final Widget perfixIcon;
  TextInputType? typeInput;
  final bool obscureText;
  String? Function(String?)? validator;
  Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: typeInput,
      decoration: InputDecoration(
        
        prefixIcon: perfixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.normal,
            ),
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
