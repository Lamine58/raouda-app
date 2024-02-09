import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Api {

  static const String baseUrl = 'https://admin.raouda-collect.ci/api/v1';
  static const String baseUrlUpload = 'https://admin.raouda-collect.ci/storage/';

  Future<dynamic> get(String endpoint) async {
    // print('$baseUrl/$endpoint');
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return false;
    }
  }

  getbaseUpload(){
    return baseUrlUpload;
  }


  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      print(data);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        return false;
      } 
    } catch (e) {
      print(e); 
      return false;
    }
  }

  Future<dynamic> url(String endpoint) async {
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return false;
    }
  }  

  upload(String endpoint,File file,data) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$endpoint')
    );

    data.forEach((key, value) {
      request.fields[key] = value; 
    });

    request.files.add(
      await http.MultipartFile.fromPath('avatar', file.path), 
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      return json.decode(jsonResponse);
    } else {
      return false;
    }
    
  }

}

