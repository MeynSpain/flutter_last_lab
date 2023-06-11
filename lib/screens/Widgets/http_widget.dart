import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:http/http.dart' as http;

// import '../../model/data_point.dart';

class HttpWidget extends StatefulWidget {
  const HttpWidget({Key? key}) : super(key: key);

  @override
  State<HttpWidget> createState() => _HttpWidgetState();
}

class _HttpWidgetState extends State<HttpWidget> {
  final _urlController =
      TextEditingController(text: 'https://api.random.org/json-rpc/4/invoke');

  List<TimeSeriesSales> _dataPoints = [];

  Future<int> getRandomNumber() async {
    final url = Uri.parse('https://api.random.org/json-rpc/4/invoke');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "jsonrpc": "2.0",
        "method": "generateIntegers",
        "params": {
          "apiKey": "1b9d9e7f-0d8e-4f4b-a7e2-3b1c9152a2e9",
          "n": 1,
          "min": 1,
          "max": 100,
          "replacement": true,
          "base": 10
        },
        "id": 1
      }),
    );
    print('Status:${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      int randomNumber = jsonResponse['result']['random']['data'][0];
      print(randomNumber);
      return randomNumber;
    } else {
      throw Exception('Failed to get random number');
    }
  }

  void clearData() {
    setState(() {
      _dataPoints.clear();

    });
  }

  // List<charts.Series<TimeSeriesSales, DateTime>> seriesList = [
  //   charts.Series<TimeSeriesSales, DateTime>(
  //     id: 'Sales',
  //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //     domainFn: (data, _) => data.time,
  //     measureFn: (data, _) => data.sales,
  //     data: _dataPoints,
  //   )
  // ];


@override
  Widget build(BuildContext context) {
  List<charts.Series<TimeSeriesSales, DateTime>> seriesList = [
    charts.Series<TimeSeriesSales, DateTime>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (data, _) => data.time,
      measureFn: (data, _) => data.sales,
      data: _dataPoints,
    )
  ];
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: getUrlText(),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: TextField(
              controller: _urlController,
            ),
          ),
          ElevatedButton(onPressed: () async {
            int randomNumber = await getRandomNumber();
            DateTime time = DateTime.now();
            print(time);
            setState(() {
              // _dataPoints.add(DataPoint(time: time, number:randomNumber));
              _dataPoints.add(TimeSeriesSales(time, randomNumber));
              // обновить данные на графике
            });

          },
              child: const Text('Get')),
          SizedBox(height: 16.0),
          SizedBox(
              height: 350,
              child: charts.TimeSeriesChart(
                seriesList,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                domainAxis: charts.DateTimeAxisSpec(
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                    minute: charts.TimeFormatterSpec(
                      format: 'mm:ss',
                      transitionFormat: 'mm:ss',
                    ),
                  ),
                ),
              ),
          ),
          ElevatedButton(
              onPressed: clearData,
              child: const Text('Clear'))
        ],
      ),
    );
  }

  Widget getUrlText() {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'U',
          style: TextStyle(
            fontSize: 30,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.lightBlue, Colors.blue],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 20.0, 20.0)),
          ),
        ),
        TextSpan(
          text: 'R',
          style: TextStyle(
            fontSize: 30,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.lightBlue, Colors.blue, Colors.blue],
                stops: [0.0, 0.5, 1.0],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 20.0, 20.0)),
          ),
        ),
        TextSpan(
          text: 'L',
          style: TextStyle(
            fontSize: 30,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.blue, Colors.blue.shade900],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 20.0, 20.0)),
          ),
        ),
      ]),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}