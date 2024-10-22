class PokemonDataShort {
  final String name;
  final String url;

  PokemonDataShort({required this.name, required this.url});

  // Factory method to create a PokemonData object from JSON
  factory PokemonDataShort.fromJson(Map<String, dynamic> json) {
    return PokemonDataShort(
      name: json['name'],
      url: json['url'],
    );
  }
}
