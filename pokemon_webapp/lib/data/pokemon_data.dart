class PokemonData {
  final int id;
  final String name;
  final String description;
  final String height;
  final String weight;
  final String baseExperience;
  final List<String> types;

  const PokemonData({
    required this.id,
    required this.name,
    required this.description,
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
        'description': String description,
        'height': String height,
        'weight': String weight,
        'baseExperience': String baseExperience,
        'types': List<String> types,
      } =>
        PokemonData(
          id: id,
          name: name,
          description: description,
          height: height,
          weight: weight,
          baseExperience: baseExperience,
          types: types,
        ),
      _ => throw const FormatException('Failed to load pokemon.'),
    };
  }
}
