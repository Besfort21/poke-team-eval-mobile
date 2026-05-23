import 'package:flutter/material.dart';
import '../theme.dart';

class BuildScreen extends StatelessWidget {
  final int generation;
  const BuildScreen({super.key, required this.generation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('GEN $generation — BUILD',
            style: AppTextStyles.pixel(9, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('Build screen coming soon',
            style: AppTextStyles.mono(14, color: AppColors.textDim)),
      ),
    );
  }
}