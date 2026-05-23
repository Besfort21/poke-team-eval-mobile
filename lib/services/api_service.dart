import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../models/eval_report.dart';
import '../models/build_suggestion.dart';

class ApiService {
  static const String _base = 'https://poke-team-eval.onrender.com';

  // Wake the server silently on app launch
  static Future<void> warmUp() async {
    try {
      await http.get(Uri.parse('$_base/api/generations'))
          .timeout(const Duration(seconds: 10));
    } catch (_) {}
  }

  // Autocomplete search
  static Future<List<PokemonResult>> searchPokemon(
      String query, int gen) async {
    if (query.length < 2) return [];
    final uri = Uri.parse(
        '$_base/api/pokemon/search?q=${Uri.encodeComponent(query)}&gen=$gen&limit=8');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body);
    return (data['results'] as List)
        .map((r) => PokemonResult.fromJson(r))
        .toList();
  }

  // Evaluate a team
  static Future<EvalReport> evaluateTeam(
      List<String> names, int gen) async {
    final res = await http
        .post(
      Uri.parse('$_base/api/evaluate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'generation': gen, 'pokemon': names}),
    )
        .timeout(const Duration(seconds: 30));

    if (res.statusCode != 200) {
      final err = jsonDecode(res.body);
      throw Exception(err['detail'] ?? 'Evaluation failed');
    }
    return EvalReport.fromJson(jsonDecode(res.body));
  }

  // Build a team
  static Future<BuildSuggestion> buildTeam(
      List<String> anchors, int gen, int minBst) async {
    final res = await http
        .post(
      Uri.parse('$_base/api/build'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'generation': gen,
        'anchors': anchors,
        'min_bst': minBst,
      }),
    )
        .timeout(const Duration(seconds: 60));

    if (res.statusCode != 200) {
      final err = jsonDecode(res.body);
      throw Exception(err['detail'] ?? 'Build failed');
    }
    return BuildSuggestion.fromJson(jsonDecode(res.body));
  }
}