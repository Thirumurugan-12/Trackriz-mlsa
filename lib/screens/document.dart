import 'dart:convert';
import 'dart:io';
import 'package:bob_phone/backend/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentVerificationPage extends StatefulWidget {
  @override
  _DocumentVerificationPageState createState() =>
      _DocumentVerificationPageState();
}

class _DocumentVerificationPageState extends State<DocumentVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _name;
  String? _address;
  List<dynamic> _response = [];
  String? _message;
  var response2;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _aadharNumber = TextEditingController();
  bool _isLoading = false;

  File? _image2;

// Add a new function to handle the file selection and analysis
  Future<void> analyzeSecondDocument() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image2 = File(pickedFile.path);
      });

      var request = http.MultipartRequest(
          'POST', Uri.parse('${Api.baseUrl}/api/analyze_identity_documents'));
      request.files
          .add(await http.MultipartFile.fromPath('file', _image2!.path));
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      var data2 = jsonDecode(response.body);
      setState(() {
        response2 = jsonDecode(response.body);
        print(response2);
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Verification'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) => _name = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => _name = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _aadharNumber,
                decoration: InputDecoration(labelText: 'Aadhar number'),
                onSaved: (value) => _address = value,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Upload Aadhar Card'),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: analyzeSecondDocument,
              child: Text('Upload Health Card'),
            ),
            // Text(_response ?? ''),
            ListTile(
              title: Text(
                'Document Number: ${_response.isNotEmpty ? _response[0]['DocumentNumber'] : 'N/A'}',
                style: TextStyle(fontSize: 30),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'First Name: ${_response.isNotEmpty ? _response[0]['FirstName'] : 'N/A'}',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'Last Name: ${_response.isNotEmpty ? _response[0]['LastName'] : 'N/A'}',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            Text(
              _message ?? '',
              style: _message == 'KYC verification is successful'
                  ? TextStyle(color: Colors.greenAccent, fontSize: 30)
                  : TextStyle(color: Colors.redAccent, fontSize: 30),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Set _isLoading to true when the request starts
            setState(() {
              _isLoading = true;
            });

            _formKey.currentState!.save();

            var request = http.MultipartRequest('POST',
                Uri.parse('${Api.baseUrl}/api/analyze_identity_documents'));
            request.files
                .add(await http.MultipartFile.fromPath('file', _image!.path));
            var res = await request.send();
            var response = await http.Response.fromStream(res);

            var data = jsonDecode(response.body);

            setState(() {
              _response = jsonDecode(response.body);
            });
            print(_firstName.text.trim());
            print(_lastName.text.trim());
            print(_response);
            if (data[0]['FirstName'].trim() == _firstName.text.trim() &&
                data[0]['LastName'].trim() == _lastName.text.trim() &&
                data[0]['DocumentNumber'].trim() == _aadharNumber.text.trim() &&
                response2[0]['FirstName'].trim() == data[0]['FirstName'].trim() &&
                response2[0]['LastName'].trim() == data[0]['LastName'].trim() 
                ) {
              setState(() {
                _message = 'KYC verification is successful';
              });
            } else {
              setState(() {
                _message = 'KYC failed';
              });
            }

            setState(() {
              _isLoading = false;
            });
          }
        },
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text('Submit'),
      ),
    );
  }
}
