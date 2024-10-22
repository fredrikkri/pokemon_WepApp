import 'package:flutter/material.dart';
import 'package:pokemon_webapp/api/chuck_norris_service.dart';
import 'package:pokemon_webapp/api/pokemon_service.dart';
import 'package:pokemon_webapp/components/pokemon_card.dart';
import 'package:pokemon_webapp/data/joke_data.dart';
import 'package:pokemon_webapp/data/pokemon_data.dart';
import 'package:pokemon_webapp/service/user_service.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  List<String> currentUserTypes = [];
  String currentJoke = "";
  PokemonData currentPokemonData = const PokemonData(
      id: 0, name: "", height: 0, weight: 0, baseExperience: 0, types: []);

  @override
  void initState() {
    super.initState();
    getUserTypes();
    getJoke();
    mapPokemonData();
  }

  Future<void> getUserTypes() async {
    UserService userService = UserService();
    List<String> types = await userService.fetchUserTypes();

    setState(() {
      currentUserTypes = types;
    });
  }

  Future<void> getJoke() async {
    ChuckNorrisService chuckNorrisservice = ChuckNorrisService();
    JokeData joke = await chuckNorrisservice.fetchRandomChuckNorrisJoke();

    setState(() {
      currentJoke = joke.value;
    });
  }

  void mapPokemonData() async {
    PokemonService pokemonService = PokemonService();
    PokemonData currentRandomPokemon =
        await pokemonService.fetchRandomPokemon();
    String pokeName = currentRandomPokemon.name;
    print('\nHentet Pokémon-data: $pokeName\n');

    bool hasCommonPokemonType = currentRandomPokemon.types
        .any((pokemonType) => currentUserTypes.contains(pokemonType));

    if (hasCommonPokemonType) {
      setState(() {
        currentPokemonData = currentRandomPokemon;
        print('\nOppdaterte currentPokemonData: $currentPokemonData\n');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon Swipe $currentJoke"),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: currentPokemonData.id != 0
                ? PokemonCard(
                    id: currentPokemonData.id,
                    name: currentPokemonData.name,
                    joke: currentJoke,
                    height: currentPokemonData.height,
                    weight: currentPokemonData.weight,
                    baseExperience: currentPokemonData.baseExperience,
                    types: currentPokemonData.types,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close, size: 40),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.pink,
                  child: const Icon(
                    Icons.favorite,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
