import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:true_shoe/weather.dart';
import 'package:true_shoe/weatherdata.dart';

import 'package:http/http.dart' as http;

import 'package:location/location.dart';
import 'package:flutter/services.dart';

//key 9b4c04c1a86c05ef46918fd12c8af1ce

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

  class MyAppState extends State<MyApp> {
    bool isLoading = false;
    WeatherData weatherData;

    Location _location = new Location();
    String error;

    @override
    void initState() {
      super.initState();

      loadWeather();
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'True Shoe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text('True Shoe'),
          ),
          body: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: weatherData != null ? Weather(weather: weatherData) : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading ? CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: new AlwaysStoppedAnimation(Colors.white),
                      ) : IconButton(
                        icon: new Icon(Icons.refresh),
                        tooltip: 'Refresh',
                        onPressed: loadWeather,
                        color: Colors.white,
                      ),
                    )
                  ]
              )
          )
      ),
    );
  }

    loadWeather() async {
      setState(() {
        isLoading = true;
      });

      LocationData location;

      try {
        location = await  _location.getLocation();

        error = null;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error = 'Permission denied - please ask the user to enable it from the app settings';
        }

        location = null;
      }

      if (location != null) {
        final lat = location.latitude;
        final lon = location.longitude;

        final weatherResponse = await http.get(
            'https://api.openweathermap.org/data/2.5/weather?APPID=9b4c04c1a86c05ef46918fd12c8af1ce&lat=${lat
                .toString()}&lon=${lon.toString()}');

        if (weatherResponse.statusCode == 200) {
          return setState(() {
            weatherData =
            new WeatherData.fromJson(jsonDecode(weatherResponse.body));
            isLoading = false;
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    }



}