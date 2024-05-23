import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/app_images.dart';

import '../constant/app_fonts.dart';
import '../screens/home_screen.dart';
import '../constant/custom_text_form_field.dart';
import '../constant/static_string.dart';
import '../constant/custom_buttons.dart';
import '../screens/forgot_password_screen.dart';
import '../provider/auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  bool isForSignup = false;

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      isForSignup = ModalRoute.of(context)!.settings.arguments as bool;
    }

    super.didChangeDependencies();
  }

  bool _isLoading = false;
  AppBar? appBar;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

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
                          appBar!.preferredSize.height
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

  PreferredSizeWidget _buildAppBar() {
    appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      ),
    );
    return appBar!;
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
              Image.asset(
                AppImages.appLogo,
                width: MediaQuery.of(context).size.width / 2,
              ),
              SizedBox(height: 30),
              _buildNameFormField(),
              _buildEmailFormfield(),
              SizedBox(height: 10),
              _buildPasswordFormField(),
              SizedBox(height: 20),
              CustomButtons.rectangleButton(
                onTap: _submit,
                title: isForSignup
                    ? StaticString.createAccount.toUpperCase()
                    : StaticString.login.toUpperCase(),
                buttonColor:
                    Theme.of(context).buttonTheme.colorScheme!.background,
                loading: _isLoading,
              ),
              SizedBox(height: 10),
              !isForSignup
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ForgotPasswordScreen.routeName);
                      },
                      child: Text(
                        StaticString.forgotPassword,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: AppFonts.montserrat),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameFormField() {
    return isForSignup
        ? Column(
            children: <Widget>[
              CustomTextFormField(
                placeHolderText: StaticString.name,
                focusNode: _nameFocusNode,
                textInputAction: TextInputAction.next,
                textFieldType: TextFieldType.Normal,
                onSaved: (value) {
                  _authData['name'] = value;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              SizedBox(height: 10),
            ],
          )
        : Container();
  }

  Widget _buildEmailFormfield() {
    return CustomTextFormField(
      placeHolderText: StaticString.email,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      textFieldType: TextFieldType.Email,
      onSaved: (value) {
        _authData['email'] = value;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  Widget _buildPasswordFormField() {
    return CustomTextFormField(
      focusNode: _passwordFocusNode,
      placeHolderText: StaticString.password,
      onSaved: (value) {
        _authData['password'] = value;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      //KeyBoard Done Bttn
      textFieldType: TextFieldType.Password,
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
      final bool isLoggedIn = isForSignup
          ? await Provider.of<AuthProvider>(context,
                  listen: false) // Sign up request
              .signupUser(context: context, parameter: _authData)
          : await Provider.of<AuthProvider>(context, listen: false).loginUser(
              parameter: _authData,
              signOnType: SignOnType.Regular,
              context: context); // Log in request

      if (isLoggedIn && !isForSignup) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }
}
