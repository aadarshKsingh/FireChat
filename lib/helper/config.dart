import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig {
  static String userLoggedInKey = "isloggedin";
  static String usernameKey = "username";
  static String emailKey = "email";

  //storing credentials
  static Future storeStatus(isUserLoggedIn) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool("userLoggedInKey", isUserLoggedIn);
  }

  static Future storeUsername(username) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString("usernameKey", username);
  }

  static Future storeMail(mail) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString("emailKey", mail);
  }

  //getting credentials
  static Future<bool?> getStatus() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getBool("userLoggedInKey");
  }

  static Future<String?> getUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString("usernameKey");
  }

  static Future<String?> getMail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString("emailKey");
  }
}
