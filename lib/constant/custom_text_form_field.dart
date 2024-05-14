import 'package:flutter/material.dart';

import './app_fonts.dart';
import './static_string.dart';

class CustomTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final String placeHolderText;
  final Function(String) onSaved;
  final Function(String)? onFieldSubmitted;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType inputType;
  final TextFieldType textFieldType;
  final String? initialText;
  final bool enabled;
  final bool hideborder;

  CustomTextFormField(
      {required this.focusNode,
      required this.placeHolderText,
      required this.onSaved,
      this.onFieldSubmitted,
      this.obscureText = false,
      this.inputType = TextInputType.emailAddress,
      this.textInputAction = TextInputAction.done,
      this.textFieldType = TextFieldType.Normal,
      this.initialText,
      this.enabled = true,
      this.hideborder = false});

  Widget _buildTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.black87),
      initialValue: initialText,
      focusNode: focusNode,
      textInputAction: textInputAction,
      enabled: enabled,
      enableInteractiveSelection: true,
      keyboardType: inputType,
      cursorColor: Colors.grey,
      decoration: customTxtInputDecoration(
          text: placeHolderText, hideBorder: hideborder),
      obscureText: obscureText,
      validator: (val) =>  validateText(val!),
      onSaved: (val) => onSaved(val!),
      onFieldSubmitted: onFieldSubmitted,
      autocorrect: false,
    );
  }

//Validate String...
  String? validateText(String text) {
    if (text.isEmpty && textFieldType == TextFieldType.Normal) {
      return '$placeHolderText is required';
    } else if ((text.isEmpty ||
            !RegExp(RegularExpression.emailRegx).hasMatch(text)) &&
        textFieldType == TextFieldType.Email) {
      return AlertMessageString.validEmail;
    } else if ((text.isEmpty || text.length < 8) &&
        textFieldType == TextFieldType.Password) {
      return AlertMessageString.validPassword;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextField();
  }
}

//Input Decoration....
InputDecoration customTxtInputDecoration({required String text,required  bool hideBorder}) {
  return InputDecoration(
      focusedErrorBorder: buildTextFieldBorderRadius(hideBorder),
      errorBorder: buildTextFieldBorderRadius(hideBorder),
      enabledBorder: buildTextFieldBorderRadius(hideBorder),
      focusedBorder: buildTextFieldBorderRadius(hideBorder),
      disabledBorder: buildTextFieldBorderRadius(hideBorder),
      hintText: text,
      hintStyle: setTextFieldTextStyle(),
      filled: true,
      contentPadding: EdgeInsets.symmetric(
          vertical: 13.0,
          horizontal: 15.0), //Adjust to set height of textField...
      fillColor: Colors.transparent);
}

//TextField Border...
OutlineInputBorder buildTextFieldBorderRadius(bool hideBorder) {
  return OutlineInputBorder(
      borderSide: hideBorder
          ? BorderSide.none
          : BorderSide(color: Color(0xFFE0E0E0), width: 1));
}

//Set Placeholder TextSize...
TextStyle setTextFieldTextStyle() {
  return TextStyle(
      color: Color(0xFF9E9E9E),
      fontWeight: FontWeight.w100,
      fontFamily: AppFonts.montserrat,
      fontSize: 14);
}

//TextField Type...
enum TextFieldType { Email, Password, Normal }

class RegularExpression {
  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
}
