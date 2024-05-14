import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

import '../constant/shared_preferences_helper.dart';
import '../api/api_call.dart';
import '../provider/user.dart';
import '../constant/custom_dialog.dart';

AuthResponse authInfoFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authInfoToJson(AuthResponse data) => json.encode(data.toJson());

enum SignOnType {
  Facebook,
  Google,
  Regular,
}

class AuthProvider with ChangeNotifier {
  bool _loginStatus = false;
  bool _screenIsModel = false;
  bool _adMobStatus = true;
  AppSetting appSettings = AppSetting();

  final fb = FacebookLogin();

  bool get getScreenIsModel {
    print('Admob status in getter $_screenIsModel');
    return _screenIsModel;
  }

  set setScreenIsModel(bool screenIsModel) {
    _screenIsModel = screenIsModel;
  }

  bool get getAdmobStatus {
    print('Admob status in getter $_adMobStatus');
    return _adMobStatus;
  }

  set setAdmobStatus(bool adMobStatus) {
    _adMobStatus = adMobStatus;
  }

  bool get loginStatus {
    print('Login status in getter $_loginStatus');
    return _loginStatus;
  }

  Future<bool> tryAuthLogin() async {
    final status = await SharedPreferencesHelper.getLoginStatus();
    print('auto login login status $_loginStatus');
    if (status == false) {
      return false;
    }

    _loginStatus = true;
    notifyListeners();
    return status;
  }

  Future<void> logout() async {
    await SharedPreferencesHelper.removeUserDetail();
    _loginStatus = false;
  }

  Future<bool> saveAuthInfo({
    required String singleSignOnToken,
    required SignOnType signOnType,
    String authToken = "",
  }) {
    List<String> type = ["facebook", "google", "regular"];

    AuthResponse authResponse = AuthResponse(
      authToken: authToken,
      signOnType: type[signOnType.index],
      singleSignOnToken: singleSignOnToken,
    );

    String authString = authInfoToJson(authResponse);
    return SharedPreferencesHelper.setAuthInfo(authString);
  }

