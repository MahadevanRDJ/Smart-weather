import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static getStringData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  static Future<bool> saveStringData(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(key, value);
  }
}
