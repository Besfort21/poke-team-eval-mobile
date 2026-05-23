import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/eval_report.dart';
import '../widgets/type_badge.dart';

class EvalResultsScreen extends StatelessWidget {
  final EvalReport report;
  const EvalResultsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('RESULTS — GEN ${report.generation}',
            style: AppTextStyles.pixel(9, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TeamOverview(team: report.team),
          const SizedBox(height: 16),
          if (report.roles.warnings.isNotEmpty) ...[
            _WarningsPanel(warnings: report.roles.warnings),
            const SizedBox(height: 16),
          ],
          _RoleDistribution(distribution: report.roles.distribution),
          const SizedBox(height: 16),
          _OffensiveCoverage(offensive: report.typeCoverage.offensive),
          const SizedBox(height: 16),
          _DefensiveProfile(coverage: report.typeCoverage),
          const SizedBox(height: 16),
          _SpeedTiers(speedTiers: report.stats.speedTiers),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Panel wrapper ────────────────────────────────────────────────────
class _Panel extends StatelessWidget {
  final String title;
  final Widget child;

  const _Panel({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.pixel(7, color: AppColors.primaryBright)),
          const SizedBox(height: 4),
          Divider(color: AppColors.border, height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Team Overview ────────────────────────────────────────────────────
class _TeamOverview extends StatelessWidget {
  final List<TeamMember> team;
  const _TeamOverview({required this.team});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: '// TEAM OVERVIEW',
      child: Column(
        children: team.map((m) => _MemberCard(member: m)).toList(),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final TeamMember member;
  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + types + BST
          Row(
            children: [
              Text(member.name,
                  style: AppTextStyles.mono(14, color: AppColors.text)),
              const SizedBox(width: 8),
              ...member.types.map((t) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: TypeBadge(type: t),
              )),
              const Spacer(),
              Text('${member.bst}',
                  style: AppTextStyles.pixel(7,
                      color: AppColors.primaryBright)),
            ],
          ),
          const SizedBox(height: 6),
          // Role
          Text(member.role,
              style: AppTextStyles.mono(11, color: AppColors.textDim)),
          // Key moves
          if (member.keyMoves.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: member.keyMoves.map((mv) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.forType(mv.type).withOpacity(0.2),
                  border: Border.all(
                      color: AppColors.forType(mv.type).withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  '${mv.name.replaceAll('-', ' ')} (${mv.power})',
                  style: AppTextStyles.mono(10,
                      color: AppColors.forType(mv.type)),
                ),
              )).toList(),
            ),
          ],
          const SizedBox(height: 8),
          // Stat bars
          ...['hp','attack','defense','sp_atk','sp_def','speed']
              .map((s) => _StatBar(
            label: s.toUpperCase().replaceAll('_', ' '),
            value: member.stats[s] ?? 0,
          )),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  const _StatBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(label,
                style: AppTextStyles.pixel(5, color: AppColors.textMuted)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: value / 255,
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryDim),
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 28,
            child: Text('$value',
                style: AppTextStyles.mono(10, color: AppColors.textDim),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

// ── Warnings ─────────────────────────────────────────────────────────
class _WarningsPanel extends StatelessWidget {
  final List<String> warnings;
  const _WarningsPanel({required this.warnings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: warnings.map((w) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0A00),
          border: Border(left: BorderSide(
              color: AppColors.warning, width: 3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text('⚠ $w',
            style: AppTextStyles.mono(11,
                color: AppColors.warningText)),
      )).toList(),
    );
  }
}

// ── Role Distribution ─────────────────────────────────────────────────
class _RoleDistribution extends StatelessWidget {
  final Map<String, int> distribution;
  const _RoleDistribution({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final max = distribution.values.fold(0, (a, b) => a > b ? a : b);
    return _Panel(
      title: '// ROLE DISTRIBUTION',
      child: Column(
        children: distribution.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 140,
                child: Text(e.key,
                    style: AppTextStyles.mono(11,
                        color: AppColors.textDim)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: max > 0 ? e.value / max : 0,
                    backgroundColor: AppColors.surface2,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryDim),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${e.value}',
                  style: AppTextStyles.pixel(7,
                      color: AppColors.primaryBright)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

// ── Offensive Coverage ────────────────────────────────────────────────
class _OffensiveCoverage extends StatelessWidget {
  final Map<String, double> offensive;
  const _OffensiveCoverage({required this.offensive});

  Color _cellColor(double eff) {
    if (eff == 0)    return const Color(0xFF1A1A2E);
    if (eff <= 0.5)  return const Color(0xFF1A2A1A);
    if (eff == 1)    return const Color(0xFF1E1E1E);
    if (eff == 2)    return const Color(0xFF2A1A00);
    return const Color(0xFF2A0000);
  }

  Color _textColor(double eff) {
    if (eff == 0)    return const Color(0xFF666666);
    if (eff <= 0.5)  return const Color(0xFF6A9A6A);
    if (eff == 1)    return const Color(0xFF888888);
    if (eff == 2)    return const Color(0xFFFFAA44);
    return AppColors.primaryBright;
  }

  String _effLabel(double eff) {
    if (eff == 0)    return '0×';
    if (eff == 0.25) return '¼×';
    if (eff == 0.5)  return '½×';
    if (eff == 1)    return '1×';
    if (eff == 2)    return '2×';
    return '4×';
  }

  @override
  Widget build(BuildContext context) {
    final types = offensive.keys.toList();
    return _Panel(
      title: '// OFFENSIVE COVERAGE',
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.6,
        children: types.map((t) {
          final eff = offensive[t] ?? 0;
          return Container(
            decoration: BoxDecoration(
              color: _cellColor(eff),
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_effLabel(eff),
                    style: AppTextStyles.mono(12,
                        color: _textColor(eff))),
                const SizedBox(height: 2),
                Text(t,
                    style: AppTextStyles.pixel(5,
                        color: _textColor(eff))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Defensive Profile ─────────────────────────────────────────────────
class _DefensiveProfile extends StatelessWidget {
  final TypeCoverage coverage;
  const _DefensiveProfile({required this.coverage});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: '// DEFENSIVE PROFILE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (coverage.dangerTypes.isNotEmpty) ...[
            _tagSection('DANGER (2+ members weak)',
                coverage.dangerTypes, const Color(0xFF2A0000),
                AppColors.primaryBright),
            const SizedBox(height: 10),
          ],
          if (coverage.weakTo.isNotEmpty) ...[
            _tagSection('WEAK TO', coverage.weakTo,
                const Color(0xFF1A1000), const Color(0xFFCCAA00)),
            const SizedBox(height: 10),
          ],
          if (coverage.immunities.isNotEmpty) ...[
            _tagSection('IMMUNITIES', coverage.immunities,
                const Color(0xFF001A2A), const Color(0xFF44AAFF)),
            const SizedBox(height: 10),
          ],
          if (coverage.strongAgainst.isNotEmpty)
            _tagSection('RESISTED BY', coverage.strongAgainst,
                const Color(0xFF001A00), const Color(0xFF44CC66)),
        ],
      ),
    );
  }

  Widget _tagSection(String label, List<String> types,
      Color bg, Color fg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.pixel(6, color: AppColors.textMuted)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: types.map((t) => Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: fg),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(t.toUpperCase(),
                style: AppTextStyles.pixel(6, color: fg)),
          )).toList(),
        ),
      ],
    );
  }
}

// ── Speed Tiers ───────────────────────────────────────────────────────
class _SpeedTiers extends StatelessWidget {
  final List<List<dynamic>> speedTiers;
  const _SpeedTiers({required this.speedTiers});

  @override
  Widget build(BuildContext context) {
    final maxSpeed = speedTiers.isNotEmpty
        ? (speedTiers.first[1] as num).toDouble()
        : 1.0;

    return _Panel(
      title: '// SPEED TIERS',
      child: Column(
        children: speedTiers.map((tier) {
          final name = tier[0] as String;
          final speed = (tier[1] as num).toDouble();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(name,
                      style: AppTextStyles.mono(11,
                          color: AppColors.text),
                      overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: speed / maxSpeed,
                      backgroundColor: AppColors.surface2,
                      valueColor: AlwaysStoppedAnimation(
                          AppColors.primaryBright),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 28,
                  child: Text('${speed.toInt()}',
                      style: AppTextStyles.pixel(7,
                          color: AppColors.textDim),
                      textAlign: TextAlign.right),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}