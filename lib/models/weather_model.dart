import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../common/error_handler.dart';

class WeatherModel with ChangeNotifier {
  static const _APIkey = '160dfae5be858acfedd04b5cd49e5496';

  final _weatherFactory =
      WeatherFactory(_APIkey, language: Language.CHINESE_SIMPLIFIED);

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  bool get loaded => _loaded;
  bool _loaded = false;

  Weather get weather {
    if (!_loaded) {
      loadWeatherData();
    }
    return _weather!;
  }

  Weather? _weather;

  List<Weather> get forecast {
    if (!_loaded) {
      loadWeatherData();
    }
    return _forecast!;
  }

  List<Weather>? _forecast;

  Position? _position;

  Future<void> loadPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    print('service enabled');

    permission = await Geolocator.checkPermission();
    print(permission);

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print('try getting  location');

    _position = await Geolocator.getLastKnownPosition();

    if(_position == null){
      _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        forceAndroidLocationManager: true,
        //timeLimit: const Duration(),
      );

    }

    print('get location succeed');
    print(_position);
  }

  Future<void> loadWeatherData() async {

    print('loading weather data');
    if (_isLoading) {
      print('isLoading,return');
      return;
    }
    _isLoading = true;

    if (_position == null) {
      try {
        await loadPosition();
      } catch (e, s) {
        errorPrintHandler(e, s);

        _isLoading = false;
        return Future.error('地理位置获取失败');
      }
    }

    final position = _position!;

    print('loading weather data');
    try {
      final futureA = _weatherFactory
          .currentWeatherByLocation(
            position.latitude,
            position.longitude,
          )
          .then((value) => _weather = value);

      final futureB = _weatherFactory
          .fiveDayForecastByLocation(
            position.latitude,
            position.longitude,
          )
          .then((value) => _forecast = value);

      await Future.wait([futureA, futureB]);

      print(_weather);

      print('loading completed');

      _isLoading = false;
      _loaded = true;
      notifyListeners();
    } catch (e, s) {
      errorPrintHandler(e, s);
      _isLoading = false;
      return Future.error('天气获取失败');
    }
  }

}
