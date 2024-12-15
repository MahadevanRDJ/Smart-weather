/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

import 'package:json_annotation/json_annotation.dart';

class City {
  int? id;
  String? name;
  Coordinate? coordinate;
  String? country;
  int? population;
  int? timezone;
  int? sunrise;
  int? sunset;

  City({this.id, this.name, this.coordinate, this.country, this.population, this.timezone, this.sunrise, this.sunset});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coordinate = json['coord'] != null ? Coordinate?.fromJson(json['coord']) : null;
    country = json['country'];
    population = json['population'];
    timezone = json['timezone'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['coord'] = coordinate!.toJson();
    data['country'] = country;
    data['population'] = population;
    data['timezone'] = timezone;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }

  @override
  String toString() {
    return 'City{id: $id, name: $name, coord: $coordinate, country: $country, population: $population, timezone: $timezone, sunrise: $sunrise, sunset: $sunset}';
  }
}

class Clouds {
  int? all;

  Clouds({this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all'] = all;
    return data;
  }

  @override
  String toString() {
    return 'Clouds{all: $all}';
  }
}

class Coordinate {
  num? lat;
  num? lon;

  Coordinate({this.lat, this.lon});

  Coordinate.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }

  @override
  String toString() {
    return 'Coordinate{lat: $lat, lon: $lon}';
  }
}

class Main {
  num? temp;
  num? feelslike;
  num? tempmin;
  num? tempmax;
  int? pressure;
  int? sealevel;
  int? grndlevel;
  int? humidity;

  Main({
    this.temp,
    this.feelslike,
    this.tempmin,
    this.tempmax,
    this.pressure,
    this.sealevel,
    this.grndlevel,
    this.humidity,
  });

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    feelslike = json['feels_like'];
    tempmin = json['temp_min'];
    tempmax = json['temp_max'];
    pressure = json['pressure'];
    sealevel = json['sea_level'];
    grndlevel = json['grnd_level'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['feels_like'] = feelslike;
    data['temp_min'] = tempmin;
    data['temp_max'] = tempmax;
    data['pressure'] = pressure;
    data['sea_level'] = sealevel;
    data['grnd_level'] = grndlevel;
    data['humidity'] = humidity;
    return data;
  }

  @override
  String toString() {
    return 'Main{temp: $temp, feelslike: $feelslike, tempmin: $tempmin, tempmax: $tempmax, pressure: $pressure, sealevel: $sealevel, grndlevel: $grndlevel, humidity: $humidity}';
  }

  void convertCelsiusToFahrenheit() {
    temp = _convertCtoF(temp!);
    tempmin = _convertCtoF(tempmin!);
    tempmax = _convertCtoF(tempmax!);
    feelslike = _convertCtoF(feelslike!);
  }

  void convertFahrenheitToCelsius() {
    temp = _convertFtoC(temp!);
    tempmin = _convertFtoC(tempmin!);
    tempmax = _convertFtoC(tempmax!);
    feelslike = _convertFtoC(feelslike!);
  }

  num _convertCtoF(num value) {
    return (value * 9 / 5) + 32;
  }

  num _convertFtoC(num value) {
    return (value - 32) * (5 / 9);
  }
}

@JsonSerializable()
class Rain {
  @JsonKey(name: "3h")
  num? threeHour;

  Rain({this.threeHour});

  Rain.fromJson(Map<String, dynamic> json) {
    threeHour = json['3h'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['3h'] = threeHour;
    return data;
  }

  @override
  String toString() {
    return 'Rain{threeHour: $threeHour}';
  }
}

@JsonSerializable()
class Weathers {
  String? cod;
  int? message;
  int? cnt;
  List<WeatherDetail?>? weatherList;
  City? city;

  Weathers({this.cod, this.message, this.cnt, this.weatherList, this.city});

  Weathers.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    message = json['message'];
    cnt = json['cnt'];
    if (json['list'] != null) {
      weatherList = <WeatherDetail>[];
      json['list'].forEach((v) {
        weatherList!.add(WeatherDetail.fromJson(v));
      });
    }
    city = json['city'] != null ? City?.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cod'] = cod;
    data['message'] = message;
    data['cnt'] = cnt;
    if (weatherList != null) {
      data['list'] = weatherList!.map((v) => v?.toJson()).toList();
    } else {
      data['list'] = null;
    }
    data['city'] = city!.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Weathers{cod: $cod, message: $message, cnt: $cnt, weatherList: $weatherList, city: $city}';
  }

  List<WeatherDetail> getFiveDayForecast() {
    List<WeatherDetail> list = <WeatherDetail>[];
    weatherList?.asMap().forEach((key, value) {
      if ((key + 1) % 8 == 0) list.add(weatherList![(key + 1) - 8]!);
    });
    return list;
  }
}

class Sys {
  String? pod;

  Sys({this.pod});

  Sys.fromJson(Map<String, dynamic> json) {
    pod = json['pod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pod'] = pod;
    return data;
  }

  @override
  String toString() {
    return 'Sys{pod: $pod}';
  }
}

class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }

  @override
  String toString() {
    return 'Weather{id: $id, main: $main, description: $description, icon: $icon}';
  }
}

class WeatherDetail {
  int? dt;
  Main? main;
  List<Weather?>? weather;
  Clouds? clouds;
  Wind? wind;
  int? visibility;
  num? pop;
  Sys? sys;
  String? dttxt;
  Rain? rain;

  WeatherDetail({this.dt, this.main, this.weather, this.clouds, this.wind, this.visibility, this.pop, this.sys, this.dttxt, this.rain});

  WeatherDetail.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    main = json['main'] != null ? Main?.fromJson(json['main']) : null;
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    clouds = json['clouds'] != null ? Clouds?.fromJson(json['clouds']) : null;
    wind = json['wind'] != null ? Wind?.fromJson(json['wind']) : null;
    visibility = json['visibility'];
    pop = json['pop'];
    sys = json['sys'] != null ? Sys?.fromJson(json['sys']) : null;
    dttxt = json['dt_txt'];
    rain = json['rain'] != null ? Rain?.fromJson(json['rain']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['main'] = main!.toJson();
    if (weather != null) {
      data['weather'] = weather!.map((v) => v?.toJson()).toList();
    } else {
      data['weather'] = null;
    }
    data['clouds'] = clouds!.toJson();
    data['wind'] = wind!.toJson();
    data['visibility'] = visibility;
    data['pop'] = pop;
    data['sys'] = sys!.toJson();
    data['dt_txt'] = dttxt;
    data['rain'] = rain!.toJson();
    return data;
  }

  @override
  String toString() {
    return 'WeatherList{dt: $dt, main: $main, weather: $weather, clouds: $clouds, wind: $wind, visibility: $visibility, pop : $pop, sys: $sys, dttxt: $dttxt, rain: $rain}';
  }
}

class Wind {
  num? speed;
  int? deg;
  num? gust;

  Wind({this.speed, this.deg, this.gust});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'];
    deg = json['deg'];
    gust = json['gust'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speed'] = speed;
    data['deg'] = deg;
    data['gust'] = gust;
    return data;
  }

  @override
  String toString() {
    return 'Wind{speed: $speed, deg: $deg, gust: $gust}';
  }
}
