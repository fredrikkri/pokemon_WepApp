import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonAreaService {
  Future<List<String>> fetchAllPokemonRegions() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/region'));

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
