import 'dart:ui';

import 'package:bob_phone/screens/credit.dart';
import 'package:bob_phone/screens/document.dart';
import 'package:bob_phone/screens/fraud.dart';
import 'package:bob_phone/screens/invoice.dart';
import 'package:bob_phone/screens/stocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Center(child: Text('TrackRiz' ,style: GoogleFonts.manrope(fontStyle: FontStyle.italic),)),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.orange,
                  Colors.black38,
                ],
              ),
            ),
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              children: <Widget>[
                buildCard(
                  context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InvoicePage()),
                    );
                  },
                  icon: Icons.inventory,
                  title: 'Invoice Management',
                  subtitle: 'Manage your invoices and Track here',
                ),
                buildCard(
                  context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentVerificationPage()),
                    );
                  },
                  icon: Icons.document_scanner,
                  title: 'KYC Verification',
                  subtitle: 'Verify your documents here',
                ),
                buildCard(
                  context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PredictStockPage()),
                    );
                  },
                  icon: Icons.credit_score,
                  title: 'Stock Risk Prediction',
                  subtitle: 'Predictive Analysis of Stock Market',
                ),
                buildCard(
                  context,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FraudDetectScreen()),
                    );
                  },
                  icon: Icons.shield,
                  title: 'Fraud Detection',
                  subtitle: 'Detect fraud here',
                ),
                // Add more cards here
              ],
            ),
          ),
          Positioned(
            left: 40,
            bottom: 0,
            child: Image.asset(
              'assets/Bank-of-Baroda-Logo.png',
              width: 400,
            ), // replace 'assets/logo.png' with your logo's path
          ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context,
      {required VoidCallback onTap,
      required IconData icon,
      required String title,
      required String subtitle}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InkWell(
          onTap: onTap,
          child: Container(
            height: 200, // Set the height
            width: constraints.maxWidth > 600
                ? 200
                : constraints.maxWidth * 0.9, // Set the width
            child: Card(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(

                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(2.0),
                      border: Border.all(
                        width: 3.0,
                        color: Colors.orange.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(icon, size: 64.0), // Logo
                          SizedBox(height: 10.0), // Spacing
                          Text(
                            title,
                            style: GoogleFonts.manrope(fontSize: 25),
                          ), // Name
                          SizedBox(height: 10.0), // Spacing
                          Text(subtitle), // Subtitle
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
