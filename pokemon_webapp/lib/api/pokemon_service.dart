import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:pokemon_webapp/data/pokemon_data.dart';
import 'package:pokemon_webapp/data/pokemon_data_short.dart';

class PokemonService {
  Future<PokemonData> fetchPokemon(String name) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));

    if (response.statusCode == 200) {
      return PokemonData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load pokemon');
    }
  }

  Future<PokemonData> fetchRandomPokemon() async {
    final random = Random();
    int randomPokemonId = random.nextInt(10276) + 1;

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$randomPokemonId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> pokemonJson = json.decode(response.body);
        return PokemonData.fromJson(pokemonJson);
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      print('Error fetching Pokémon: $e');
      throw e;
    }
  }

  Future<List<PokemonDataShort>> fetchAllPokemon() async {
    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = jsonData['results'];
      return results
          .map((pokemon) =>
              PokemonDataShort.fromJson(pokemon as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load Pokemons');
    }
  }
}
