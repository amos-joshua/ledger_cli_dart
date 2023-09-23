import 'dart:io';
import '../core/core.dart';
import 'preferences_parser.dart';

class LedgerPreferencesLoader {
  static const parser = LedgerPreferencesParser();

  const LedgerPreferencesLoader();

  Future<LedgerPreferences> loadFromPath(String path) async {
    final preferencesFile = File(path);
    final cwd = Directory.current.absolute;
    if (!await preferencesFile.exists()) throw Exception('Ledger preferences file "$path" does not exist (cwd: [$cwd])');
    final preferencesData = await preferencesFile.readAsString();
    final loadedPreferences = parser.parse(preferencesData);
    return loadedPreferences;
  }
}