import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonRegionService {
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

  Future<List<String>> fetchAllPokemonWithRegion(String region) async {
    int id = 0;
    switch (region) {
      case "kanto":
        id = 2;
        break;
      case "johto":
        id = 3;
        break;
      case "hoenn":
        id = 4;
        break;
      case "sinnoh":
        id = 5;
        break;
      case "unova":
        id = 8;
        break;
      case "kalos":
        id = 12;
        break;
      case "alola":
        id = 17;
        break;
      case "galar":
        id = 27;
        break;
      case "hisui":
        id = 30;
        break;
      case "paldea":
        id = 31;
        break;
      default:
        throw Exception("Region not found: $region");
    }
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokedex/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> results = data['pokemon_entries'];
      List<String> pokemonsInRegion = results
          .map((item) => item['pokemon_species']['name'] as String)
          .toList();

      //print(
      //  "+++++++++++++++++++++\nFetch sucess: This is all pokemons in region: $region\n $pokemonsInRegion\n+++++++++++++++++++++");

      return pokemonsInRegion;
    } else {
      throw Exception('Failed to load pokemon in chosen region');
    }
  }
}
