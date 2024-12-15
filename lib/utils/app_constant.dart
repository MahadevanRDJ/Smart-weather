import 'dart:developer';

import 'package:smart_weather/model/general.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/weather_service.dart';

class AppConstant {
  static const String sOpenWeatherAPIKEY = "6099f2034bd88cac73b1ec7097b788c6";
  static const String sNewsAPIKEY = "bd8ffb5d604e479996de60812480dcd8";
  //https://newsapi.org/v2/top-headlines?country=in&apiKey=bd8ffb5d604e479996de60812480dcd8
  static const String sNewsURL = "https://newsapi.org/v2";
  //https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=6099f2034bd88cac73b1ec7097b788c6
  static const String sOpenWeatherURL = "https://api.openweathermap.org/data/2.5";
  static const String sRapidAPI = "https://japerk-text-processing.p.rapidapi.com";
  static const String sImageAssetPath = "assets/images/";
  static const String sIconAssetPath = "assets/icons/";
  static const String sDefaultImageURL = "https://i.postimg.cc/MTRkdhBw/2150756332.jpg";
  static var sMetric = 'metric';
  static var sImperial = 'imperial';

  static String sCategoryParams = '';
  static const String sLocation = 'Location';
  static const String sUnits = 'Units';
  static const String sCategory = 'Category';

  static String sLongitude = 'Longitude';
  static String sLatitude = 'Latitude';

  static const sNoInternetConnection = "No internet connection.";

  static const sTimeOut = "Response timed-out.";

  static const sErrorOccurred = "Error occurred.";

  static bool isCitiesAdded = false;

  static List<CityDetail> sCityList = [];

  static Future<void> getAllCitiesInCountry(String country) async {
    try {
       sCityList = await CityService.getInstance().getAllCitiesByCountry(country);
      log(sCityList.length.toString());

    } catch (e) {
      log(e.toString());
    }
  }

  static String calculateTimeDifferenceBetween({required DateTime startDate, required DateTime endDate}) {
    int seconds = endDate.difference(startDate).inSeconds;
    if (seconds < 60) {
      return '$seconds second';
    } else if (seconds >= 60 && seconds < 3600)
      return '${endDate.difference(startDate).inMinutes.abs()} minute';
    else
      return '${endDate.difference(startDate).inHours} hours';
  }

  static redirectToURL(String? url) async {
    final uri = Uri.parse(url ?? "");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      log('Error - Redirecting URL');
    }
  }

  static getEmotion(String? string) {
    return switch (string) { 'neutral' => 'Fear', 'neg' => 'Depressing', 'pos' => 'Happiness', _ => '' };
  }
}
