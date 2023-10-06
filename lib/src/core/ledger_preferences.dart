import 'import_account.dart';
import 'csv_format.dart';

class LedgerPreferences {
  static final empty = LedgerPreferences(defaultLedgerFile: '', defaultCsvImportDirectory: '', importAccounts: [], csvFormats: []);

  final String defaultLedgerFile;
  final String defaultCsvImportDirectory;
  final List<ImportAccount> importAccounts;
  final List<CsvFormat> csvFormats;

  LedgerPreferences({
    required this.defaultLedgerFile,
    required this.defaultCsvImportDirectory,
    required this.importAccounts,
    required this.csvFormats
  });
}