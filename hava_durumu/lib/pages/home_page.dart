// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, use_key_in_widget_constructors, must_be_immutable, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/widgets/daily_weather_card.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_text.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? devicePosition;
  dynamic responseData;
  String? location = "Ankara";
  double? temperature;
  String image = "";
  final String apiKey = "0d6e98a8c7c320f72baef522f3c31a1b";
  String icon = "";
  //----------------------------------------
  List<String> icons = ["01d", "01d", "01d", "01d", "01d"];
  List<double> temperatures = [20.0, 20.0, 20.0, 20.0, 20.0];
  List<String> dates = ["Ptesi", "Salı", "Çarşamba", "Perşembe", "Cuma"];
  //----------------------------------------

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocationDataFromAPIByLongLat() async {
    if (devicePosition != null) {
      responseData = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$apiKey&units=metric&lang=tr'));

      final locationDataParsed = jsonDecode(responseData.body);
      setState(() {
        location = locationDataParsed["name"];
        temperature = locationDataParsed["main"]["temp"];
        image = locationDataParsed["weather"][0]["main"];
        icon = locationDataParsed["weather"][0]["icon"];
      });
    }
  }

  Future<void> getLocationDataFromAPI() async {
    responseData = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=${location}&appid=$apiKey&units=metric&lang=tr'));

    final locationDataParsed = jsonDecode(responseData.body);
    setState(() {
      location = locationDataParsed["name"];
      temperature = locationDataParsed["main"]["temp"];
      image = locationDataParsed["weather"][0]["main"];
      icon = locationDataParsed["weather"][0]["icon"];
    });
  }

  Future<void> getDevicePosition() async {
    try {
      devicePosition = await _determinePosition();
    } catch (e) {
      print(e);
    } finally {
      print("finally çalıştı");
    }
  }

  Future<void> getDailyForecastByLocation() async {
    var forecastData = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$apiKey&units=metric&lang=tr'));

    var forecastDataParsed = await jsonDecode(forecastData.body);

    temperatures.clear();
    icons.clear();
    dates.clear();

    for (var i = 7; i < 40; i += 8) {
      temperatures.add(forecastDataParsed['list'][i]['main']['temp']);
      icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
      dates.add(forecastDataParsed['list'][i]['dt_txt']);
    }

    setState(() {});
  }

  Future<void> getDailyForecastByLocationByLongLat() async {
    var forecastData = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=${location}&appid=$apiKey&units=metric&lang=tr'));

    var forecastDataParsed = await jsonDecode(forecastData.body);

    temperatures.clear();
    icons.clear();
    dates.clear();

    for (var i = 7; i < 40; i += 8) {
      temperatures.add(forecastDataParsed['list'][i]['main']['temp']);
      icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
      dates.add(forecastDataParsed['list'][i]['dt_txt']);
    }

    setState(() {});
  }

  void getInitialData() async {
    await getDevicePosition();
    await getLocationDataFromAPIByLongLat();
    await getDailyForecastByLocation();
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image == "" ? "assets/home.jpg" : "assets/$image.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: temperature == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          Container(
                            child: const Text(
                              "Aşk bir konumsa bul beni Niyazi!",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: getLocationDataFromAPIByLongLat,
                            icon: Icon(Icons.location_pin),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.network("http://openweathermap.org/img/wn/$icon@4x.png"),
                    ),
                    Text(
                      "$temperature° C",
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 20),
                    Container(width: 300, height: 2, color: Colors.white),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: location ?? "Hata Oluştu!", fontSize: 35, fontWeight: FontWeight.bold),
                        IconButton(
                          onPressed: () async {
                            final selectedCity = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));

                            location = selectedCity;
                            getLocationDataFromAPI();
                            getDailyForecastByLocationByLongLat();
                          },
                          icon: const Icon(Icons.search),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildWeatherCard(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildWeatherCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: Colors.white),
      ),
      width: MediaQuery.of(context).size.width * 0.95,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: temperatures.length,
        itemBuilder: (context, index) {
          return DailyWeatherCard(
            date: dates[index],
            icon: icons[index],
            temperature: temperatures[index],
          );
        },
      ),
    );
  }
}
