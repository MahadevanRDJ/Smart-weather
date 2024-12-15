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
  @override
  Widget build(BuildContext context) {
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
      body: Consumer<DashBoardProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    child: const Text(
                      'Temperature Units',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownButton(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    value: provider.unitSymbol,
                    items: units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Padding(padding: const EdgeInsets.all(12), child: Text(unit)),
                      );
                    }).toList(),
                    onChanged: (value) => {
                      provider.updateUnits(value!)
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
