import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_weather/screen/headlines.dart';
import 'package:smart_weather/utils/app_constant.dart';
import 'package:smart_weather/utils/size_resource.dart';
import 'package:smart_weather/utils/widget_resource.dart';

import '../model/weather.dart';
import '../provider/dashboard_provider.dart';
import '../utils/route.dart';
import '../utils/shared_preference.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoard();
}

class _DashBoard extends State<DashBoard> {
  double? width;
  double? height;
  late DashBoardProvider dashBoardProvider;

  @override
  void initState() {
    dashBoardProvider = context.read<DashBoardProvider>();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp)  async {
      List<String> cityList = await getCitiesFromMemory();
      dashBoardProvider.getCityWeatherList(cityList);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeResource.setResponsive(context);
    width = SizeResource.headlineWidth;
    height = SizeResource.headlineHeight;
    log("Loading...${dashBoardProvider.isLoading}");
    return Consumer<DashBoardProvider>(
      builder: (BuildContext context, DashBoardProvider dashBoardProvider, Widget? child) {
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => _navigateTo(Routes.sManageCities),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.add,
                  size: 32,
                ),
              ),
            ),
            centerTitle: true,
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
          body: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: dashBoardProvider.cityWeatherList.length,
            itemBuilder: (context, index) {
              Weathers weather = dashBoardProvider.cityWeatherList[index];
              return dashBoardProvider.isLoading
                  ? WidgetResource.getLoader(context)
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Text(
                            weather.city!.name.toString() ,
                            style: TextStyle(fontSize: 32, color: Colors.black.withAlpha(200), fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Column(
                              children: [
                                WidgetResource.getFeelsLike(weather.weatherList!.first, dashBoardProvider.units, color: Colors.black.withAlpha(150)),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  child: showTemperatureRow(weather.weatherList!.first, fontSize: 20),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(color: Colors.black.withAlpha(10), borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    child: _fiveDayForeCast(weather.getFiveDayForecast(), fontSize: 15.5),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]),
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  Column _fiveDayForeCast(List<WeatherDetail> fiveDayForecast, {double iconSize = 18, double fontSize = 16, FontWeight fontWeight = FontWeight.w600}) {
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
        SizedBox(
          width: 350,
          child: ListView.builder(
            shrinkWrap: true,
              itemCount: fiveDayForecast.length,
              itemBuilder: (context, index) {
                final forecast = fiveDayForecast[index];
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
                              (_weatherIcon(forecast.weather?.first?.main)),
                              color: Colors.black,
                              size: iconSize,
                            ),
                            Text(
                              '\t\t${DateFormat.MMMEd().format(DateTime.parse(forecast.dttxt ?? ""))}\t',
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
        ),
      ],
    );
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
            articleList: dashBoardProvider.articles,
          ),
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        route,
      );
    }
    // Navigator.push(context, WidgetResource.getSlideNavigation(this, const Setting())).whenComplete(() => _refresh());
  }

  String getUnit(String units) {
    return units.contains(AppConstant.sMetric) ? 'C' : 'F';
  }

  /*_refresh() {
    if (unitListener != dashBoardProvider?.units) {
      setState(() {
        isWeatherLoading = true;
      });
      getWeathers();
    }
    if (categoryListener != dashBoardProvider?.headlineCategory) {
      setState(() {
        isHeadlineLoading = true;
      });
      getHeadLine();
    }
  }*/

  _weatherIcon(String? type) {
    return switch (type) {
      'Clouds' => Icons.wb_cloudy_rounded,
      'Rain' => Icons.thunderstorm_rounded,
      'Snow' => Icons.cloudy_snowing,
      _ => Icons.wb_sunny_rounded,
    };
  }

  Future<List<String>> getCitiesFromMemory() async {
    return await SharedPreferenceUtil.getInstance().getCityList();
  }
}
