import 'pending_imported_entry.dart';
import '../parser/csv/csv_line.dart';
import '../core/account.dart';
import '../core/import_account.dart';

class ImportSession {
  final AccountManager accountManager;
  final List<PendingImportedEntry> pendingEntries = [];

  ImportSession({required this.accountManager});

  Future<void> loadCsvLines(Stream<CsvLine> csvLines, {required ImportAccount importAccount}) async {
    await for (final csvLine in csvLines) {
      final matchedAccount = accountManager.accountMatching(csvLine.description);
      final importedEntry = PendingImportedEntry(
        csvLine: csvLine,
        importAccount: importAccount,
        destinationAccount: matchedAccount?.name ?? ''
      );
      pendingEntries.add(importedEntry);
    }
    pendingEntries.sort((line1, line2) => line1.csvLine.date.compareTo(line2.csvLine.date));
  }
}