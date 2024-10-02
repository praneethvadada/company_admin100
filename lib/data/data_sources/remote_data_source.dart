import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/admin_model.dart';

class RemoteDataSource {
  Future<AdminModel> login(String username, String password) async {
    final url = 'http://localhost:3000/admins/login';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'username': username, 'password': password});

    print('--- Sending Request ---');
    print('URL: $url');
    print('Headers: $headers');
    print('Body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('--- Response Received ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return AdminModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
