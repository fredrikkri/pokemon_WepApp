class UserData {
  final String id;
  final String username;
  final List<String> likedPokemon;
  final List<String> dislikedPokemon;
  final List<String> chosenPokemonTypes;
  final List<String> chosenRegions;

  const UserData(
      {required this.id,
      required this.username,
      required this.likedPokemon,
      required this.dislikedPokemon,
      required this.chosenPokemonTypes,
      required this.chosenRegions});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String username,
        'likedPokemon': List<String> likedPokemon,
        'dislikedPokemon': List<String> dislikedPokemon,
        'pokemonTypes': List<String> chosenPokemonTypes,
        'chosenRegions': List<String> chosenRegions,
      } =>
        UserData(
            id: id,
            username: username,
            likedPokemon: likedPokemon,
            dislikedPokemon: dislikedPokemon,
            chosenPokemonTypes: chosenPokemonTypes,
            chosenRegions: chosenRegions),
      _ => throw const FormatException('Failed to load pokemon.'),
    };
  }
}
