import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_webapp/api/chuck_norris_service.dart';
import 'package:pokemon_webapp/api/pokemon_region_service.dart';
import 'package:pokemon_webapp/api/pokemon_service.dart';
import 'package:pokemon_webapp/api/pokemon_type_service.dart';
import 'package:pokemon_webapp/api/random_name_service.dart';
import 'package:pokemon_webapp/components/pokemon_card.dart';
import 'package:pokemon_webapp/components/select_pokemontypes_section.dart';
import 'package:pokemon_webapp/components/select_regions_section.dart';
import 'package:pokemon_webapp/data/joke_data.dart';
import 'package:pokemon_webapp/data/pokemon_data.dart';
import 'package:pokemon_webapp/pages/disliked_pokemon_page.dart';
import 'package:pokemon_webapp/pages/liked_pokemon_page.dart';
import 'package:pokemon_webapp/service/user_service.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  UserService userService = UserService();
  PokemonService pokemonService = PokemonService();
  PokemonTypeService pokemonTypeService = PokemonTypeService();
  PokemonRegionService pokemonRegionService = PokemonRegionService();
  RandomNameService randomNameService = RandomNameService();
  ChuckNorrisService chuckNorrisservice = ChuckNorrisService();
  final random = Random();
  List<String> currentUserTypes = [];
  List<String> currentUserRegions = [];
  String currentJoke = "";
  String currentHumanName = "";
  List<String> searchablePokemons = [];
  PokemonData currentPokemonData = const PokemonData(
      id: 0,
      name: "",
      height: 0,
      weight: 0,
      baseExperience: 0,
      types: [],
      img: "");

  @override
  void initState() {
    super.initState();
    getAllPokemon();
    getUserTypes();
    mapPokemonData();
  }

  Future<void> getAllPokemon() async {
    List<String> allPokemonNames = await pokemonService.fetchAllPokemonNames();
    setState(() {
      searchablePokemons = allPokemonNames;
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  Future<void> getUserTypes() async {
    List<String> types = await userService.fetchUserTypes();

    setState(() {
      currentUserTypes = types;
    });
  }

  Future<void> getUserRegions() async {
    List<String> regions = await userService.fetchUserRegions();

    setState(() {
      currentUserRegions = regions;
    });
  }

  Future<void> getJoke() async {
    if (currentPokemonData.types.isNotEmpty) {
      List<String> listJokes = await chuckNorrisservice
          .fetchListChuckNorrisJokesByPokemontype(currentPokemonData.types[0]);

      print("JOKE BASED ON TYPE HAS BEEN MADE");

      if (listJokes.isNotEmpty) {
        final random = Random();
        int randomNumber = random.nextInt(listJokes.length);

        setState(() {
          currentJoke = listJokes[randomNumber];
        });
      }
    } else {
      JokeData joke = await chuckNorrisservice.fetchRandomChuckNorrisJoke();

      setState(() {
        currentJoke = joke.value;
      });
    }
  }

  Future<void> getHumanName() async {
    String randomName = await randomNameService.fetchRandomName();

    setState(() {
      currentHumanName = randomName.toString();
    });
  }

  void mapPokemonData() async {
    getAllPokemon();
    // Filtrere pokemontyper
    List<String> currentUserTypes = await userService.fetchUserTypes();

    if (currentUserTypes.isNotEmpty) {
      for (int i = 0; i < currentUserTypes.length; i++) {
        List<String> filteredPokemonByType = await pokemonTypeService
            .fetchAllPokemonWithType(currentUserTypes[i]);
        searchablePokemons
            .retainWhere((pokemon) => filteredPokemonByType.contains(pokemon));
      }
    }
    // Filtrere regioner
    List<String> currentUserRegions = await userService.fetchUserRegions();

    if (currentUserRegions.isNotEmpty) {
      Set<String> allowedPokemons = {};

      for (int i = 0; i < currentUserRegions.length; i++) {
        List<String> filteredPokemonByRegion = await pokemonRegionService
            .fetchAllPokemonWithRegion(currentUserRegions[i]);

        allowedPokemons.addAll(filteredPokemonByRegion);
      }
      searchablePokemons
          .retainWhere((pokemon) => allowedPokemons.contains(pokemon));
    }
    // Filtrer disliked pokemons
    List<String> dislikedPokemonNames =
        await userService.fetchDislikedPokemonNames();

    searchablePokemons
        .removeWhere((pokemon) => dislikedPokemonNames.contains(pokemon));

    // Genererer random pokemon utfra filtrering på dislike, type og region
    print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\nAll Searchable Pokemons:\n$searchablePokemons\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");

    PokemonData currentRandomPokemon =
        await pokemonService.fetchRandomPokemon(searchablePokemons);

    setState(() {
      currentPokemonData = PokemonData(
        id: currentRandomPokemon.id,
        name: currentRandomPokemon.name,
        height: currentRandomPokemon.height,
        weight: currentRandomPokemon.weight,
        baseExperience: currentRandomPokemon.baseExperience,
        types: currentRandomPokemon.types,
        img: currentRandomPokemon.img,
      );
      getUserTypes();
      getUserRegions();
      getHumanName();
      getJoke();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        title: const Text("Pokemon Swipe"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.heart_broken_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DislikedPokemonPage()),
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LikedPokemonPage()),
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select regions section
          const Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: SelectRegionsSection(),
                ),
              ],
            ),
          ),
          // Swipe Pokemon section
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: currentPokemonData.id != 0
                      ? PokemonCard(
                          id: currentPokemonData.id,
                          humanName: currentHumanName,
                          name: currentPokemonData.name,
                          joke: currentJoke,
                          height: currentPokemonData.height,
                          weight: currentPokemonData.weight,
                          baseExperience: currentPokemonData.baseExperience,
                          types: currentPokemonData.types,
                          img: currentPokemonData.img,
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          mapPokemonData();
                          UserService().dislikePokemon(
                            currentPokemonData.id,
                            currentHumanName,
                            currentPokemonData.name,
                            currentJoke,
                            currentPokemonData.height,
                            currentPokemonData.weight,
                            currentPokemonData.baseExperience,
                            currentPokemonData.types,
                            currentPokemonData.img,
                          );
                        },
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.close, size: 40),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          mapPokemonData();
                        },
                        backgroundColor: Colors.grey,
                        mini: true,
                        child: const Icon(Icons.refresh, size: 40),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          mapPokemonData();
                          UserService().likePokemon(
                            currentPokemonData.id,
                            currentHumanName,
                            currentPokemonData.name,
                            currentJoke,
                            currentPokemonData.height,
                            currentPokemonData.weight,
                            currentPokemonData.baseExperience,
                            currentPokemonData.types,
                            currentPokemonData.img,
                          );
                        },
                        backgroundColor: Colors.blue[200],
                        child: const Icon(
                          Icons.favorite,
                          size: 40,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Select Pokemontypes section
          const Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: SelectPokemontypesSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
