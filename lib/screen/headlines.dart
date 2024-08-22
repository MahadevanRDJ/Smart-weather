import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_weather/utils/app_constant.dart';

import '../model/headline.dart';
import '../provider/common_provider.dart';
import '../utils/color_resource.dart';

class Headlines extends StatefulWidget {
  List<Article?>? articleList;
  double width;
  double height;

  Headlines({super.key, required this.articleList, required this.width, required this.height});

  @override
  State<StatefulWidget> createState() => _Headlines();
}

class _Headlines extends State<Headlines> {
  List<String> units = ['ºC', 'ºF'];
  List<String> categories = ['All', 'Business', 'Entertainment', 'General', 'Health', 'Science', 'Sports', 'Technology'];
  String? _selectedUnit;
  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    CommonProvider commonProvider = context.read<CommonProvider>();
    _selectedUnit = commonProvider.unitSymbol;
    _selectedCategory = commonProvider.headlineCategory;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.arrow_back,
              size: 32,
              color: ColorResource.resultBoxBG,
            ),
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Expanded(
        child: Container(
          height: widget.height,
          margin: const EdgeInsets.all(12),
          child: _headlineList(widget.articleList, widget.width),
        ),
      ),
    );
  }

  ListView _headlineList(List<Article?>? articleList, double width, {double fontSize = 14.0, Color color = Colors.white}) {
    int size = articleList!.length;
    log(size.toString());
    return ListView.builder(
        itemCount: size,
        itemBuilder: (context, index) {
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
        });
  }
}
