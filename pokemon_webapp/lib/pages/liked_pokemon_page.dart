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
