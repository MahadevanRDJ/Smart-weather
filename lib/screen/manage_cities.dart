import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_weather/screen/add_city_weather.dart';
import 'package:smart_weather/utils/app_constant.dart';
import 'package:smart_weather/utils/route.dart';
import 'package:smart_weather/utils/shared_preference.dart';
import 'package:smart_weather/utils/size_resource.dart';

import '../model/general.dart';

List<String> topCitiesInIndia = [
  'Mumbai',
  'Delhi',
  'Bengaluru',
  'Kolkata',
  'Chennai',
  'Hyderabad',
  'Ahmedabad',
  'Pune',
  'Jaipur',
  'Surat',
  'Lucknow',
  'Kanpur',
  'Nagpur',
  'Indore',
  'Patna',
  'Vadodara',
  'Bhopal',
  'Coimbatore',
  'Kochi',
  'Chandigarh',
  'Visakhapatnam',
  'Mysuru',
  'Agra',
  'Nashik',
  'Rajkot',
  'Faridabad',
  'Gurugram',
  'Noida',
  'Ludhiana',
  'Vijayawada'
];

class City {
  String name;
  bool isSelected;

  City(this.name, this.isSelected);
}

class ManageCity extends StatefulWidget {
  const ManageCity({super.key});

  @override
  State<StatefulWidget> createState() => _ManageCity();
}

class _ManageCity extends State<ManageCity> {
  List<City> topCities = [];
  List<CityDetail> _filteredCities = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      List<String> cityList = await SharedPreferenceUtil.getInstance().getCityList();
      setState(() {
        topCities = List.generate(topCitiesInIndia.length, (index) => City(topCitiesInIndia[index], isAlreadyAdded(cityList, topCitiesInIndia[index])));
      });
    });
    _filteredCities = AppConstant.sCityList;
    _searchFocus.addListener(() => setState(() {}));
    _searchController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _searchFocus.removeListener(() {});
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void updateOnSearch(String searchedString) {
    _filteredCities = AppConstant.sCityList;
    _filteredCities = _filteredCities.where((city) => city.name.contains(searchedString)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: _searchFocus.hasFocus ? 0 : 40,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            title: const Text("Manage Cities", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          backgroundColor: Colors.white.withAlpha(20),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Visibility(
                  visible: !_searchFocus.hasFocus,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, Routes.sAddCity),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Transform.rotate(
                              angle: 40 * 3.14 / 180,
                              child: const Icon(
                                Icons.navigation_rounded,
                                color: Colors.lightBlueAccent,
                                size: 42,
                              ),
                            ),
                          ),
                        ),
                        const Text("Locate", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 15, letterSpacing: 2))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.white54,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          canRequestFocus: true,
                          focusNode: _searchFocus,
                          controller: _searchController,
                          onChanged: (value) {
                            updateOnSearch(value);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(hintText: "Enter Location", border: InputBorder.none, hintStyle: TextStyle(fontSize: 18, color: Colors.white24)),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                    visible: _searchController.text.length >= 2,
                    child: Container(
                      height: SizeResource.getSize(context).height / 3,
                      decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
                      child: _filteredCities.isNotEmpty ? ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: _filteredCities.length,
                        itemBuilder: (context, index) {
                          CityDetail city = _filteredCities[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCityWeather(
                                      city: city.name,
                                      isAlreadyAdded: false,
                                    ))),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    _filteredCities[index].name,
                                    style: const TextStyle(fontSize: 17, color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(color: Colors.white12,thickness: 1,)
                                ],
                              ),
                            ),
                          );
                        },
                      ) : const Center(
                        child: Text(
                          'No such cities to be searched',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    )),
                Visibility(
                  visible: _searchFocus.hasFocus && _searchController.text.length < 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(margin: const EdgeInsets.symmetric(vertical: 24), child: const Text("Top cities", style: TextStyle(color: Colors.white, fontSize: 16))),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: topCities.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3),
                        itemBuilder: (context, index) {
                          City city = topCities[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCityWeather(
                                          city: city.name,
                                          isAlreadyAdded: city.isSelected,
                                        ))),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                textAlign: TextAlign.center,
                                city.name.toString(),
                                style: TextStyle(color: city.isSelected ? Colors.lightBlueAccent : Colors.white70, fontWeight: city.isSelected ? FontWeight.bold : FontWeight.w400, fontSize: 12),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  bool isAlreadyAdded(List<String> cityList, String currentCity) {
    return cityList.contains(currentCity);
  }
}
