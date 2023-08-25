// ignore_for_file: unused_local_variable, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? location = "Ankara";
  double? temperature;
  final String apiKey = "0d6e98a8c7c320f72baef522f3c31a1b";

  final TextEditingController controller = TextEditingController();
  String selectedCity = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/search.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                controller: controller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                  hintText: "Şehir Seçin",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=${selectedCity}&appid=$apiKey&units=metric&lang=tr'));

                if (response.statusCode == 200) {
                  Navigator.pop(context, selectedCity);
                } else {
                  MotionToast(
                    icon: Icons.zoom_out,
                    primaryColor: Colors.orange[500]!,
                    secondaryColor: Colors.grey,
                    backgroundType: BackgroundType.solid,
                    title: Text('Two Color Motion Toast'),
                    description: Text('Another motion toast example'),
                    displayBorder: true,
                    displaySideBar: false,
                  ).show(context);
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: const Text("Tamam"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
