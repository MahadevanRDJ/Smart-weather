import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_weather/screen/dashboard.dart';
import 'package:smart_weather/screen/setting.dart';

import 'provider/common_provider.dart';
import 'utils/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CommonProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: {Routes.sDashBoard: (context) => const DashBoard(), Routes.sSettings: (context) => const Setting()},
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
