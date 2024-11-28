import 'dart:io';
import 'package:bob_phone/backend/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  File? _image;
  String? _response;
  bool _isLoading = false;
  List<Map<String, dynamic>>? data;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    setState(() {
      _isLoading = true;
    });
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Api.baseUrl}/api/recognize_receipts'));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print(response.body);
    setState(() {
      _isLoading = false;
      _response =
          'Response status: ${response.statusCode}\nResponse body: ${response.body}';
      data = List<Map<String, dynamic>>.from(jsonDecode(response.body)); // Change this line
    });
    // fetchData(); // Fetch data after image upload
  }

  // Future fetchData() async {
  //   var response = await http.get('http://your-api-url.com');
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       data = jsonDecode(response.body);
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Page'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : data == null
              ? Center(child: Text('No data loaded.'))
              : ListView(
                  children: <Widget>[
                    if (_image != null) Container(height:600,width: 200, child: Image.file(_image!)),
                    Text('Merchant Name: ${data![0]['MerchantName']}'),
                    Text('Total: ${data![0]['Total']}'),
                    Text('Transaction Date: ${data![0]['TransactionDate']}'),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Total Price')),
                      ],
                      rows: List<DataRow>.generate(
                        data![0]['Items'].length,
                        (index) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(data![0]['Items'][index]['Name'])),
                            DataCell(Text(data![0]['Items'][index]['Price'].toString())),
                            DataCell(Text((data![0]['Items'][index]['Quantity'] ?? '').toString())),
                            DataCell(Text(data![0]['Items'][index]['TotalPrice'].toString())),
                  ]),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: uploadImage,
          child: Text('Upload'),
        ),
      ),
    );
  }
}