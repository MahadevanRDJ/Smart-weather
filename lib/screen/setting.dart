import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../utils/color_resource.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() => _Setting();
}

class _Setting extends State<Setting> {
  List<String> units = ['ºC', 'ºF'];
  List<String> categories = ['All', 'Business', 'Entertainment', 'General', 'Health', 'Science', 'Sports', 'Technology'];
  String? _selectedUnit;
  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    DashBoardProvider commonProvider = context.read<DashBoardProvider>();
    _selectedUnit = commonProvider.unitSymbol;
    _selectedCategory = commonProvider.headlineCategory;
    return SafeArea(
        minimum: const EdgeInsets.all(5),
        child: Scaffold(
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
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: const Text(
                          'Temperature Units',
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: const Text(
                          'News Category',
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DropdownButton(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                        value: _selectedUnit,
                        items: units.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Padding(padding: const EdgeInsets.all(12), child: Text(unit)),
                          );
                        }).toList(),
                        onChanged: (value) => {
                          setState(() {
                            _selectedUnit = value;
                          }),
                          commonProvider.updateUnits(value!)
                        },
                      ),
                      DropdownButton(
                        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                        value: _selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                category,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => {
                          setState(() {
                            _selectedCategory = value;
                          }),
                          commonProvider.updateHeadlineCategory(value!)
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
