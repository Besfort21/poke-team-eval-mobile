import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/build_suggestion.dart';
import '../widgets/type_badge.dart';
import 'eval_results_screen.dart';

class BuildResultsScreen extends StatelessWidget {
  final BuildSuggestion suggestion;
  const BuildResultsScreen({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('SUGGESTED TEAM',
            style: AppTextStyles.pixel(9, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Suggestions ──
          Text('// SUGGESTED TEAM',
              style: AppTextStyles.pixel(7, color: AppColors.primaryBright)),
          const SizedBox(height: 12),

          ...List.generate(suggestion.team.length, (i) {
            final mon = suggestion.team[i];
            final explanation = suggestion.explanations[i];
            final isAnchor = i < suggestion.explanations
                .where((e) => e.contains('anchor'))
                .length;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  left: BorderSide(
                    color: isAnchor
                        ? AppColors.yellow
                        : AppColors.primaryDim,
                    width: 3,
                  ),
                  top: BorderSide(color: AppColors.border),
                  right: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.border),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${i + 1}. ',
                          style: AppTextStyles.pixel(7,
                              color: AppColors.textMuted)),
                      Text(mon.displayName,
                          style: AppTextStyles.mono(14,
                              color: AppColors.text)),
                      const SizedBox(width: 8),
                      ...mon.types.map((t) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: TypeBadge(type: t),
                      )),
                      const Spacer(),
                      Text('BST ${mon.bst}',
                          style: AppTextStyles.pixel(6,
                              color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    explanation.contains(': ')
                        ? explanation.split(': ').skip(1).join(': ')
                        : explanation,
                    style: AppTextStyles.mono(11,
                        color: AppColors.textDim),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),
          Divider(color: AppColors.border),
          const SizedBox(height: 16),

          // ── Full eval report ──
          ...buildReportWidgets(suggestion.evalReport),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Reuse the report widgets from EvalResultsScreen
List<Widget> buildReportWidgets(report) {
  return [
    TeamOverview(team: report.team),
    const SizedBox(height: 16),
    if (report.roles.warnings.isNotEmpty) ...[
      WarningsPanel(warnings: report.roles.warnings),
      const SizedBox(height: 16),
    ],
    RoleDistribution(distribution: report.roles.distribution),
    const SizedBox(height: 16),
    OffensiveCoverage(offensive: report.typeCoverage.offensive),
    const SizedBox(height: 16),
    DefensiveProfile(coverage: report.typeCoverage),
    const SizedBox(height: 16),
    SpeedTiers(speedTiers: report.stats.speedTiers),
  ];
}