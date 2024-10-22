import 'package:flutter/material.dart';

class DislikedPokemonPage extends StatefulWidget {
  const DislikedPokemonPage({super.key});

  @override
  State<DislikedPokemonPage> createState() => _DislikedPokemonPageState();
}

class _DislikedPokemonPageState extends State<DislikedPokemonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DislikedPokemon'),
      ),
      body: const Center(
        child: Text(
          'DislikedPokemon',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
