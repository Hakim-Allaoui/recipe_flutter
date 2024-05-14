import 'package:flutter/material.dart';

LinearGradient setGradiantColor(
    {required Color topColor,required  Color bottomColor,required  List<double> stops}) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.09, 0.99],
    colors: [topColor, bottomColor],
  );
}

//Set Card Shadow...
BoxDecoration cardDecoration({required BuildContext context, double radius = 3}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    color: Theme.of(context).primaryColor,
    boxShadow: [
      BoxShadow(
        blurRadius: radius,
        spreadRadius: 3,
        color: Theme.of(context).textTheme.bodyMedium!.shadows!.first.color, //Colors.grey.withOpacity(0.2),
      )
    ],
  );
}

InputDecoration contactUsTextDecoration({required BuildContext context, required String text, required String font}) {
  return InputDecoration(
    hintStyle: TextStyle(
        color: Theme.of(context).textTheme.titleSmall!.color,
        fontWeight: FontWeight.w100,
        fontFamily: font,
        fontSize: 17),
    hintText: text,
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
  );
}
