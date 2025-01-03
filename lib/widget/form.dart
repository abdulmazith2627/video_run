import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  const FormText({super.key,
    required this.controller,
    required this.hint,
    required this.isPass,
    required this.isFilled,
    required this.max});
final TextEditingController controller;
final String hint;
final bool isPass;
final bool isFilled;
final int max;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controller,
      obscureText:isPass,
      maxLines:max,
      decoration:InputDecoration(
        hintText:hint,
        filled:isFilled,
        fillColor:Colors.white30,
        border:OutlineInputBorder(
          borderRadius:BorderRadius.circular(10)
        ),

      ),
    );
  }
}