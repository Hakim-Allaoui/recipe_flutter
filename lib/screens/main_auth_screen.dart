import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../screens/home_screen.dart';
import '../constant/custom_buttons.dart';
import '../screens/login_screen.dart';
import '../constant/static_string.dart';
import '../constant/app_fonts.dart';
import '../constant/app_images.dart';
import '../constant/shared_preferences_helper.dart';
import '../widget/process_indicator_view.dart';

class MainAuthScreen extends StatefulWidget {
  static const String routeName = '/main-auth-screen';

  MainAuthScreen();

  _MainAuthScreenState createState() => _MainAuthScreenState();
}

class _MainAuthScreenState extends State<MainAuthScreen> {
  // FacebookLogin facebookLogin;
  GoogleSignIn? googleSignin;
  AppSetting? appSettings;

  var _isSkippedLogin = true;
  var _isInit = true;
  bool _isLoading = false;
  bool _isApiCall = false;

  @override
  void initState() {
    // facebookLogin = FacebookLogin();
    googleSignin = GoogleSignIn();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // if (ModalRoute.of(context)!.isActive) {
    //   // GoogleAddmob.disposeBanner();
    //   // GoogleAddmob.myBanner = null;
    // }
    if (_isInit) {
      print(
          'main auth arguments ${ModalRoute.of(context)!.settings.arguments}');
      if (ModalRoute.of(context)!.settings.arguments != null) {
        _isSkippedLogin = ModalRoute.of(context)!.settings.arguments != null;
      }
    }
    _isInit = false;

    if (appSettings == null && !_isApiCall) {
      //Show Loader
      if (mounted) {
        setState(() => _isApiCall = true);
      }

      try {
        appSettings = await Provider.of<AuthProvider>(context, listen: false)
            .getAppSettings(context);
        if (mounted) {
          setState(() => _isApiCall = false);
        }
      } catch (error) {
        if (mounted) {
          setState(() => _isApiCall = false);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
    return Scaffold(
        body: Stack(
      children: [
        _buildBody(_isApiCall),
        _isSkippedLogin ? _buildCloseButton() : Container(),
      ],
    ));
  }

  Widget _buildBody(bool isLoading) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            AppImages.loginBg,
            fit: BoxFit.cover,
          ),
        ),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          AppImages.appLogo,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        padding:
                            EdgeInsets.only(right: 15.0, left: 15, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButtons.rectangleButton(
                                title: StaticString.login.toUpperCase(),
                                onTap: () => Navigator.of(context)
                                    .pushNamed(LoginScreen.routeName),
                                textColor: Colors.white,
                                borderColor: Colors.transparent,
                                buttonColor: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .secondary),
                            SizedBox(height: 20),
                            Text(
                              StaticString.dontHaveAccount,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: AppFonts.montserrat,
                              ),
                            ),
                            SizedBox(height: 20),
                            CustomButtons.rectangleButton(
                              title: StaticString.signUP.toUpperCase(),
                              onTap: () => Navigator.of(context).pushNamed(
                                  LoginScreen.routeName,
                                  arguments: true),
                              textColor:
                                  Theme.of(context).colorScheme.secondary,
                              buttonColor: Colors.transparent,
                              borderColor: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .secondary,
                            ),
                            SizedBox(height: 15),
                            _buildSocialLoginSection(),
                            !_isSkippedLogin ? Container() : _buildSkipButton(),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        _isLoading ? ProcessIndicatorView() : Container(),
      ],
    );
  }

  // Facebook Google Buttons

  Widget _buildHorizontalLine() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 10),
      child: Container(
        height: 1.0,
        width: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    final AppSetting appSetting =
        Provider.of<AuthProvider>(context, listen: false).appSettings;

    appSetting.isGoogleLogin = true;
    appSetting.isFacebookLogin = true;

    return appSetting.isFacebookLogin && appSetting.isGoogleLogin
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHorizontalLine(),
                  SizedBox(width: 5),
                  Text(
                    StaticString.socialLogin,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: AppFonts.montserrat),
                  ),
                  _buildHorizontalLine(),
                ],
              ),
              _buildSocialLoginButtons(appSetting),
              !_isSkippedLogin ? _buildSkipButton() : Container(),
            ],
          )
        : Container();
  }

  Widget _buildSocialLoginButtons(AppSetting appSetting) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        appSetting.isFacebookLogin
            ? CustomButtons.circularButton(
                IconData(
                  0xe901,
                  fontFamily: AppFonts.customIcon,
                ),
                Color.fromRGBO(65, 89, 147, 1),
                () async {
                  setState(() {
                    _isLoading = true;
                  });
                  // final facebookLogin = FacebookLogin();
                  // final result = await facebookLogin.logIn(['email']);
                  final result = 1; //await facebookLogin.logIn(['email']);

                  switch (/*result.status*/ result) {
                    // case FacebookLoginStatus.loggedIn:
                    case 0:
                      // var graphResponse = await http.get(
                      //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${result.accessToken.token}');

                      // var profile = json.decode(graphResponse.body);

                      // print('access token ${result.accessToken.token}');
                      // await singleSignOn(
                      //     token: result.accessToken.token,
                      //     type: SignOnType.Facebook);

                      break;
                    // case FacebookLoginStatus.cancelledByUser:
                    case 1:
                      SharedPreferencesHelper.setLoginStatus(false);
                      break;
                    // case FacebookLoginStatus.error:
                    case 2:
                      SharedPreferencesHelper.setLoginStatus(false);
                      break;
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
              )
            : Container(),
        appSetting.isGoogleLogin
            ? CustomButtons.circularButton(
                IconData(
                  0xe902,
                  fontFamily: AppFonts.customIcon,
                ),
                Color.fromRGBO(207, 85, 61, 1),
                () async {
                  setState(() {
                    _isLoading = true;
                  });
                  // final GoogleSignInAccount googleSignInAccount =
                  //     await googleSignin.signIn();
                  // final GoogleSignInAuthentication
                  //     googleSignInAuthentication =
                  //     await googleSignInAccount.authentication;

                  // print(
                  //     'accesstoken ${googleSignInAuthentication.accessToken}');
                  // print('idToken ${googleSignInAuthentication.idToken}');

                  // await singleSignOn(
                  //     token: googleSignInAuthentication.accessToken,
                  //     googleIdToken: googleSignInAuthentication.idToken,
                  //     type: SignOnType.Google);

                  setState(() {
                    _isLoading = false;
                  });
                },
              )
            : Container(),
      ],
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      child: Text(
        'Skip to Explore the App',
        style: TextStyle(
          color: Colors.white,
          fontFamily: AppFonts.montserrat,
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
      onPressed: () =>
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName),
    );
  }

  //Close button for model screen
  Widget _buildCloseButton() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Positioned(
      top: statusBarHeight + 10,
      left: 10,
      child: IconButton(
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).setScreenIsModel =
              false;
          Navigator.of(context).pop();
        },
        icon: Image.asset(
          AppImages.close,
          color: Colors.white,
          height: 30,
        ),
      ),
    );
  }

  //MARK: - Helper Function

  Future<void> singleSignOn({
    required String token,
    String? googleIdToken,
    required SignOnType type,
  }) async {
    try {
      final bool signIn =
          await Provider.of<AuthProvider>(context, listen: false)
              .signInWithSingleSignOn(
        context: context,
        accessToken: token,
        signOntype: type,
        googleIdToken: googleIdToken,
      );
      if (signIn) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
      }
    } catch (error) {
      print('error while login with facebook');
    }
  }
}
