import 'dart:developer';

import 'package:flutter/material.dart';

import '../model/headline.dart';
import '../model/weather.dart';
import '../service/headline_service.dart';
import '../service/weather_service.dart';


class DashBoardProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void updateIndex(int index) {
    _index = index;
    notifyListeners();
  }

  Weathers? weathers;
  List<WeatherDetail?>? weatherList;
  Headline? headLine;
  List<Article?>? articles;
  bool _loading = false;
  String _headlineCategory = '';
  String _unit = 'ºC';
  String _cityName = '';
  List<Weathers> cityWeatherList = [];
  String message = "";


  bool get isLoading => _loading;

  String get cityName => _cityName;

  Future<void> getWeathers({String city = ""}) async {
    message = "";
    try {
      weathers = Weathers();
      setLoader(true);
      weathers = await WeatherService.getInstance().getWeather(units, city: city);
      weatherList = weathers?.weatherList;
      log(weathers.toString());
      setLoader(false);
     /* if (weatherList!.isNotEmpty) {
        getHeadLine();
      }*/
    } catch (e, stackTrace) {
      setLoader(false);
      message = e.toString();
      log(e.toString(), stackTrace: stackTrace);
    }
    notifyListeners();
  }

  Future<void> getCityWeatherList(List<String> cityList) async {
    message = "";
    try {
      cityWeatherList = [];
      setLoader(true);
      for (var city in cityList) {
        Weathers weather = await WeatherService.getInstance().getWeather(units, city: city);
        cityWeatherList.add(weather);
      }
      setLoader(false);
    } catch (e, stackTrace) {
      setLoader(false);
      message = e.toString();
      log(e.toString(), stackTrace: stackTrace);
    }
    notifyListeners();
  }

  Future<void> getHeadLine() async {
    try {
      setLoader(true);
      final country = weathers!.city!.country!.toLowerCase();
      headLine = await HeadLineService.getInstance().getNewsHeadLine(headLineCategoryParam, country);
      articles = headLine?.articles;
      setLoader(false);
      log(articles.toString());
    } catch (e, stackTrace) {
      log("ERROR ${e.toString()}", stackTrace: stackTrace);
    }
  }



  String get headlineCategory => (_headlineCategory == '' || _headlineCategory == 'All') ? 'All' : _headlineCategory;
  String get headLineCategoryParam => (_headlineCategory == '' || _headlineCategory == 'All') ? '' : '&category=$_headlineCategory';

  void updateHeadlineCategory(String category) {
    _headlineCategory = category;
    notifyListeners();
  }

  String get unitSymbol => _unit;
  String get units => _unit.contains('C') ? 'metric' : 'imperial';

  void updateUnits(String units) {
    _unit = units;
    log(units);
    if(_unit.contains("C")) {
      convertToCelsius();
    } else {
      convertToFahrenheit();
    }
    notifyListeners();
  }

  void updateCityName(String name) {
    _cityName = name;
    notifyListeners();
  }

  void setLoader(bool flag) {
    _loading = flag;
    notifyListeners();
  }

  void convertToCelsius() {
    for (var weather in cityWeatherList) {
      weather.getFiveDayForecast().forEach((current) {
        current.main!.convertFahrenheitToCelsius();
      });
    }
    log(cityWeatherList[0].getFiveDayForecast().toString());
  }

  void convertToFahrenheit() {
    for (var weather in cityWeatherList) {
      weather.getFiveDayForecast().forEach((current) {
        current.main!.convertCelsiusToFahrenheit();
      });
    }
    log(cityWeatherList[0].getFiveDayForecast().toString());
  }
}
