import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
    HttpClientWithMiddleware httpClient = HttpClientWithMiddleware.build(middlewares: [HttpLogger(logLevel: LogLevel.BASIC)]);
    Headline? headline;
    try {
      final response = await httpClient.get(Uri.parse(("${AppConstant.sNewsURL}$_path?country=$country&apiKey=${AppConstant.sNewsAPIKEY}$categoryParam"))).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        headline = Headline.fromJson(jsonDecode(response.body));
        return headline;
      } else {
        throw (response.body);
      }
    } on SocketException catch (_) {
      throw AppConstant.sNoInternetConnection;
    } on TimeoutException catch (_) {
      throw AppConstant.sTimeOut;
    } catch (e, stacktrace){
      log(stacktrace.toString());
      throw e.toString();
    }
  }
}
