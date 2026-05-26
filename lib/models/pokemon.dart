class PokemonResult {
  final String name;
  final String displayName;
  final List<String> types;
  final int bst;

  PokemonResult({
    required this.name,
    required this.displayName,
    required this.types,
    required this.bst,
  });

  factory PokemonResult.fromJson(Map<String, dynamic> json) {
    return PokemonResult(
      name: json['name'] as String,
      displayName: json['display_name'] as String? ?? json['name'] as String,
      types: List<String>.from(json['types']),
      bst: json['bst'] as int,
    );
  }
}