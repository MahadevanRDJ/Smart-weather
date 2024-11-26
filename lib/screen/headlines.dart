import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_weather/utils/widget_resource.dart';

import '../model/headline.dart';
import '../utils/color_resource.dart';
import '../utils/size_resource.dart';

class Headlines extends StatefulWidget {
  List<Article?>? articleList;

  Headlines({super.key, required this.articleList});

  @override
  State<Headlines> createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  @override
  Widget build(BuildContext context) {
    SizeResource.setResponsive(context);
    final width = SizeResource.headlineWidth;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Headlines',
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
      body: Container(
        margin: const EdgeInsets.all(12),
        child: SingleChildScrollView(child: WidgetResource.getHeadLineList(widget.articleList, width)),
      ),
    );
  }
}
