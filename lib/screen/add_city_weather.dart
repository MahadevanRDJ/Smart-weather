import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_weather/provider/dashboard_provider.dart';
import 'package:smart_weather/utils/app_constant.dart';
import 'package:smart_weather/utils/route.dart';
import 'package:smart_weather/utils/widget_resource.dart';

import '../utils/shared_preference.dart';

class AddCityWeather extends StatefulWidget {
  String city = "";
  bool isAlreadyAdded = false;

  AddCityWeather({super.key, required this.city, required this.isAlreadyAdded});

  @override
  State<StatefulWidget> createState() => _AddCityWeather();
}

class _AddCityWeather extends State<AddCityWeather> {
  late DashBoardProvider dashBoardProvider;

  @override
  void initState() {
    dashBoardProvider = context.read<DashBoardProvider>();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      dashBoardProvider.getWeathers(city: widget.city);
      setState(() {
        widget.city = dashBoardProvider.weathers!.city!.name ?? '';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white.withAlpha(20),
      body: GestureDetector(
        onTap: () => Focus.of(context).unfocus(),
        child: Consumer<DashBoardProvider>(
          builder: (context, provider, child) => provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightBlueAccent,
                  ),
                )
              : provider.message.isEmpty ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(widget.city == '' ? provider.weathers!.city!.name! : widget.city, style: const TextStyle(color: Colors.white, fontSize: 28)),
                          Center(
                            child: WidgetResource.getFeelsLike(provider.weathers!.weatherList!.first, provider.units, color: Colors.lightBlueAccent),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          dashBoardProvider.setLoader(true);
                          _addCityToMemory();
                          if (AppConstant.isCitiesAdded == false) AppConstant.isCitiesAdded = true;
                          Navigator.pushNamedAndRemoveUntil(context, Routes.sDashBoard, (route) => false);
                          dashBoardProvider.setLoader(false);
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                              child:  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  widget.isAlreadyAdded ? Icons.arrow_forward_ios_rounded : Icons.add_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.isAlreadyAdded ? 'View on home page': 'Add to start page',
                                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ) : WidgetResource.showAlert(context, "${provider.message}\n or \nNo results were found for city you searched."),
        ),
      ),
    );
  }

  void _addCityToMemory() async {
    await SharedPreferenceUtil.getInstance().saveCity(widget.city.isEmpty ? dashBoardProvider.weathers!.city!.name! : widget.city);
  }
}
