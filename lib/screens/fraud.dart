import 'package:bob_phone/backend/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FraudDetectScreen extends StatefulWidget {
  @override
  _FraudDetectScreenState createState() => _FraudDetectScreenState();
}

class _FraudDetectScreenState extends State<FraudDetectScreen> {
  List<Map<String, dynamic>> transactions = [];
  late Future<void> _fetchTransactionsFuture;

  Map<int, String> typeMapping = {
  0: 'CASH_IN',
  1: 'CASH_OUT',
  2: 'DEBIT',
  3: 'PAYMENT',
  4: 'TRANSFER',
};

  @override
  void initState() {
    super.initState();
    _fetchTransactionsFuture = fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    var response = await http.post(
    Uri.parse('${Api.baseUrl}/api/fraud_data'),
    body: jsonEncode({'num': 30}),
    headers: {'Content-Type': 'application/json'},
  );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        transactions = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print(
          'Request failed with status: ${response.statusCode}. ${response.body}');
    }
  }

  Future<void> checkFraud(Map<String, dynamic> transaction) async {
    var requestBody = {
      'data': [
        {
          'type': transaction['type'],
          'amount': transaction['amount'],
          'oldbalanceOrg': transaction['oldbalanceOrg'],
          'newbalanceOrig': transaction['newbalanceOrig'],
          'oldbalanceDest': transaction['oldbalanceDest'],
          'newbalanceDest': transaction['newbalanceDest'],
          'hour': transaction['hour'],
          'dayOfMonth': transaction['dayOfMonth'],
          'isMerchantDest': transaction['isMerchantDest'],
          'errorBalanceOrig': transaction['errorBalanceOrig'],
          'errorBalanceDest': transaction['errorBalanceDest'],
        },
      ],
    };

    var response = await http.post(
      Uri.parse(
          'https://trackriz-api.centralindia.inference.ml.azure.com/score'),
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ('Bearer ' + "vSqyxOND5A0JvhCFbzRqJjafMGqdycij"),
        'azureml-model-deployment': 'fraud-ga'
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['prediction'] == '1') {
        print("Data: $data");
        var url = http.post(Uri.parse(
          'https://trackriz-api.azurewebsites.net/api/send_report') , body: jsonEncode({'transaction': typeMapping[transaction['type']]?.toString()}) , headers: {'Content-Type': 'application/json'});
      } 
      
      setState(() {
        transaction['prediction'] = data[
            'prediction']; // Replace 'prediction' with the actual key in the response
      });
    } else {
      print(
          'Request failed with status: ${response.statusCode} ${response.body}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fraud Detect'),
      ),
      body: FutureBuilder(
        future: _fetchTransactionsFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            // If there is an error, return a Text widget with the error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If the data is loaded, return the DataTable
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Old Balance Org')),
                    DataColumn(label: Text('New Balance Orig')),
                    DataColumn(label: Text('Old Balance Dest')),
                    DataColumn(label: Text('New Balance Dest')),
                    DataColumn(label: Text('Hour')),
                    DataColumn(label: Text('Day of Month')),
                    DataColumn(label: Text('Is Merchant Dest')),
                    DataColumn(label: Text('Error Balance Orig')),
                    DataColumn(label: Text('Error Balance Dest')),
                    DataColumn(label: Text('Test')),
                  ],
                  rows: transactions.map((transaction) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(typeMapping[transaction['type']]?.toString() ?? 'Unknown')),
                        DataCell(Text(transaction['amount'].toString())),
                        DataCell(Text(transaction['oldbalanceOrg'].toString())),
                        DataCell(Text(transaction['newbalanceOrig'].toString())),
                        DataCell(Text(transaction['oldbalanceDest'].toString())),
                        DataCell(Text(transaction['newbalanceDest'].toString())),
                        DataCell(Text(transaction['hour'].toString())),
                        DataCell(Text(transaction['dayOfMonth'].toString())),
                        DataCell(Text(transaction['isMerchantDest'].toString())),
                        DataCell(
                            Text(transaction['errorBalanceOrig'].toString())),
                        DataCell(
                            Text(transaction['errorBalanceDest'].toString())),
                        DataCell(
                          transaction['prediction'] == null
                              ? ElevatedButton(
                                  child: Text('Test'),
                                  onPressed: () => checkFraud(transaction),
                                )
                              : Text(transaction['prediction'] == '1' ? 'Fraud Transaction' : 'Genuine Transaction'),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
