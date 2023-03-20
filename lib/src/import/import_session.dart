import 'pending_imported_entry.dart';
import '../parser/csv/csv_line.dart';
import '../parser/csv/list_to_csv_line_transformer.dart';
import 'import_account.dart';

class ImportSession {
  final List<PendingImportedEntry> pendingEntries = [];

  Future<void> loadCsvLines(Stream<CsvLine> csvLines, {required ImportAccount importAccount}) async {
    await for (final csvLine in csvLines) {
      pendingEntries.add(PendingImportedEntry(csvLine: csvLine, importAccount: importAccount));
    }
    pendingEntries.sort((line1, line2) => line1.csvLine.date.compareTo(line2.csvLine.date));
  }
}