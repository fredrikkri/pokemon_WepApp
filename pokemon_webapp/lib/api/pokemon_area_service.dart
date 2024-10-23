import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonAreaService {
  Future<List<String>> fetchAllPokemonAreas() async {
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/location-area/?offset=0&limit=1054'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> results = data['results'];
      List<String> locationNames =
          results.map((item) => item['name'] as String).toList();

      return locationNames;
    } else {
      throw Exception('Failed to load pokemon-areas');
    }
  }
}
