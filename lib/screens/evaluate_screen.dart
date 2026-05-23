import 'package:flutter/material.dart';
import '../theme.dart';

class EvaluateScreen extends StatelessWidget {
  final int generation;
  const EvaluateScreen({super.key, required this.generation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('GEN $generation — EVALUATE',
            style: AppTextStyles.pixel(9, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('Evaluate screen coming soon',
            style: AppTextStyles.mono(14, color: AppColors.textDim)),
      ),
    );
  }
}