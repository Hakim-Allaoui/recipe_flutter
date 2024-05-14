import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../api/api_call.dart';
import '../constant/shared_preferences_helper.dart';
import './auth.dart';
import '../constant/custom_dialog.dart';

class UserProvider with ChangeNotifier {
  UserItem? _user;

  UserItem get getUserInfo {
    return _user!;
  }

  Future<void> fetchUserInfo() async {
    String userDetail = await SharedPreferencesHelper.getUserDetail();
    UserResponse userInfo = userFromJson(userDetail);
    _user = userInfo.data;
    notifyListeners();
    // UserItem user = userFromJson(userDetail);
  }

  Future<bool> updateUserDetails({
    required BuildContext context,
    UserItem? userInfo,
    File? imageFile,
  }) async {
    try {
      final String info = await SharedPreferencesHelper.getAuthInfo();
      AuthResponse authInfo =
          info.isEmpty ? AuthResponse() : authInfoFromJson(info);

      String token = authInfo.authToken!;

      //Get refresh Token...
      if (authInfo.signOnType != "regular" && authInfo.signOnType != "") {
        // token = await ApiHelper.getCurrentUserToken();
      }

  

      String dataResponse = await ApiCall.upload(
        context: context,
        imageFile: imageFile!,
        isSingleSignOn: authInfo.signOnType == "regular" ? false : true,
        token: token,
        userInfo: userInfo!,
      );


      SharedPreferencesHelper.setUserDetail(dataResponse);

      return true;
    } catch (error) {
      //Show no internet alert
      return false;
    }
  }

  Future<bool> deleteAccount({required BuildContext context}) async {
    try {
      String dataResponse = await ApiCall.callService(
        context: context,
        requestType: HTTPRequestType.DELETE,
        webApi: API.DeleteAccount,
      );
      String message = json.decode(dataResponse)['message'];

      //Remove stored data...
      await SharedPreferencesHelper.removeUserDetail();
      //Show message in alert...
      print(message);
      return true;
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
}

UserResponse userFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  bool status;
  int code;
  UserItem data;

  UserResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        status: json["status"],
        code: json["code"],
        data: UserItem.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "data": data.toJson(),
      };
}

class UserItem {
  String userId;
  String firstname;
  String lastname;
  String profileImageUrl;
  String phone;
  String email;
  String token;

  UserItem({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.profileImageUrl,
    required this.phone,
    required this.email,
    required this.token,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        userId: json["user_id"],
        firstname: json["firstname"] == "" ? 'N/A' : json["firstname"],
        lastname: json["lastname"] == "" ? 'N/A' : json["lastname"],
        profileImageUrl: json["profile_image_url"],
        phone: json["phone"] == "" ? 'N/A' : json["phone"],
        email: json["email"] == "" ? 'N/A' : json["email"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "firstname": firstname,
        "lastname": lastname,
        "profile_image_url": profileImageUrl,
        "phone": phone,
        "email": email,
        "token": token,
      };
}
