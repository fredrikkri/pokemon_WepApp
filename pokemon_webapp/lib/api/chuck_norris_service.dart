import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_webapp/data/joke_data.dart';

class ChuckNorrisService {
  Future<JokeData> fetchRandomChuckNorrisJoke() async {
    final response =
        await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));

    if (response.statusCode == 200) {
      return JokeData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<String>> fetchListChuckNorrisJokesByPokemontype(
      String pokemontype) async {
    final response = await http.get(Uri.parse(
        'https://api.chucknorris.io/jokes/search?query=$pokemontype'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      List<dynamic> results = data['result'];
      List<String> jokesList =
          results.map((item) => item['value'] as String).toList();

      return jokesList;
    } else {
      throw Exception('Failed to load jokes');
    }
  }
}
