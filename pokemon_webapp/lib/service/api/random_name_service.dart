import 'dart:convert';
import 'package:http/http.dart' as http;

class RandomNameService {
  Future<String> fetchRandomName() async {
    final response = await http
        .get(Uri.parse('https://randomuser.me/api/?results=1&inc=name'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final results = jsonResponse['results'] as List<dynamic>;

      if (results.isNotEmpty) {
        return results[0]['name']['first'] as String;
      } else {
        return "No Name";
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
