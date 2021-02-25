import 'package:flutter/material.dart';
import 'package:qr_management/shared/globals.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  final Function onPressed;
  final Function validator;
  final Function onSaved;

  ButtonWidget({
    this.title,
    this.hasBorder,
    this.onPressed,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: hasBorder ? Global.white : Color(0xff3282b8),
          borderRadius: BorderRadius.circular(10),

          border: hasBorder
              ? Border.all(
            color: Color(0xff3282b8),
            width: 1.0,
          )
              : Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40.0,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: hasBorder ? Color(0xff3282b8): Global.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,

                ),

              ),
            ),
          ),
        ),
      ),
    );
  }
}