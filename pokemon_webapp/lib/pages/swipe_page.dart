import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_webapp/api/chuck_norris_service.dart';
import 'package:pokemon_webapp/api/pokemon_service.dart';
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
  RandomNameService randomNameService = RandomNameService();
  ChuckNorrisService chuckNorrisservice = ChuckNorrisService();
  List<String> currentUserTypes = [];
  String currentJoke = "";
  String currentHumanName = "";
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
    // getUserTypes();
    // getHumanName();
    mapPokemonData();
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
    // PokemonData currentRandomPokemon =
    //     await pokemonService.fetchRandomPokemon();
    List<String> dislikedPokemonNames =
        await userService.fetchDislikedPokemonNames();

    PokemonData currentRandomPokemon = await pokemonService
        .fetchNotDislikedRandomPokemon(dislikedPokemonNames);

    setState(() {
      currentPokemonData = PokemonData(
        id: currentPokemonData.id,
        name: currentRandomPokemon.name,
        height: currentRandomPokemon.height,
        weight: currentRandomPokemon.weight,
        baseExperience: currentRandomPokemon.baseExperience,
        types: currentRandomPokemon.types,
        img: currentRandomPokemon.img,
      );
      getUserTypes();
      getHumanName();
      getJoke();
    });
  }

  Future<bool> isRandomPokemonDisliked(PokemonData pokemon) async {
    List<String> dislikedPokemons =
        await userService.fetchDislikedPokemonNames();
    return dislikedPokemons.contains(pokemon.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text("Pokemon Swipe"),
        centerTitle: true,
        backgroundColor: Colors.red[200],
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
                  child: currentPokemonData.id == 0
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
                          // getJoke();
                          // getHumanName();
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
                          // getJoke();
                          // getHumanName();
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
                          // getJoke();
                          // getHumanName();
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
