class KeyMove {
  final String name;
  final String type;
  final String damageClass;
  final int power;

  KeyMove({
    required this.name,
    required this.type,
    required this.damageClass,
    required this.power,
  });

  factory KeyMove.fromJson(Map<String, dynamic> json) {
    return KeyMove(
      name: json['name'] as String,
      type: json['type'] as String,
      damageClass: json['damage_class'] as String,
      power: json['power'] as int,
    );
  }
}


class TeamMember {
  final String name;
  final String displayName;
  final List<String> types;
  final String role;
  final int bst;
  final Map<String, int> stats;
  final List<KeyMove> keyMoves;

  TeamMember({
    required this.name,
    required this.displayName,
    required this.types,
    required this.role,
    required this.bst,
    required this.stats,
    required this.keyMoves,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    final rawStats = Map<String, dynamic>.from(json['stats']);
    final stats = rawStats.map((k, v) => MapEntry(k, v as int));
    final keyMoves = (json['key_moves'] as List)
        .map((m) => KeyMove.fromJson(m))
        .toList();
    return TeamMember(
      name: json['name'] as String,
      displayName: json['display_name'] as String? ?? json['name'] as String,
      types: List<String>.from(json['types']),
      role: json['role'] as String,
      bst: json['bst'] as int,
      stats: stats,
      keyMoves: keyMoves,
    );
  }
}


class TypeCoverage {
  final Map<String, double> offensive;
  final List<String> strongAgainst;
  final List<String> weakTo;
  final List<String> dangerTypes;
  final List<String> immunities;

  TypeCoverage({
    required this.offensive,
    required this.strongAgainst,
    required this.weakTo,
    required this.dangerTypes,
    required this.immunities,
  });

  factory TypeCoverage.fromJson(Map<String, dynamic> json) {
    final rawOff = Map<String, dynamic>.from(json['offensive']);
    final offensive = rawOff.map((k, v) => MapEntry(k, (v as num).toDouble()));
    return TypeCoverage(
      offensive: offensive,
      strongAgainst: List<String>.from(json['strong_against']),
      weakTo: List<String>.from(json['weak_to']),
      dangerTypes: List<String>.from(json['danger_types']),
      immunities: List<String>.from(json['immunities']),
    );
  }
}


class RoleReport {
  final Map<String, String> roles;
  final Map<String, int> distribution;
  final List<String> warnings;

  RoleReport({
    required this.roles,
    required this.distribution,
    required this.warnings,
  });

  factory RoleReport.fromJson(Map<String, dynamic> json) {
    return RoleReport(
      roles: Map<String, String>.from(json['roles']),
      distribution: Map<String, dynamic>.from(json['distribution'])
          .map((k, v) => MapEntry(k, v as int)),
      warnings: List<String>.from(json['warnings']),
    );
  }
}


class StatSummary {
  final Map<String, double> averages;
  final List<List<dynamic>> speedTiers;

  StatSummary({
    required this.averages,
    required this.speedTiers,
  });

  factory StatSummary.fromJson(Map<String, dynamic> json) {
    final rawAvg = Map<String, dynamic>.from(json['averages']);
    final averages = rawAvg.map((k, v) => MapEntry(k, (v as num).toDouble()));
    final speedTiers = (json['speed_tiers'] as List)
        .map((e) => List<dynamic>.from(e))
        .toList();
    return StatSummary(
      averages: averages,
      speedTiers: speedTiers,
    );
  }
}


class EvalReport {
  final int generation;
  final List<TeamMember> team;
  final TypeCoverage typeCoverage;
  final RoleReport roles;
  final StatSummary stats;

  EvalReport({
    required this.generation,
    required this.team,
    required this.typeCoverage,
    required this.roles,
    required this.stats,
  });

  factory EvalReport.fromJson(Map<String, dynamic> json) {
    return EvalReport(
      generation: json['generation'] as int,
      team: (json['team'] as List)
          .map((m) => TeamMember.fromJson(m))
          .toList(),
      typeCoverage: TypeCoverage.fromJson(json['type_coverage']),
      roles: RoleReport.fromJson(json['roles']),
      stats: StatSummary.fromJson(json['stats']),
    );
  }
}