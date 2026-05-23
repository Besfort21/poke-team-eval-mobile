import 'package:flutter/material.dart';
import '../theme.dart';
import 'evaluate_screen.dart';
import 'build_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  @override
  void initState() {
    super.initState();
    ApiService.warmUp();
  }


  static const List<_GenInfo> _gens = [
    _GenInfo(1, 'GEN I',   'Kanto'),
    _GenInfo(2, 'GEN II',  'Johto'),
    _GenInfo(3, 'GEN III', 'Hoenn'),
    _GenInfo(4, 'GEN IV',  'Sinnoh'),
    _GenInfo(5, 'GEN V',   'Unova'),
    _GenInfo(6, 'GEN VI',  'Kalos'),
    _GenInfo(7, 'GEN VII', 'Alola'),
    _GenInfo(8, 'GEN VIII','Galar'),
    _GenInfo(9, 'GEN IX',  'Paldea'),
  ];

  void _onGenSelected(int gen) {
    if (_currentTab == 0) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => EvaluateScreen(generation: gen),
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => BuildScreen(generation: gen),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('POKÉTEAM EVAL',
                      style: AppTextStyles.pixel(11, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('type coverage · role analysis · builder',
                      style: AppTextStyles.mono(11,
                          color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),

            // ── Tabs ──
            Container(
              color: AppColors.surface,
              child: Row(
                children: [
                  _TabButton(
                    label: '▶ EVALUATE',
                    active: _currentTab == 0,
                    onTap: () => setState(() => _currentTab = 0),
                  ),
                  _TabButton(
                    label: '◈ BUILD',
                    active: _currentTab == 1,
                    onTap: () => setState(() => _currentTab = 1),
                  ),
                ],
              ),
            ),

            // ── Gen label ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('// SELECT GENERATION',
                    style: AppTextStyles.pixel(7,
                        color: AppColors.primaryBright)),
              ),
            ),

            // ── Gen grid ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: _gens.map((g) => _GenCard(
                    gen: g,
                    onTap: () => _onGenSelected(g.id),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Supporting widgets ───────────────────────────────────────────────

class _GenInfo {
  final int id;
  final String label;
  final String region;
  const _GenInfo(this.id, this.label, this.region);
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AppColors.primaryBright : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.pixel(8,
              color: active ? AppColors.primaryBright : AppColors.textDim),
        ),
      ),
    );
  }
}

class _GenCard extends StatelessWidget {
  final _GenInfo gen;
  final VoidCallback onTap;

  const _GenCard({required this.gen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(gen.label,
                style: AppTextStyles.pixel(7,
                    color: AppColors.primaryBright)),
            const SizedBox(height: 6),
            Text(gen.region,
                style: AppTextStyles.mono(10,
                    color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}