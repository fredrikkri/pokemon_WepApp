import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_webapp/components/pokemon_card.dart';
import 'package:pokemon_webapp/service/user_service.dart';

class LikedPokemonPage extends StatefulWidget {
  const LikedPokemonPage({super.key});

  @override
  State<LikedPokemonPage> createState() => _LikedPokemonPageState();
}

class _LikedPokemonPageState extends State<LikedPokemonPage> {
  List<Map<String, dynamic>> currentLikedPokemon = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLikedPokemon();
  }

  Future<void> getLikedPokemon() async {
    UserService userService = UserService();
    List<Map<String, dynamic>> likedPokemonData =
        await userService.fetchLikedPokemons(currentUserId);

    setState(() {
      currentLikedPokemon = likedPokemonData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Pokemon'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentLikedPokemon.isEmpty
              ? const Center(child: Text('No disliked Pokemon found'))
              : ListView.builder(
                  itemCount: currentLikedPokemon.length,
                  itemBuilder: (context, index) {
                    var pokemon = currentLikedPokemon[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PokemonCard(
                        id: pokemon['id'] ?? 0,
                        humanName: pokemon['humanName'] ?? 'Unknown Name',
                        name: pokemon['name'] ?? 'Unknown Pokemon',
                        joke: pokemon['joke'] ?? 'No joke available',
                        height: pokemon['height'] ?? 0,
                        weight: pokemon['weight'] ?? 0,
                        baseExperience: pokemon['baseExperience'] ?? 0,
                        types: List<String>.from(pokemon['types'] ?? []),
                        img:
                            pokemon['img'] ?? 'https://via.placeholder.com/150',
                      ),
                    );
                  },
                ),
    );
  }
}