  Future<bool> loginUser({
    required BuildContext context,
    required SignOnType signOnType,
    Map<String, String>? parameter,
  }) async {
    try {
      dynamic responseData = await ApiCall.callService(
          context: context,
          requestType: signOnType == SignOnType.Regular
              ? HTTPRequestType.POST
              : HTTPRequestType.GET,
          webApi: signOnType == SignOnType.Regular
              ? API.RegularLogin
              : API.SingleSignOn,
          parameter: parameter!);

      if (responseData == AppException) {
        return false;
      } else {
        UserResponse userInfo = userFromJson(responseData);

        SharedPreferencesHelper.setUserDetail(responseData);
        SharedPreferencesHelper.setLoginStatus(true);

        if (signOnType == SignOnType.Regular) {
          await saveAuthInfo(
            singleSignOnToken: "",
            signOnType: signOnType,
            authToken: userInfo.data.token,
          );
        }
        _loginStatus = true;

        return true;
      }
    } catch (error) {
      SharedPreferencesHelper.setLoginStatus(false);
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: error is NoInternetException ? 'No Internet!!!' : 'Error!!!',
            buttonText: 'Okay',
            description: error.toString(),
            alertType: error is NoInternetException
                ? CustomDialogType.NoInternet
                : CustomDialogType.Error,
          );
        },
      );
      throw error;
    }
  }

  Future<bool> signupUser({
    required BuildContext context,
    Map<String, String>? parameter,
  }) async {
    try {
      dynamic responseData = await ApiCall.callService(
          context: context,
          requestType: HTTPRequestType.POST,
          webApi: API.SignUp,
          parameter: parameter!);

      if (responseData == AppException) {
        return false;
      } else {
        String message = json.decode(responseData)['message'];
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: 'Verify Account',
              buttonText: 'Okay',
              description: message,
              alertType: CustomDialogType.Success,
              onTap: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
        return true;
      }
    } catch (error) {
      SharedPreferencesHelper.setLoginStatus(false);
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: error is NoInternetException ? 'No Internet!!!' : 'Error!!!',
            buttonText: 'Okay',
            description: error.toString(),
            alertType: error is NoInternetException
                ? CustomDialogType.NoInternet
                : CustomDialogType.Error,
          );
        },
      );
      throw error;
    }
  }

  Future<AppSetting?> getAppSettings(BuildContext context) async {
    try {
      dynamic responseData = await ApiCall.callService(
          context: context,
          requestType: HTTPRequestType.GET,
          webApi: API.GetSettings);

      if (responseData == AppException) {
        notifyListeners();
      } else {
        final AppSettingsResponse appSettingsResponse =
            AppSettingsResponse.fromJson(json.decode(responseData));
        if (appSettingsResponse.status != null && appSettingsResponse.status!) {
          appSettings = appSettingsResponse.appSetting!;
        }
        // notifyListeners();
      }
      return appSettings;
    } catch (error) {
      notifyListeners();
      return null;
    }
  }

  //SignIn With Facebook...
  /*Future<bool> signInWithSingleSignOn({
    required BuildContext context,
    required String accessToken,
    required SignOnType signOntype,
    String? googleIdToken,
  }) async {
    try {
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

      // Check result status
      switch (res.status) {
        case FacebookLoginStatus.success:
          // Logged in

          // Send access token to server for validation and auth
          final FacebookAccessToken? accessToken = res.accessToken;
          print('Access token: ${accessToken!.token}');

          // Get profile data
          final profile = await fb.getUserProfile();
          print('Hello, ${profile!.name}! You ID: ${profile.userId}');

          // Get user profile image url
          final imageUrl = await fb.getProfileImageUrl(width: 100);
          print('Your profile image: $imageUrl');

          // Get email (since we request email permission)
          final email = await fb.getUserEmail();
          // But user can decline permission
          if (email != null) print('And your email is $email');

          break;
        case FacebookLoginStatus.cancel:
          // User cancel log in
          break;
        case FacebookLoginStatus.error:
          // Log in failed
          print('Error while log in: ${res.error}');
          break;
      }

      //Facebook Auth Credential...
      AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      if (signOntype == SignOnType.Google) {
        credential = GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: googleIdToken,
        );
      }

      //Auth Result...
      AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      //User Detail...
      FirebaseUser firebaseUser = authResult.user;

      //Get ID Token...
      IdTokenResult idToken = await firebaseUser.getIdToken(refresh: true);

      bool isValidUser = false;
      //Save firebase and Facebook Token...

      bool savedInfo = await saveAuthInfo(
        singleSignOnToken: accessToken,
        signOnType: signOntype,
        authToken: idToken.token,
      );
      if (savedInfo) {
        isValidUser = await loginUser(context: context, signOnType: signOntype);
      }

      return isValidUser;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }*/

  Future<String> forgotPassword({
    required BuildContext context,
    required Map<String, String> userDtails,
  }) async {
    try {
      String dataResponse = await ApiCall.callService(
          context: context,
          webApi: API.ForgotPassword,
          requestType: HTTPRequestType.POST,
          parameter: userDtails);

      String message = json.decode(dataResponse)['message'];
      return message;
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: error is NoInternetException ? 'No Internet!!!' : 'Error!!!',
            buttonText: 'Okay',
            description: error.toString(),
            alertType: error is NoInternetException
                ? CustomDialogType.NoInternet
                : CustomDialogType.Error,
          );
        },
      );
      throw error;
    }
  }

  void signOutGoogle() async {
    await GoogleSignIn().signOut();
    print("User Sign Out");
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

  signInWithSingleSignOn({required BuildContext context, required String accessToken, required SignOnType signOntype, String? googleIdToken}) {}
}

class AuthResponse {
  String? authToken = '';
  String? signOnType = '';
  String? singleSignOnToken = '';

  AuthResponse({
    this.authToken,
    this.signOnType,
    this.singleSignOnToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        authToken: json['authToken'],
        signOnType: json['signOnType'],
        singleSignOnToken: json['singleSignOnToken'],
      );

  Map<String, dynamic> toJson() => {
        "authToken": authToken,
        "signOnType": signOnType,
        "singleSignOnToken": singleSignOnToken,
      };
}

class AppSettingsResponse {
  bool? status;
  int? code;
  AppSetting? appSetting;

  AppSettingsResponse({this.status, this.code, this.appSetting});

  factory AppSettingsResponse.fromJson(Map<String, dynamic> json) {
    return AppSettingsResponse(
      status: json['status'],
      code: json['code'],
      appSetting: AppSetting.fromJson(json['data']),
    );
  }
}

class AppSetting {
  bool isFacebookLogin;
  bool isGoogleLogin;

  AppSetting({
    this.isFacebookLogin = false,
    this.isGoogleLogin = false,
  });

  factory AppSetting.fromJson(Map<String, dynamic> json) => AppSetting(
      isFacebookLogin: json['is_facebook_login'] == "N" ? false : true,
      isGoogleLogin: json['is_google_login'] == "N" ? false : true);

  // when push Must Replace with

  // isFacebookLogin: json['is_facebook_login'] == "N" ? false : true,
  // isGoogleLogin: json['is_google_login'] == "N" ? false : true);
}
