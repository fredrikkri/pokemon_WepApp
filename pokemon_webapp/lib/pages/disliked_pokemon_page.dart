import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_webapp/components/pokemon_card.dart';
import 'package:pokemon_webapp/service/user_service.dart';

class DislikedPokemonPage extends StatefulWidget {
  const DislikedPokemonPage({super.key});

  @override
  State<DislikedPokemonPage> createState() => _DislikedPokemonPageState();
}

class _DislikedPokemonPageState extends State<DislikedPokemonPage> {
  List<Map<String, dynamic>> currentDisikedPokemon = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDisikedPokemon();
  }

  Future<void> getDisikedPokemon() async {
    UserService userService = UserService();
    List<Map<String, dynamic>> dislikedPokemonData =
        await userService.fetchDislikedPokemons(currentUserId);

    setState(() {
      currentDisikedPokemon = dislikedPokemonData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disliked Pokemon'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentDisikedPokemon.isEmpty
              ? const Center(child: Text('No disliked Pokemon found'))
              : ListView.builder(
                  itemCount: currentDisikedPokemon.length,
                  itemBuilder: (context, index) {
                    var pokemon = currentDisikedPokemon[index];
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
