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
      id: 0,
      name: "",
      joke: "",
      height: 0,
      weight: 0,
      baseExperience: 0,
      types: []);

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

  // void mapPokemonData() async {
  //   PokemonService pokemonService = PokemonService();
  //   PokemonData currentRandomPokemon =
  //       await pokemonService.fetchRandomPokemon();

  //   for (String pokemonTypes in currentRandomPokemon.types) {
  //     bool hasCommonPokemonType = currentRandomPokemon.types
  //         .any((pokemonType) => currentUserTypes.contains(pokemonTypes));

  //     if (hasCommonPokemonType) {
  //       setState(() {
  //         currentPokemonData = currentRandomPokemon;
  //       });
  //       break;
  //     }
  //   }
  // }
  void mapPokemonData() async {
    PokemonService pokemonService = PokemonService();
    PokemonData currentRandomPokemon =
        await pokemonService.fetchRandomPokemon();

    // Sjekk om noen av currentRandomPokemon.types matcher currentUserTypes
    bool hasCommonPokemonType = currentRandomPokemon.types
        .any((pokemonType) => currentUserTypes.contains(pokemonType));

    if (hasCommonPokemonType) {
      setState(() {
        currentPokemonData =
            currentRandomPokemon; // Oppdater med den tilfeldige Pokémon
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
          const Expanded(
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
                : Center(
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
