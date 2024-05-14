import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  //Shared Preference Keys
  static final String _kIsLoggedIn = 'LoginKey';
  static final String _kUserProfile = 'UserProfileKey';
  static final String _kUserAuthToken = 'UserAuthToken';
  static final String _isLightTheme = 'LightTheme';

  //--------------- Theme ----------------------//

  static Future<bool> setSelectedTheme(bool isLight) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isLightTheme, isLight);
  }

  static Future<bool> getSelectedTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLightTheme) ?? true;
  }

  //--------------- Theme ----------------------//

  //--------------- Log In ----------------------//

  static Future<bool> setLoginStatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kIsLoggedIn, value);
  }

  static Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedIn) ?? false;
  }

  //--------------- User Profile ----------------------//

  static Future<bool> setUserDetail(String userDetail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kUserProfile, userDetail);
  }

  static Future<String> getUserDetail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserProfile) ?? '';
  }

  static Future<bool> removeUserDetail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_kUserProfile);
    prefs.remove(_kUserAuthToken);
    prefs.remove(_kIsLoggedIn);
    return prefs.clear();
  }

  //--------------- Set Auth Info ----------------------//

  static Future<bool> setAuthInfo(String authDetail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kUserAuthToken, authDetail);
  }

  static Future<String> getAuthInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString(_kUserAuthToken) ?? '';
    return info;
  }

  static Future<bool> removeAuthInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_kUserAuthToken);
    return prefs.clear();
  }
}
