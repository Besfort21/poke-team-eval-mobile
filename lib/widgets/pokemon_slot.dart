import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/pokemon.dart';
import 'type_badge.dart';

class PokemonSlot extends StatelessWidget {
  final int index;
  final PokemonResult? pokemon;
  final VoidCallback? onRemove;

  const PokemonSlot({
    super.key,
    required this.index,
    this.pokemon,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final filled = pokemon != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: filled ? AppColors.primaryDim : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: filled ? _FilledSlot(pokemon: pokemon!, onRemove: onRemove)
          : _EmptySlot(index: index),
    );
  }
}

class _FilledSlot extends StatelessWidget {
  final PokemonResult pokemon;
  final VoidCallback? onRemove;

  const _FilledSlot({required this.pokemon, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                pokemon.displayName,
                style: AppTextStyles.mono(11, color: AppColors.text),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Text('✕',
                    style: AppTextStyles.mono(11,
                        color: AppColors.textMuted)),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: pokemon.types
              .map((t) => TypeBadge(type: t))
              .toList(),
        ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final int index;
  const _EmptySlot({required this.index});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'SLOT ${index + 1}',
        style: AppTextStyles.pixel(6, color: AppColors.textMuted),
      ),
    );
  }
}