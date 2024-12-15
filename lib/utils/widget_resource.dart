import 'package:flutter/material.dart';

import '../model/headline.dart';
import '../model/weather.dart';
import '../screen/headlines.dart';
import 'app_constant.dart';

class WidgetResource {
  static Orientation getOrientation(context) => MediaQuery.orientationOf(context);

  static tapOutside(context) => () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      };

  static AlertDialog getLoader(context) => _loader;

  static showAlert(context, message) => _alert(context, message);

  static PageRouteBuilder getSlideNavigation(context, nextScreen) => _EnterExitRoute(exitPage: context, enterPage: nextScreen);

  static ListView getHeadLineList(articleList, width, {double fontSize = 14.0, Color color = Colors.white, Axis direction = Axis.vertical, bool isVisible = false}) =>
      _headlineList(articleList, width, fontSize, color, direction, isVisible);

  static Row getFeelsLike(currentWeather, units, {Color color = Colors.black})  => _feelsLike(currentWeather, units, color);
}

Widget _alert(BuildContext context, String message) => AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: [
        GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Center(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ))
      ],
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
Row _feelsLike(
  WeatherDetail? currentWeather,
  String units,
  Color color) {
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
          getUnit(units),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color),
        ),
      ]),
    ],
  );
}

String getUnit(String units) => units.contains(AppConstant.sMetric) ? 'C' : 'F';

String? getTemperature(double? currentWeather) => currentWeather?.toStringAsFixed(1);

ListView _headlineList(List<Article?>? articleList, double width, double fontSize, Color color, Axis direction, bool isVisible) {
  int size = isVisible ? 5 : articleList!.length;
  return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: direction,
      itemCount: size + 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index < size) {
          final article = articleList?[index];
          return GestureDetector(
            onTap: () => {AppConstant.redirectToURL(article?.url)},
            child: Container(
              width: width,
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage((articleList?[index]?.urlToImage == null || articleList![index]!.urlToImage.isEmpty) ? AppConstant.sDefaultImageURL : articleList[index]!.urlToImage))),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Container(
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
                              )),*/
                        Text(
                          AppConstant.calculateTimeDifferenceBetween(startDate: DateTime.parse(article?.publishedAt ?? '2024-07-29T12:46:44Z'), endDate: DateTime.timestamp()),
                          style: TextStyle(color: color, fontSize: fontSize),
                        )
                      ],
                    ),
                    Padding(
                      padding: isVisible ? const EdgeInsets.only(top: 0) : const EdgeInsets.only(top: 48),
                      child: Text(
                        articleList?[index]?.title ?? "",
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Visibility(
            visible: isVisible,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Headlines(
                    articleList: articleList,
                  ),
                ),
              ),
              child: Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.double_arrow_rounded,
                        size: 50,
                      ),
                    )),
              ),
            ),
          );
        }
      });
}

AlertDialog _loader = const AlertDialog(
  surfaceTintColor: Colors.transparent,
  backgroundColor: Colors.transparent,
  content: Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
      strokeWidth: 5.0,
    ),
  ),
);

class _EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  _EnterExitRoute({required this.exitPage, required this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(-1.0, 0.0),
                ).animate(animation),
                child: exitPage,
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: enterPage,
              )
            ],
          ),
        );
}
