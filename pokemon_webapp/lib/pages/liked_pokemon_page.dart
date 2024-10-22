import 'package:flutter/material.dart';

class LikedPokemonPage extends StatefulWidget {
  const LikedPokemonPage({super.key});

  @override
  State<LikedPokemonPage> createState() => _LikedPokemonPageState();
}

class _LikedPokemonPageState extends State<LikedPokemonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LikedPokemon'),
      ),
      body: const Center(
        child: Text(
          'LikedPokemon',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
