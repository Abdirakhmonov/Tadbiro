import 'package:flutter/material.dart';

class MyTextFieldIcon extends StatelessWidget {
  final String hintText;
  final bool readOnly;
  final Widget suffixIcon;
  Function() onTap;

   MyTextFieldIcon({
    super.key,
    required this.hintText,
    required this.readOnly,
    required this.suffixIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
