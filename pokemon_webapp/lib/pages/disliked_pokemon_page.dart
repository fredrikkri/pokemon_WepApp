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
        title: Text('Second Page'),
      ),
      body: const Center(
        child: Text(
          'This is the second page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
