import 'import_account.dart';

class LedgerPreferences {
  static final empty = LedgerPreferences(defaultLedgerFile: '', defaultCsvImportDirectory: '', importAccounts: []);

  final String defaultLedgerFile;
  final String defaultCsvImportDirectory;
  final List<ImportAccount> importAccounts;

  LedgerPreferences({required this.defaultLedgerFile, required this.defaultCsvImportDirectory, required this.importAccounts});
}