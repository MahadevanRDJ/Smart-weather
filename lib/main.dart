import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_weather/screen/add_city_weather.dart';
import 'package:smart_weather/screen/dashboard.dart';
import 'package:smart_weather/screen/manage_cities.dart';
import 'package:smart_weather/screen/setting.dart';
import 'package:smart_weather/utils/app_constant.dart';
import 'package:smart_weather/utils/shared_preference.dart';

import 'provider/dashboard_provider.dart';
import 'utils/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<String>  cityList = await SharedPreferenceUtil.getInstance().getCityList();
  log("Saved : $cityList");
  AppConstant.isCitiesAdded = cityList.isNotEmpty;
  log('City added ? ${AppConstant.isCitiesAdded}');
  runApp(const SmartWeather());
}
class SmartWeather extends StatefulWidget {
  const SmartWeather({super.key });

  @override
  State<StatefulWidget> createState() => _SmartWeather();

}
class _SmartWeather extends State<SmartWeather> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DashBoardProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: {Routes.sDashBoard: (context) => AppConstant.isCitiesAdded ? const DashBoard() : const ManageCity(),
          Routes.sSettings: (context) => const Setting(),
          Routes.sManageCities : (context) => const ManageCity(),
          Routes.sAddCity : (context) => AddCityWeather(city: '', isAlreadyAdded: false),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          fontFamily: "Inter",
        ),
        initialRoute: Routes.sDashBoard,
      ),
    );
  }
}
