// Suggested code may be subject to a license. Learn more: ~LicenseLog:176698162.
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CreditPage extends StatefulWidget {
  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  double creditScore = 750;
  double availableLoanAmount = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Credit Score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            new CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 10.0,
              percent: creditScore / 850,
              center: new Text(
                '$creditScore',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.green,
            ),
            SizedBox(height: 30),
            Text(
              'Available Loan Amount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$${availableLoanAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
