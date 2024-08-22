import 'dart:convert';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:smart_weather/model/headline.dart';
import 'package:smart_weather/utils/app_constant.dart';

class HeadLineService {
  static final HeadLineService _sInstance = HeadLineService._privateConstructor();

  HeadLineService._privateConstructor();

  static HeadLineService getInstance() {
    return _sInstance;
  }

  static const String _path = "/top-headlines";

  //"https://newsapi.org/v2/top-headlines?country=in&apiKey=bd8ffb5d604e479996de60812480dcd8"
  Future<Headline> getNewsHeadLine(String categoryParam, String country) async {
    HttpClientWithMiddleware httpClient = HttpClientWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BODY)]);
    Headline? headline;
    final response = await httpClient.get(Uri.parse(("${AppConstant.sNewsURL}$_path?country=$country&apiKey=${AppConstant.sNewsAPIKEY}$categoryParam")));
    if (response.statusCode == 200) {
      headline = Headline.fromJson(jsonDecode(response.body));
      return headline;
    } else {
      throw ('Error - Headline');
    }
  }
}
