import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Vérifie si les informations d'identification par défaut existent déjà
    if (!_prefs.containsKey('username')) {
      await _prefs.setString('username', 'root');
    }

    if (!_prefs.containsKey('password')) {
      await _prefs.setString('password', 'root');
    }
  }

  static Future<void> saveCredentials(String username, String password) async {
    await _prefs.setString('username', username);
    await _prefs.setString('password', password);
  }

  static Future<Map<String, String>> getCredentials() async {
    final String username = _prefs.getString('username') ?? '';
    final String password = _prefs.getString('password') ?? '';
    return {'username': username, 'password': password};
  }
}
