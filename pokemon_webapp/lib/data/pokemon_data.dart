class PokemonData {
  final int id;
  final String name;
  final int height;
  final int weight;
  final int baseExperience;
  final List<String> types;
  final String img;

  const PokemonData(
      {required this.id,
      required this.name,
      required this.height,
      required this.weight,
      required this.baseExperience,
      required this.types,
      required this.img});

  factory PokemonData.fromJson(Map<String, dynamic> json) {
    List<String> parsedTypes = (json['types'] as List)
        .map((typeData) => typeData['type']['name'] as String)
        .toList();

    String parsedImg = json['sprites']['front_default'] as String;

    return PokemonData(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int? ?? 0,
      weight: json['weight'] as int? ?? 0,
      baseExperience: json['base_experience'] as int? ?? 0,
      types: parsedTypes,
      img: parsedImg,
    );
  }
}
