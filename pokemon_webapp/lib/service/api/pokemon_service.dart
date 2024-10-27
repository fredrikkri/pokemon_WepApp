import 'dart:convert';
import 'dart:math';
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
      throw Exception('Failed to load pokemon');
    }
  }

  Future<PokemonData> fetchRandomPokemon(List<String> searhablePokemons) async {
    final random = Random();
    int randomPokemonId = random.nextInt(searhablePokemons.length);
    print(
        "Current random pokemon:\n\tId: $randomPokemonId\n\tPokemon specie: ${searhablePokemons[randomPokemonId]}\n\tCurrent pokemonlist-lenght: ${searhablePokemons.length}\n\n");
    String pokemon = searhablePokemons[randomPokemonId];

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemon');

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
      rethrow;
    }
  }

  Future<List<String>> fetchAllPokemonNames() async {
    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> results = data['results'];

      List<String> names =
          results.map((item) => item['name'] as String).toList();

      return names;
    } else {
      throw Exception('Failed to load all pokemon names');
    }
  }
}
