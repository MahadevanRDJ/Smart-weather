import 'dart:convert';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:smart_weather/model/location.dart';
import 'package:smart_weather/model/weather.dart';
import 'package:smart_weather/utils/app_constant.dart';

class WeatherService {
  static final WeatherService _sInstance = WeatherService._privateConstructor();

  WeatherService._privateConstructor();

  static WeatherService getInstance() {
    return _sInstance;
  }

  //https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=6099f2034bd88cac73b1ec7097b788c6
  Future<Weathers> getWeather(String units) async {
    LiveLocation liveLocation = LiveLocation();
    await liveLocation.getLiveLocation();
    HttpClientWithMiddleware httpClient = HttpClientWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);
    Weathers? weathers;

    final response =
        await httpClient.get(Uri.parse("${AppConstant.sOpenWeatherURL}/forecast?lat=${liveLocation.latitude}&lon=${liveLocation.longitude}&appid=${AppConstant.sOpenWeatherAPIKEY}&units=$units"));
    if (response.statusCode == 200) {
      weathers = Weathers.fromJson(jsonDecode(response.body));
      return weathers;
    } else {
      throw ('Error while getting people from Internet.');
    }
  }
}
