import 'package:flutter/material.dart';
import 'package:smart_weather/screen/add_city_weather.dart';
import 'package:smart_weather/utils/route.dart';
import 'package:smart_weather/utils/shared_preference.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      List<String> cityList = await SharedPreferenceUtil.getInstance().getCityList();
      setState(() {
        topCities = List.generate(topCitiesInIndia.length, (index) => City(topCitiesInIndia[index],  isAlreadyAdded(cityList, topCitiesInIndia[index])));
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Manage Cities", style: TextStyle(color: Colors.white, fontSize: 32)),
                  Column(children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.sAddCity),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Transform.rotate(
                                angle:  40 * 3.14 / 180 ,
                                child: const Icon(
                                  Icons.navigation_rounded,
                                  color: Colors.lightBlueAccent,
                                  size: 42,
                                ),
                              ),
                            ),
                          ),
                          const Text("Locate", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500,fontSize: 15))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.white54,
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(hintText: "Enter Location", border: InputBorder.none, hintStyle: TextStyle(fontSize: 18, color: Colors.white24)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                  Container(margin: const EdgeInsets.symmetric(vertical: 24),child: const Text("Top cities", style: TextStyle(color: Colors.white, fontSize: 16))),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: topCities.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3),
                    itemBuilder: (context, index)
                    {
                      City city = topCities[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddCityWeather(city: city.name, isAlreadyAdded: city.isSelected,))),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            textAlign: TextAlign.center,
                            city.name.toString(),
                            style: TextStyle(
                                color: city.isSelected ? Colors.lightBlueAccent: Colors.white70,
                                fontWeight: city.isSelected ? FontWeight.bold : FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  bool isAlreadyAdded(List<String> cityList, String currentCity) {
    return cityList.contains(currentCity);
  }
}
