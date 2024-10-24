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

  Future<PokemonData> fetchRandomPokemon() async {
    final random = Random();
    int randomPokemonId = random.nextInt(999) + 1;
    //print("Random pokemon: $randomPokemonId");

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
      rethrow;
    }
  }

  Future<PokemonData> fetchNotDislikedRandomPokemon(
      List<String> dislikedPokemons) async {
    final random = Random();
    int randomInt = random.nextInt(999) + 1;
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$randomInt');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> pokemonJson = json.decode(response.body);

        String pokemonName = pokemonJson['name'];
        if (dislikedPokemons.contains(pokemonName)) {
          print(
              "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\nUser has already disliked pokemon: $pokemonName\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
          return fetchNotDislikedRandomPokemon(dislikedPokemons);
        }
        return PokemonData.fromJson(pokemonJson);
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      print('Error fetching Pokémon: $e');
      rethrow;
    }
  }
}
