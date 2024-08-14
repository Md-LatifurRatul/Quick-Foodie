import 'package:shared_preferences/shared_preferences.dart';

class SaveUserInfo {
  static String userIdkey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USERMAILKEY";
  static String userWalletKey = "USERWALLETKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setString(userIdkey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserWallet(String getUserWallet) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setString(userWalletKey, getUserWallet);
  }

  Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdkey);
  }

  Future<String?> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }

  Future<String?> getUserWallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userWalletKey);
  }
}
