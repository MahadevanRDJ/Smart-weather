import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_weather/model/headline.dart';
import 'package:smart_weather/screen/headlines.dart';
import 'package:smart_weather/service/headline_sentiment_service.dart';
import 'package:smart_weather/service/headline_service.dart';
import 'package:smart_weather/service/weather_service.dart';
import 'package:smart_weather/utils/app_constant.dart';
import 'package:smart_weather/utils/size_resource.dart';
import 'package:smart_weather/utils/widget_resource.dart';

import '../model/weather.dart';
import '../provider/common_provider.dart';
import '../utils/color_resource.dart';
import '../utils/route.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoard();
}

class _DashBoard extends State<DashBoard> {
  Weathers? weathers;
  List<WeatherDetail?>? weatherList;
  Headline? headLine;
  List<Article?>? articles;
  List<Article?>? filteredArticles;
  bool isWeatherLoading = true;
  bool isHeadlineLoading = true;
  CommonProvider? commonProvider;
  String? unitListener;
  String? categoryListener;

  double? width;
  double? height;

  Future<void> getWeathers() async {
    commonProvider = context.read<CommonProvider>();
    unitListener = commonProvider?.units;
    try {
      weathers = await WeatherService.getInstance().getWeather(commonProvider!.units);
      weatherList = weathers?.weatherList;
      setState(() {
        isWeatherLoading = false;
      });
      if (weatherList!.isNotEmpty) {
        getHeadLine();
      }
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }

  Future<void> getHeadLine() async {
    commonProvider = context.read<CommonProvider>();
    categoryListener = commonProvider?.headlineCategory;
    try {
      headLine = await HeadLineService.getInstance().getNewsHeadLine(commonProvider!.headLineCategoryParam, weathers!.city!.country!.toLowerCase());
      articles = headLine?.articles;
      getSentiments();
    } catch (e, stackTrace) {
      log("ERROR", stackTrace: stackTrace);
    }
  }

  Future<void> getSentiment() async {
    await HeadLineSentimentService.getInstance().getFilterHeadlines(headLine!);
    filteredArticles = headLine?.getFilteredArticles(weatherList?.first?.weather?.first?.main);
  }

  Future<void> getSentiments() async {
    List<String>? list = headLine?.getArticleHeadings();

    for (int i = 0; i < 5; i++) {
      final headlineSentiment = await HeadLineSentimentService.getInstance().getFilterHeadline(list![i], 'english');
      log(headlineSentiment.toString());
      articles?[i]?.setSentiment(headlineSentiment!);
    }
    setState(() {
      isHeadlineLoading = false;
    });
    String? type = weatherList?.first?.weather?.first?.main;
    log(type!);
    filteredArticles = headLine?.getFilteredArticles(type);

    for (int i = 5; i < list!.length; i++) {
      final headlineSentiment = await HeadLineSentimentService.getInstance().getFilterHeadline(list![i], 'english');
      log(headlineSentiment.toString());
      articles?[i]?.setSentiment(headlineSentiment!);
    }
  }

  @override
  void initState() {
    super.initState();
    getWeathers();
  }

  @override
  Widget build(BuildContext context) {
    final currentWeather = weatherList?.first;
    final fiveDayForecast = weathers?.getFiveDayForecast();
    commonProvider = context.read<CommonProvider>();
    SizeResource.setResponsive(context);
    width = SizeResource.headlineWidth;
    height = SizeResource.headlineHeight;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () => _navigateTo(Routes.sSettings),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: ImageIcon(
                AssetImage('${AppConstant.sIconAssetPath}icon_settings.png'),
                size: 32,
                color: ColorResource.resultBoxBG,
              ),
            ),
          ),
        ],
        bottomOpacity: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: (isWeatherLoading || isHeadlineLoading)
            ? WidgetResource.getLoader(context)
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    SizedBox(
                      height: height,
                      child: _headlineList((filteredArticles!.isEmpty) ? articles : filteredArticles, width!),
                    ), //Headlines
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            weathers?.city?.name ?? 'Chennai',
                            style: TextStyle(fontSize: 32, color: Colors.black.withAlpha(200), fontWeight: FontWeight.w500),
                          ),
                          _feelsLike(currentWeather, commonProvider!, color: Colors.black.withAlpha(150)),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: showTemperatureRow(currentWeather, fontSize: 20),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(color: Colors.black.withAlpha(10), borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: _fiveDayForeCast(fiveDayForecast, fontSize: 15.5),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ),
      ),
    );
  }

  Column _fiveDayForeCast(List<WeatherDetail>? fiveDayForecast, {double iconSize = 18, double fontSize = 16, FontWeight fontWeight = FontWeight.w600}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month_rounded, size: iconSize + 8, color: Colors.black.withAlpha(170)),
              Text(
                '\t\tFive-day forecast',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize, color: Colors.black.withAlpha(170)),
              )
            ],
          ),
        ),
        ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: fiveDayForecast?.length,
            itemBuilder: (context, index) {
              final forecast = fiveDayForecast?[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                width: width,
                height: height! * 0.25,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            (_weatherIcon(forecast?.weather?.first?.main)),
                            color: Colors.black,
                            size: iconSize,
                          ),
                          Text(
                            '\t\t${DateFormat.MMMEd().format(DateTime.parse(forecast!.dttxt!))}\t',
                            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
                          ),
                        ],
                      ),
                      showTemperatureRow(forecast, fontSize: fontSize, fontWeight: fontWeight)
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

  Row _feelsLike(
    WeatherDetail? currentWeather,
    CommonProvider commonProvider, {
    Color color = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTemperature(currentWeather?.main?.feelslike?.toDouble()) ?? '30',
          style: TextStyle(fontSize: 72, color: color, fontFamily: "Times New Roman"),
        ),
        Row(verticalDirection: VerticalDirection.up, children: [
          Text('º',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              )),
          Text(
            getUnit(commonProvider.units),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color),
          ),
        ]),
      ],
    );
  }

  ListView _headlineList(List<Article?>? articleList, double width, {double fontSize = 14.0, Color color = Colors.white}) {
    int size = articleList!.length;
    log(size.toString());
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: size + 1,
        itemBuilder: (context, index) {
          if (index < size) {
            final article = articleList[index];
            return GestureDetector(
              onTap: () => {AppConstant.redirectToURL(article?.url)},
              child: Container(
                width: width,
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(articleList?[index]?.urlToImage ?? AppConstant.sDefaultImageURL))),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                color: ColorResource.bgColor,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Text(
                                AppConstant.getEmotion(article?.headLineSentiment?.label).toUpperCase() ?? 'Complex',
                                style: TextStyle(
                                  color: color,
                                  fontSize: fontSize,
                                ),
                              )),
                          Text(
                            AppConstant.calculateTimeDifferenceBetween(startDate: DateTime.parse(article?.publishedAt ?? '2024-07-29T12:46:44Z'), endDate: DateTime.timestamp()),
                            style: TextStyle(color: color, fontSize: fontSize),
                          )
                        ],
                      ),
                      Center(
                          child: Text(
                        articleList[index]?.title ?? "",
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            shadows: const [
                              Shadow(color: Colors.black, blurRadius: 50),
                              Shadow(color: Colors.black, blurRadius: 50),
                              Shadow(color: Colors.black, blurRadius: 50),
                              Shadow(color: Colors.black, blurRadius: 50),
                            ],
                            fontSize: fontSize + 1),
                      ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => _navigateTo(Routes.sHeadlines),
              child: Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.double_arrow_rounded,
                        size: height! / 6,
                      ),
                    )),
              ),
            );
          }
        });
  }

  String? getTemperature(double? currentWeather) => currentWeather?.toStringAsFixed(1);

  Row showTemperatureRow(WeatherDetail? currentWeather, {double fontSize = 14, FontWeight fontWeight = FontWeight.w500}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${currentWeather?.weather?.first?.main ?? 'Clouds'}\t', style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
        Text('${getTemperature(currentWeather?.main?.tempmax?.toDouble()) ?? '34'}º', style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
        Text('/', style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
        Text('${getTemperature(currentWeather?.main?.tempmin?.toDouble()) ?? '28'}º', style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
      ],
    );
  }

  _navigateTo(String route) {
    if (route == Routes.sHeadlines) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Headlines(
            articleList: articles,
            width: width!,
            height: height!,
          ),
        ),
      ).whenComplete(() => _refresh());
    } else {
      Navigator.pushNamed(
        context,
        route,
      ).whenComplete(() => _refresh());
    }
    // Navigator.push(context, WidgetResource.getSlideNavigation(this, const Setting())).whenComplete(() => _refresh());
  }

  String getUnit(String units) {
    return units.contains(AppConstant.sMetric) ? 'C' : 'F';
  }

  _refresh() {
    if (unitListener != commonProvider?.units) {
      setState(() {
        isWeatherLoading = true;
      });
      getWeathers();
    }
    if (categoryListener != commonProvider?.headlineCategory) {
      setState(() {
        isHeadlineLoading = true;
      });
      getHeadLine();
    }
  }

  _weatherIcon(String? type) {
    return switch (type) {
      'Clouds' => Icons.wb_cloudy_rounded,
      'Rain' => Icons.thunderstorm_rounded,
      'Snow' => Icons.cloudy_snowing,
      _ => Icons.wb_sunny_rounded,
    };
  }
}
