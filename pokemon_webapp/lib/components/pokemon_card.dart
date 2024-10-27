import 'package:flutter/material.dart';

class PokemonCard extends StatefulWidget {
  final int id;
  final String humanName;
  final String name;
  final String joke;
  final int height;
  final int weight;
  final int baseExperience;
  final List<String> types;
  final String img;
  const PokemonCard(
      {super.key,
      required this.id,
      required this.humanName,
      required this.name,
      required this.joke,
      required this.height,
      required this.weight,
      required this.baseExperience,
      required this.types,
      required this.img});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Image.network(
                      widget.img,
                      fit: BoxFit.cover,
                      height: 300,
                      errorBuilder: (_, __, ___) {
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
                Text(
                  "${widget.humanName} the ${widget.name}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Height: ${widget.height}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Weight: ${widget.weight}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Base exp: ${widget.baseExperience}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Pokemon type: ${widget.types.join(', ')}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.joke,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
