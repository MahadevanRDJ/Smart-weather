import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:smart_weather/model/location.dart';
import 'package:smart_weather/utils/app_constant.dart';

import '../model/general.dart';
import '../model/weather.dart';

class WeatherService {
  static final WeatherService _sInstance = WeatherService._privateConstructor();

  WeatherService._privateConstructor();

  static WeatherService getInstance() {
    return _sInstance;
  }

  //https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=6099f2034bd88cac73b1ec7097b788c6
  Future<Weathers> getWeather(String units, {String city = ""}) async {
    LiveLocation liveLocation = LiveLocation();
    String query = "";
    if(city == "") {
      await liveLocation.getLiveLocation();
      query = "lat=${liveLocation.latitude}&lon=${liveLocation.longitude}";
    } else {
      query = "q=$city";
    }
    HttpClientWithMiddleware httpClient = HttpClientWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BASIC)]);
    Weathers? weathers;
    try {
      final response = await httpClient.get(Uri.parse("${AppConstant.sOpenWeatherURL}/forecast?$query&appid=${AppConstant.sOpenWeatherAPIKEY}&units=$units")).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        weathers = Weathers.fromJson(jsonDecode(response.body));
        return weathers;
      } else {
        throw (response.body);
      }
    } on SocketException catch (_) {
      throw AppConstant.sNoInternetConnection;
    } on TimeoutException catch (_) {
      throw AppConstant.sTimeOut;
    } catch (e){
      throw AppConstant.sErrorOccurred;
    }
  }
}
class CityService {
  static final CityService _sInstance = CityService._privateConstructor();

  CityService._privateConstructor();

  static CityService getInstance() {
    return _sInstance;
  }

  final _sApiKey = "V2JHVEc1cGl2S0pja0xxcGFNQnZZeDA1ZTV2bWJ5SnNTVkh5eTJscg==";
  final _sBaseURL = "https://api.countrystatecity.in/v1/";
  final HttpClientWithMiddleware _httpClient = HttpClientWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BASIC)]);

  Future<List<CityDetail>> getAllCitiesByCountry(String country) async {
    List<CityDetail> list = [];
    try {
      final response = await _httpClient.get(
        Uri.parse(
          "${_sBaseURL}countries/$country/cities",
        ),
        headers: {"X-CSCAPI-KEY": _sApiKey},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        json.forEach((city) {
          list.add(CityDetail.fromJson(city));
        });
        return list;
      } else {
        throw response.body;
      }
    } on SocketException catch (_) {
      throw AppConstant.sNoInternetConnection;
    } on TimeoutException catch (_) {
      throw AppConstant.sTimeOut;
    } catch (e) {
      throw AppConstant.sErrorOccurred;
    }
  }
}