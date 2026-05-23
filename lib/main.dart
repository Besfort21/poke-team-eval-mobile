import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const PokeTeamEvalApp());
}

class PokeTeamEvalApp extends StatelessWidget {
  const PokeTeamEvalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéTeam Eval',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const PlaceholderHome(),
    );
  }
}

class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'POKÉTEAM EVAL',
          style: AppTextStyles.pixel(14, color: AppColors.primaryBright),
        ),
      ),
    );
  }
}