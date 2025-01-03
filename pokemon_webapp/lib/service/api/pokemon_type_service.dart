import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonTypeService {
  Future<List<String>> fetchAllPokemonTypes() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/type/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> results = data['results'];
      List<String> locationNames =
          results.map((item) => item['name'] as String).toList();

      return locationNames;
    } else {
      throw Exception('Failed to load pokemontypes');
    }
  }

  Future<List<String>> fetchAllPokemonWithType(String pokemonType) async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/type/$pokemonType'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> results = data['pokemon'];
      List<String> pokemonsWithType =
          results.map((item) => item['pokemon']['name'] as String).toList();

      //print("+++++++++++++++++++++\nFetch sucess: This is all pokemon with pokemonsype: $pokemonType\n $pokemonsWithType\n+++++++++++++++++++++");

      return pokemonsWithType;
    } else {
      throw Exception('Failed to load pokemon with specific type');
    }
  }
}
