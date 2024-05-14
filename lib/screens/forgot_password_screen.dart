import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/app_images.dart';

import '../constant/custom_buttons.dart';
import '../constant/custom_text_form_field.dart';
import '../constant/static_string.dart';
import '../constant/custom_dialog.dart';
import '../provider/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = './forgot_password_screen';

  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();

  bool _isLoading = false;
  AppBar? _appBar;

  Map<String, String> _authData = {'email': ''};

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.loginBg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: deviceSize.height > 568
                      ? deviceSize.height -
                          padding.top -
                          padding.bottom -
                          _appBar!.preferredSize.height
                      : deviceSize.height - padding.top,
                  width: deviceSize.width,
                  child: Column(
                    mainAxisAlignment: deviceSize.height > 568
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[_buildForm()],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget  _buildAppBar() {
    _appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    return _appBar!;
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.82,
          decoration: getBoxDecoration(),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset(
                AppImages.appLogo,
                width: MediaQuery.of(context).size.width / 2,
              ),
              SizedBox(height: 30),
              _buildEmailFormfield(),
              SizedBox(height: 30),
              CustomeButtons.rectangleButton(
                onTap: _submit,
                title: StaticString.submit.toUpperCase(),
                buttonColor: Theme.of(context).buttonTheme.colorScheme!.background,
                loading: _isLoading,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0.0, 10.0),
          blurRadius: 10.0,
        ),
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0.0, -10.0),
          blurRadius: 10.0,
        ),
      ],
    );
  }

  Widget _buildEmailFormfield() {
    return CustomTextFormField(
      placeHolderText: StaticString.email,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.done,
      textFieldType: TextFieldType.Email,
      onSaved: (value) {
        _authData['email'] = value;
      },
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    print(_formKey.currentState!.validate());
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final String message = await Provider.of<AuthProvider>(context)
          .forgotPassword(userDtails: _authData, context: context);

      setState(() {
        _isLoading = false;
      });

      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: 'Success!!!',
              description: message,
              buttonText: 'Okay',
              alertType: CustomDialogType.Success,
              onTap: () {
                Navigator.of(context).pop();
              },
            );
          });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
