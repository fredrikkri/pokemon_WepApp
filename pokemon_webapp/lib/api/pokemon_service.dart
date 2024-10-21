import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_webapp/data/pokemon_data.dart';

class PokemonService {
  Future<PokemonData> fetchPokemon(String name) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));

    if (response.statusCode == 200) {
      return PokemonData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load album');
    }
  }
}
