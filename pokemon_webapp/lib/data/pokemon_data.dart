class PokemonData {
  final int id;
  final String name;
  final String joke;
  final int height;
  final int weight;
  final int baseExperience;
  final List<String> types;

  const PokemonData({
    required this.id,
    required this.name,
    required this.joke,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.types,
  });

  factory PokemonData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'joke': String joke,
        'height': int height,
        'weight': int weight,
        'baseExperience': int baseExperience,
        'types': List<String> types,
      } =>
        PokemonData(
          id: id,
          name: name,
          joke: joke,
          height: height,
          weight: weight,
          baseExperience: baseExperience,
          types: types,
        ),
      _ => throw const FormatException('Failed to load pokemon.'),
    };
  }
}
