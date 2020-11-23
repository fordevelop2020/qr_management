import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_management/models/home_model.dart';
import 'package:qr_management/shared/globals.dart';

class TextForm2Field extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
 // final Function onChanged;
  final Function validator;
  final Function onSaved;

  TextForm2Field({
    this.hintText,
    this.validator,
   // this.onSaved,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);

    return TextField(
     // onChanged: onSaved,
      onChanged: onSaved,
      obscureText: obscureText,
      cursorColor: Color(0xff3282b8),
      style: TextStyle(
        color: Color(0xff3282b8),
        fontSize: 14.0,
      ),


      decoration: InputDecoration(
        labelStyle: TextStyle(color:Color(0xff3282b8)),
        focusColor: Color(0xff3282b8),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xff3282b8)),
        ),
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Color(0xff3282b8),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: Color(0xff3282b8),
          ),
        ),
      ),
    );
  }
}