class PokemonResult {
  final String name;
  final List<String> types;
  final int bst;

  PokemonResult({
    required this.name,
    required this.types,
    required this.bst,
  });

  factory PokemonResult.fromJson(Map<String, dynamic> json) {
    return PokemonResult(
      name: json['name'] as String,
      types: List<String>.from(json['types']),
      bst: json['bst'] as int,
    );
  }
}