import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../widgets/type_badge.dart';
import '../widgets/pokemon_slot.dart';
import 'eval_results_screen.dart';

class EvaluateScreen extends StatefulWidget {
  final int generation;
  const EvaluateScreen({super.key, required this.generation});

  @override
  State<EvaluateScreen> createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  final List<PokemonResult> _team = [];
  final TextEditingController _searchCtrl = TextEditingController();
  List<PokemonResult> _suggestions = [];
  bool _searching = false;
  bool _loading = false;
  String? _error;

  // Debounce timer
  DateTime _lastSearch = DateTime.now();

  void _onSearchChanged(String query) async {
    if (query.length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    final now = DateTime.now();
    _lastSearch = now;
    await Future.delayed(const Duration(milliseconds: 250));
    if (_lastSearch != now) return; // debounce

    setState(() => _searching = true);
    final results = await ApiService.searchPokemon(query, widget.generation);
    if (mounted) setState(() { _suggestions = results; _searching = false; });
  }

  void _addPokemon(PokemonResult mon) {
    if (_team.length >= 6) return;
    if (_team.any((m) => m.name == mon.name)) return;
    setState(() {
      _team.add(mon);
      _suggestions = [];
      _searchCtrl.clear();
    });
  }

  void _removePokemon(int index) {
    setState(() => _team.removeAt(index));
  }

  Future<void> _analyse() async {
    setState(() { _loading = true; _error = null; });
    try {
      final report = await ApiService.evaluateTeam(
        _team.map((m) => m.name).toList(),
        widget.generation,
      );
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => EvalResultsScreen(report: report),
      ));
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('GEN ${widget.generation} — EVALUATE',
            style: AppTextStyles.pixel(9, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Section label ──
            Text('// ADD POKÉMON (UP TO 6)',
                style: AppTextStyles.pixel(7, color: AppColors.primaryBright)),
            const SizedBox(height: 12),

            // ── Search bar ──
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: AppTextStyles.mono(14, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'type a pokémon name...',
                  hintStyle: AppTextStyles.mono(13,
                      color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  suffixIcon: _searching
                      ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryBright,
                      ),
                    ),
                  )
                      : null,
                ),
                onChanged: _onSearchChanged,
              ),
            ),

            // ── Autocomplete dropdown ──
            if (_suggestions.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.primaryDim),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  children: _suggestions.map((mon) => InkWell(
                    onTap: () => _addPokemon(mon),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Text(mon.displayName,
                              style: AppTextStyles.mono(13,
                                  color: AppColors.text)),
                          const SizedBox(width: 10),
                          ...mon.types.map((t) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: TypeBadge(type: t),
                          )),
                          const Spacer(),
                          Text('BST ${mon.bst}',
                              style: AppTextStyles.mono(10,
                                  color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),

            const SizedBox(height: 16),

            // ── Team slots ──
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.3,
              children: List.generate(6, (i) => PokemonSlot(
                index: i,
                pokemon: i < _team.length ? _team[i] : null,
                onRemove: i < _team.length ? () => _removePokemon(i) : null,
              )),
            ),

            const SizedBox(height: 20),

            // ── Error ──
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0000),
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(_error!,
                    style: AppTextStyles.pixel(7,
                        color: AppColors.primaryBright)),
              ),

            // ── Analyse button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _team.isEmpty || _loading ? null : _analyse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: AppColors.primaryBright),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                  height: 16, width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white,
                  ),
                )
                    : Text('ANALYSE TEAM',
                    style: AppTextStyles.pixel(9, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}