import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ApiService.warmUp();
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
      home: const HomeScreen(),
    );
  }
}