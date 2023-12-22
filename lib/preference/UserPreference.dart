import 'dart:convert';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  var pref = SharedPreferences.getInstance();
  var userKey = "user";
  var tokenKey = "token";

  getPref() async {
    return await SharedPreferences.getInstance();
  }

  read() async {
    pref = SharedPreferences.getInstance();
  }

  void saveSignInInfo(UserData? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('signIn', json.encode(data));
  }

  Future<UserData?> getSignInInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('signIn');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return UserData.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> setIsGuestUser(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('guest', value);
  }

  Future<bool> getGuestUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guest') ??
        true; // Default to false if the key is not found
  }

  Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, value);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? "";
  }

  Future<void> setUserType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, value);
  }

  Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey) ?? "";
  }

  Future<void> setBoolValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('myBoolKey', value);
  }

  Future<bool> getBoolValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('myBoolKey') ??
        false; // Default to false if the key is not found
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
