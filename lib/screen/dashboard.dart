import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
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
  CarouselSliderController carouselSliderController = CarouselSliderController();

  @override
  void initState() {
    dashBoardProvider = context.read<DashBoardProvider>();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
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
            resizeToAvoidBottomInset: false,
            body: dashBoardProvider.isLoading
                ? WidgetResource.getLoader(context)
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(dashBoardProvider.cityWeatherList.length, (index) {
                            return GestureDetector(
                                onTap: () {
                                  carouselSliderController.animateToPage(index);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (dashBoardProvider.index == index) ? Colors.black54 : Colors.black12,
                                  ),
                                ));
                          }),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: CarouselSlider(
                          carouselController: carouselSliderController,
                          items: dashBoardProvider.cityWeatherList.map((weather) {
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      weather.city!.name.toString(),
                                      style: TextStyle(fontSize: 32, color: Colors.black.withAlpha(200), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                                    child: Column(
                                      children: [
                                        WidgetResource.getFeelsLike(weather.weatherList!.first, dashBoardProvider.units, color: Colors.black.withAlpha(150)),
                                        showTemperatureRow(weather.weatherList!.first, fontSize: 20),
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(color: Colors.black.withAlpha(10), borderRadius: BorderRadius.circular(10)),
                                          child: _fiveDayForeCast(weather.getFiveDayForecast(), fontSize: 15.5),
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: SizeResource.getSize(context).height,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            autoPlayAnimationDuration: const Duration(seconds: 1),
                            autoPlayCurve: Curves.easeInQuad,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              dashBoardProvider.updateIndex(index);
                            },
                            enlargeFactor: 0.4,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  ));
      },
    );
  }

  _fiveDayForeCast(List<WeatherDetail> fiveDayForecast, {double iconSize = 18, double fontSize = 16, FontWeight fontWeight = FontWeight.w600}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: iconSize + 8, color: Colors.black.withAlpha(170)),
              Text(
                '\t\tFive-day forecast',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize, color: Colors.black.withAlpha(170)),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.black12,
          thickness: 1,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: fiveDayForecast.length,
            itemBuilder: (context, index) {
              final forecast = fiveDayForecast[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
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
                    ),
                    Expanded(child: showTemperatureRow(forecast, fontSize: fontSize, fontWeight: fontWeight))
                  ],
                ),
              );
            }),
      ],
    );
  }

  String? getTemperature(double? currentWeather) => currentWeather?.toStringAsFixed(1);

  Row showTemperatureRow(WeatherDetail? currentWeather, {double fontSize = 14, FontWeight fontWeight = FontWeight.w500}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
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
