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
    List<String> parsedTypes = (json['types'] as List)
        .map((typeData) => typeData['type']['name'] as String)
        .toList();

    return PokemonData(
      id: json['id'] as int,
      name: json['name'] as String,
      joke: json['joke'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      baseExperience: json['base_experience'] as int,
      types: parsedTypes,
    );
  }
}
