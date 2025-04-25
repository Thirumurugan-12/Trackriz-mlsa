import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class PredictStockPage extends StatefulWidget {
  @override
  _PredictStockPageState createState() => _PredictStockPageState();
}

class _PredictStockPageState extends State<PredictStockPage> {
  Future<String>? _prediction;

  List<FlSpot> spots = [];

  Future<void> loadSpots() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('assets/microsoft.csv');
    print(file);
    final csvFile = await file.readAsString();
    final csvList = CsvToListConverter().convert(csvFile);

    for (var i = 1; i < csvList.length; i++) {
      spots.add(FlSpot(i.toDouble(), double.parse(csvList[i][1].toString())));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadSpots();
  }

  final _formKey = GlobalKey<FormState>();
  final _openController = TextEditingController();
  final _highController = TextEditingController();
  final _lowController = TextEditingController();
  final _adjCloseController = TextEditingController();
  final _volumeController = TextEditingController();

  String _predictionResult = '';

  Future<void> generateReport(String stock) async {
    DateTime date = DateTime.now();
    final responsepredict = await http.post(
      Uri.parse('http://20.55.35.116:5000/api/generate_content'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt':
            "Generate a detailed stock price prediction recommendation for Microsoft and predicted stock value is ${stock} , the report is for msft side in simple points",
      }),
    );

    if (responsepredict.statusCode == 200) {
      var responseBody = jsonDecode(responsepredict.body);
      print(responseBody);
      _predictionResult = responseBody['content'];
      setState(() {
        _predictionResult = responseBody['content'];
      });
    } else {
      throw Exception('Failed to generate report');
    }
  }

  Future<List<FlSpot>> _predictStocksPrices() async {
    List<FlSpot> predictions = [];

    for (int i = 0; i < 10; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      final response = await http.post(
        Uri.parse(
            'https://trackriz-ml-fmacd.swedencentral.inference.ml.azure.com/score'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ('Bearer ' +
              '2gBMZR5UlVtKr8g01fF1xmZ6zAWXyz7yWL9Ycb7p9WvYc9fAodKpJQQJ99BDAAAAAAAAAAAAINFRAZML4S13'),
          "azureml-model-deployment": "markettrackriz8-1"
        },
        body: jsonEncode({
          'input_data': {
            'data': [
              {
                'Datetime': DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                    .format(DateTime.now()),
                'Open': double.parse(_openController.text),
                'High': double.parse(_highController.text),
                'Low': double.parse(_lowController.text),
                'Adj Close': double.parse(_adjCloseController.text),
                'Volume': int.parse(_volumeController.text),
              },
            ],
          },
          'GlobalParameters': 0,
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print(responseBody);
        List<dynamic> results = responseBody;
        double prediction = results[0];
        predictions.add(FlSpot(i.toDouble(), prediction));
        if (predictions.isNotEmpty) {
          return predictions;
        } else {
          throw Exception('Failed to predict stock price');
        }
      } else {
        throw Exception('Failed to predict stock price');
      }
    }

    return predictions;
  }

  Future<String> _predictStockPrice() async {
    if (_formKey.currentState!.validate()) {
      showOverlayNotification(context, 'Prediction started...');
      final response = await http.post(
        Uri.parse(
            'https://trackriz-ml-fmacd.swedencentral.inference.ml.azure.com/score'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ('Bearer ' +
              '2gBMZR5UlVtKr8g01fF1xmZ6zAWXyz7yWL9Ycb7p9WvYc9fAodKpJQQJ99BDAAAAAAAAAAAAINFRAZML4S13'),
          "azureml-model-deployment": "markettrackriz8-1"
        },
        body: jsonEncode({
          'input_data': {
            'data': [
              {
                'Datetime': DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                    .format(DateTime.now()),
                'Open': double.parse(_openController.text),
                'High': double.parse(_highController.text),
                'Low': double.parse(_lowController.text),
                'Adj Close': double.parse(_adjCloseController.text),
                'Volume': int.parse(_volumeController.text),
              },
            ],
          },
          'GlobalParameters': 0,
        }),
      );

      if (response.statusCode == 200) {
        generateReport(response.body);
        showOverlayNotification(context, 'Prediction complete.');

        // Add a 3-second delay before showing the "Best time to buy" notification
        await Future.delayed(Duration(seconds: 3));

        showOverlayNotification(context, 'Best time to buy is now!');
        return response.body;
      } else {
        throw Exception('Failed to predict stock price ${response.body}');
      }
    } else {
      throw Exception('Form validation failed');
    }
  }

  void showOverlayNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                Icon(Icons.check_circle, color: Colors.greenAccent),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3)).then((_) => overlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Predict Stock Price')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _openController,
                decoration: InputDecoration(labelText: 'Open'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a number' : null,
              ),
              TextFormField(
                controller: _highController,
                decoration: InputDecoration(labelText: 'High'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a number' : null,
              ),
              TextFormField(
                controller: _lowController,
                decoration: InputDecoration(labelText: 'Low'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a number' : null,
              ),
              TextFormField(
                controller: _adjCloseController,
                decoration: InputDecoration(labelText: 'Adj Close'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a number' : null,
              ),
              TextFormField(
                controller: _volumeController,
                decoration: InputDecoration(labelText: 'Volume'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a number' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _prediction = _predictStockPrice();
                    _predictStocksPrices();
                    loadSpots();
                  });
                },
                child: Text('Predict'),
              ),
              FutureBuilder<String>( 
                future: _prediction, 
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      'Predicted Stock Price: ${snapshot.data}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    );
                  }
                },
              ),
              spots.isNotEmpty
                  ? Container(
                      height: 200,
                      width: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(child: Text('No data available')),
              Container(child: Text(_predictionResult)),
              Container(
                height: 200,
                child: FutureBuilder<List<FlSpot>>(
                  future: _predictStocksPrices(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<FlSpot>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView(
                        children: [
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Days')),
                              DataColumn(label: Text('Price')),
                            ],
                            rows: snapshot.data!
                                .map(
                                  (spot) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text('${spot.x}')),
                                      DataCell(Text('${spot.y}')),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
