import 'pokemon.dart';
import 'eval_report.dart';

class BuildSuggestion {
  final List<PokemonResult> team;
  final List<String> explanations;
  final EvalReport evalReport;

  BuildSuggestion({
    required this.team,
    required this.explanations,
    required this.evalReport,
  });

  factory BuildSuggestion.fromJson(Map<String, dynamic> json) {
    return BuildSuggestion(
      team: (json['team'] as List)
          .map((m) => PokemonResult.fromJson(m))
          .toList(),
      explanations: List<String>.from(json['explanations']),
      evalReport: EvalReport.fromJson(json['eval_report']),
    );
  }
}