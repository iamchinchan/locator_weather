import 'package:flutter/material.dart';
import 'package:locator/utilities/constants.dart';
import '../services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({required this.weatherData, Key? key}) : super(key: key);
  final dynamic weatherData;
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temperature = 32;
  String weatherIcon = '☀️';
  String weatherDescription = 'It\'s 🍦 time in San Francisco!';
  void updateUI(dynamic weatherData) {
    if (weatherData == null) {
      setState(() {
        temperature = 0;
        weatherIcon = '❌';
        weatherDescription = 'Either Location disabled or permission denied';
      });
    } else {
      setState(() {
        temperature = weatherData['main']['temp'].toInt();
        weatherIcon =
            WeatherModel().getWeatherIcon(weatherData['weather'][0]['id']);
        weatherDescription =
            '${WeatherModel().getMessage(temperature)} in ${weatherData['name']}';
      });
    }
  }

  @override
  void initState() {
    updateUI(widget.weatherData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        // constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      dynamic weatherData = await WeatherModel()
                          .getWeatherDataAtCurrentLocation();
                      // print(weatherData);
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      dynamic cityName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      dynamic weatherData = await WeatherModel()
                          .getWeatherInCity(cityName.toString());
                      if (weatherData != null) {
                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      temperature.toString(),
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon.toString(),
                      style: const TextStyle(fontSize: 50.0),
                      // style: kConditionTextStyle,
                      // overflow: null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, bottom: 15.0),
                child: Text(
                  weatherDescription,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
