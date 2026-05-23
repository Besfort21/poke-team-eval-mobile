import 'package:flutter/material.dart';
import '../theme.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  final double fontSize;

  const TypeBadge({super.key, required this.type, this.fontSize = 7});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forType(type);
    final isLight = color.computeLuminance() > 0.4;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        type.toUpperCase(),
        style: AppTextStyles.pixel(
          fontSize,
          color: isLight ? Colors.black87 : Colors.white,
        ),
      ),
    );
  }
}