import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static final SharedPreferenceUtil _sInstance = SharedPreferenceUtil._privateConstructor();

  SharedPreferenceUtil._privateConstructor();

  static SharedPreferenceUtil getInstance() {
    return _sInstance;
  }

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
  Future<List<String>> getCityList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cities = prefs.getStringList('city_list');

    if (cities != null) {
      log("Get cities.. $cities");
      return cities;
    }

    return [];
  }

  Future<void> saveCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cityList = prefs.getStringList('city_list') ?? [];
    cityList.add(city);
    cityList = cityList.toSet().toList();
    await saveCityList(cityList);
  }

  Future<void> saveCityList(List<String> cities) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("Saved cities.. $cities");
    await prefs.setStringList('city_list', cities);
  }


}
