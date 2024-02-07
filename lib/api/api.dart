import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {

  static const String baseUrl = 'https://raouda-collecte.paiementpro.net/api/v1';
  static const String baseUrlUpload = 'https://raouda-collecte.paiementpro.net/storage/';

  Future<dynamic> get(String endpoint) async {
    // print('$baseUrl/$endpoint');
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    print(response.body);
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

}
