import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../widgets/type_badge.dart';
import '../widgets/pokemon_slot.dart';
import 'eval_results_screen.dart';
import 'build_results_screen.dart';

class BuildScreen extends StatefulWidget {
  final int generation;
  const BuildScreen({super.key, required this.generation});

  @override
  State<BuildScreen> createState() => _BuildScreenState();
}

class _BuildScreenState extends State<BuildScreen> {
  final List<PokemonResult> _anchors = [];
  final TextEditingController _searchCtrl = TextEditingController();
  List<PokemonResult> _suggestions = [];
  bool _searching = false;
  bool _loading = false;
  String? _error;
  int _minBst = 400;

  DateTime _lastSearch = DateTime.now();

  void _onSearchChanged(String query) async {
    if (query.length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    final now = DateTime.now();
    _lastSearch = now;
    await Future.delayed(const Duration(milliseconds: 250));
    if (_lastSearch != now) return;

    setState(() => _searching = true);
    final results = await ApiService.searchPokemon(query, widget.generation);
    if (mounted) setState(() { _suggestions = results; _searching = false; });
  }

  void _addAnchor(PokemonResult mon) {
    if (_anchors.length >= 5) return;
    if (_anchors.any((m) => m.name == mon.name)) return;
    setState(() {
      _anchors.add(mon);
      _suggestions = [];
      _searchCtrl.clear();
    });
  }

  void _removeAnchor(int index) {
    setState(() => _anchors.removeAt(index));
  }

  Future<void> _build() async {
    setState(() { _loading = true; _error = null; });
    try {
      final suggestion = await ApiService.buildTeam(
        _anchors.map((m) => m.name).toList(),
        widget.generation,
        _minBst,
      );
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => BuildResultsScreen(suggestion: suggestion),
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
        title: Text('GEN ${widget.generation} — BUILD',
            style: AppTextStyles.pixel(9, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('// ANCHOR POKÉMON (1–5)',
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
                  hintText: 'type an anchor pokémon...',
                  hintStyle: AppTextStyles.mono(13, color: AppColors.textMuted),
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

            // ── Autocomplete ──
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
                    onTap: () => _addAnchor(mon),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Text(mon.name,
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

            // ── Anchor slots ──
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.3,
              children: List.generate(5, (i) => PokemonSlot(
                index: i,
                pokemon: i < _anchors.length ? _anchors[i] : null,
                onRemove: i < _anchors.length ? () => _removeAnchor(i) : null,
              )),
            ),

            const SizedBox(height: 20),

            // ── BST Slider ──
            Text('// MIN BST',
                style: AppTextStyles.pixel(7, color: AppColors.primaryBright)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primaryBright,
                      inactiveTrackColor: AppColors.surface,
                      thumbColor: AppColors.primaryBright,
                      overlayColor: AppColors.primary.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _minBst.toDouble(),
                      min: 200,
                      max: 600,
                      divisions: 16,
                      onChanged: (v) => setState(() => _minBst = v.toInt()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$_minBst',
                    style: AppTextStyles.pixel(9,
                        color: AppColors.primaryBright)),
              ],
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

            // ── Build button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _anchors.isEmpty || _loading ? null : _build,
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
                    : Text('BUILD TEAM',
                    style: AppTextStyles.pixel(9, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}