import 'package:geolocator/geolocator.dart';
import 'networking.dart';
import './location.dart';
import 'package:flutter/gestures.dart';
import 'keys.dart';

class WeatherModel {
  Future<dynamic> getWeatherDataAtLocation(Position? pos) async {
    if (pos == null) {
      return null;
    } else {
      //get weather data through network and API and return that parsed data
      return await Network(
          domain: 'api.openweathermap.org',
          unencodedPath: '/data/2.5/weather',
          queryParameters: {
            'lat': pos.latitude.toString(),
            'lon': pos.longitude.toString(),
            'appid': apiKey,
            'units': 'metric'
          }).getRequest();
    }
  }

  Future<dynamic> getWeatherDataAtCurrentLocation() async {
    Position? currentPosition = await Location().getCurrentPosition();
    return await getWeatherDataAtLocation(currentPosition);
  }

  Future<dynamic> getWeatherDataAtLastLocation() async {
    Position? lastPosition = await Location().getLastPosition();
    return await getWeatherDataAtLocation(lastPosition);
  }

  Future<dynamic> getWeatherInCity(String? city) async {
    if (city == null || city == '') {
      return null;
    } else {
      return await Network(
              domain: 'api.openweathermap.org',
              unencodedPath: '/data/2.5/weather',
              queryParameters: {'q': city, 'appid': apiKey, 'units': 'metric'})
          .getRequest();
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
