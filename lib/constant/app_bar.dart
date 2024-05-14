import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './app_fonts.dart';
import 'static_string.dart';

AppBar buildAppBar(String title, BuildContext context,
    {bool hideBackButton = false, List<Widget>? actions}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
    leading: hideBackButton
        ? Container()
        : IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () => Navigator.pop(context),
          ),
    title: CustomText(
      txtColor: Colors.black,
      txtFontName: AppFonts.montserrat,
      txtFontStyle: FontWeight.bold,
      txtSize: 23,
      txtTitle: title,
    ),
    actions: actions, systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}

class CustomText extends StatelessWidget {
  final String txtTitle;
  final double txtSize;
  final String txtFontName;
  final Color txtColor;
  final FontWeight txtFontStyle;
  final TextAlign align;
  final double letterSpacing;
  final int? maxLine;
  final TextOverflow? textOverflow;

  CustomText(
      {
      required this.txtTitle,
      required this.txtSize,
      required this.txtFontName,
      this.txtColor = Colors.white,
      this.txtFontStyle = FontWeight.normal,
      this.align = TextAlign.center,
      this.letterSpacing = 0,
      this.maxLine,
      this.textOverflow});

  //1. WelCome Back String...(Login Page)
  Widget buildLoginTitleString() {
    return CustomText(
      txtTitle: StaticString.loginTitle,
      txtColor: Colors.black,
      txtFontName: AppFonts.montserrat,
      txtSize: 36,
      txtFontStyle: FontWeight.bold,
    );
  }

  //2. Login Account String...(Login Page)
  Widget buildGoodToSeeAgainString() {
    return CustomText(
      txtTitle: StaticString.goodToSeeAgain,
      txtColor: Colors.grey,
      txtFontName: AppFonts.montserrat,
      txtSize: 14,
      txtFontStyle: FontWeight.w100,
    );
  }

  //1. WelCome Back String...(Sign Up page)
  Widget buildSignUpString() {
    return CustomText(
      txtTitle: StaticString.signUP.toUpperCase(),
      txtColor: Colors.black,
      txtFontName: AppFonts.montserrat,
      txtSize: 35,
      txtFontStyle: FontWeight.bold,
    );
  }

//2. Create Account String...(SignUp Page)
  Widget buildNiceToMetYouSting() {
    return CustomText(
      txtTitle: StaticString.niceToMetYou,
      txtColor: Colors.black,
      txtFontName: AppFonts.montserrat,
      txtSize: 14,
      txtFontStyle: FontWeight.w100,
    );
  }

  //1. Forgot Password String...(Forgot Password Page)
  Widget buildForgotPasswordHeadString() {
    return CustomText(
      txtTitle: StaticString.forgotPasswordHead,
      txtColor: Colors.black,
      txtFontName: AppFonts.montserrat,
      txtSize: 30,
      txtFontStyle: FontWeight.bold,
    );
  }

//2. Forgot Password SubHead String...(forgot Password Page)
  Widget buildForgotPasswordSubHeadString() {
    return CustomText(
      txtTitle: StaticString.forgotPassowrdSubHead,
      txtColor: Colors.black87,
      txtFontName: AppFonts.montserrat,
      txtSize: 15,
      txtFontStyle: FontWeight.w100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$txtTitle',
      style: TextStyle(
          letterSpacing: letterSpacing,
          fontSize: txtSize,
          fontFamily: txtFontName,
          color: txtColor,
          fontWeight: txtFontStyle),
      softWrap: true,
      textAlign: align,
      maxLines: maxLine,
      overflow: textOverflow,
    );
  }
}
