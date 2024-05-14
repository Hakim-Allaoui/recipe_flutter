import 'package:flutter/material.dart';

import './app_fonts.dart';

class CustomeButtons {
  static Widget rectangleButton({
    required String title,
    required Function onTap,
    Color textColor = Colors.white,
    Color borderColor = Colors.transparent,
    Color buttonColor = Colors.white,
    bool loading = false,
  }) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextButton(
        // textColor: textColor,
        // color: buttonColor,
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ))
            : Text(
                title,
                style: TextStyle(
                    fontFamily: AppFonts.montserrat,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
        onPressed: () => onTap,
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(color: borderColor, width: 1),
        //   borderRadius: BorderRadius.circular(24.0),
        // ),
      ),
    );
  }

  static Widget circularButton(
    IconData iconData,
    Color buttonColor,
    Function onTap,
  ) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor),
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: () => onTap,
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
