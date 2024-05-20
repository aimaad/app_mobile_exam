import 'package:flutter/material.dart';
import 'bouhnef_imadeddine/screens/login_screen.dart';
import 'bouhnef_imadeddine/screens/game_screen.dart';
import 'bouhnef_imadeddine/utils/theme.dart';

import 'bouhnef_imadeddine/services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ajout nécessaire pour garantir l'initialisation des préférences avant le démarrage de l'application
  await PreferencesService.init(); // Initialisation des préférences
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruine de Joueur',
      theme: appTheme,
      home: LoginScreen(),
      routes: {
        '/game': (context) => GameScreen(),
      },
    );
  }
}
