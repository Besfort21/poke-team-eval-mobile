import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/eval_report.dart';

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
      body: Center(
        child: Text(
          'Team of ${report.team.length} — results coming soon',
          style: AppTextStyles.mono(13, color: AppColors.textDim),
        ),
      ),
    );
  }
}