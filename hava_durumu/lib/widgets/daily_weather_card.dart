// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({
    Key? key,
    required this.date,
    required this.icon,
    required this.temperature,
  }) : super(key: key);

  final String date;
  final String icon;
  final double temperature;

  @override
  Widget build(BuildContext context) {
    List<String> weekdays = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar",
    ];

    String weekday = weekdays[DateTime.parse(date).weekday - 1];

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: Colors.black),
        ),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "http://openweathermap.org/img/wn/$icon@4x.png",
            ),
            Text(
              "$temperature",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              weekday,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
