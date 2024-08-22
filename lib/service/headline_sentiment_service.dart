import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:smart_weather/model/headline.dart';
import 'package:smart_weather/model/headline_sentiment.dart';
import 'package:smart_weather/utils/app_constant.dart';

class HeadLineSentimentService {
  static final HeadLineSentimentService _sInstance = HeadLineSentimentService._privateConstructor();

  HeadLineSentimentService._privateConstructor();

  static HeadLineSentimentService getInstance() {
    return _sInstance;
  }

  static const String _path = "/sentiment/";

  /* curl --location 'https://japerk-text-processing.p.rapidapi.com/sentiment/' \
  --header 'x-rapidapi-host: japerk-text-processing.p.rapidapi.com' \
  --header 'x-rapidapi-key: b8bde3d387msh2a4744221d0ae19p1bc968jsnea3e7130be7d' \
  --form 'text="I am great."' \
  --form 'language="english"'*/

  Future<HeadlineSentiment?> getFilterHeadline(String text, String language) async {
    Map<String, String> headers = <String, String>{'x-rapidapi-host': 'japerk-text-processing.p.rapidapi.com', 'x-rapidapi-key': 'b8bde3d387msh2a4744221d0ae19p1bc968jsnea3e7130be7d'};
    Map<String, String> requestBody = <String, String>{'text': text, 'language': language};
    HeadlineSentiment? headlineSentiment;
    final request = http.MultipartRequest(Method.POST.name, Uri.parse(("${AppConstant.sRapidAPI}$_path")))
      ..headers.addAll(headers)
      ..fields.addAll(requestBody);
    final response = await request.send();
    try {
      if (response.statusCode == 200) {
        final string = await response.stream.bytesToString();
        headlineSentiment = HeadlineSentiment.fromJson(jsonDecode(string));
        return headlineSentiment;
      } else {
        throw ('Error- Headline Sentiment');
      }
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
    return headlineSentiment;
  }

  Future<void> getFilterHeadlines(Headline headlines, {String language = 'english'}) async {
    List<Article?>? articles = headlines.articles;
    headlines.getArticleHeadings().asMap().forEach((index, text) async {
      final headlineSentiment = await getFilterHeadline(text, language);
      log(headlineSentiment.toString());
      articles?[index]?.setSentiment(headlineSentiment!);
    });
  }
}
