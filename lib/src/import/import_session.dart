import 'dart:io';
import 'pending_imported_entry.dart';
import '../parser/csv/csv_line.dart';
import '../core/core.dart';
import '../serializer/pending_import_serializer.dart';

class ImportSession {
  static const pendingImportSerializer = PendingImportSerializer();

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

  String summary() {
    String quantifiedEntries(int quantity) => quantity == 1 ? 'entry' : 'entries';
    final accounts = <String, int>{};
    for (final entry in pendingEntries) {
      accounts.update(entry.importAccount.sourceAccount, (count) => count + 1, ifAbsent: () => 1);
    }

    final hasMultipleAccounts = (accounts.keys.length > 1);
    final entryCountSummary = hasMultipleAccounts ? '${pendingEntries.length} ${quantifiedEntries(pendingEntries.length)}:\n\n' : '';
    final accountsSummary = [for (final entry in accounts.entries) "${hasMultipleAccounts ? '  ' : ''}${entry.value} ${quantifiedEntries(entry.value)} for ${entry.key}"].join("\n");
    final numUnclassified = pendingEntries.where((entry) => entry.destinationAccount.isEmpty).length;
    final unclassifiedSummary = numUnclassified == 0 ? '' : '\n\nOf which $numUnclassified unclassified';
    return "$entryCountSummary$accountsSummary$unclassifiedSummary";
  }

  Future<void> saveTo(String ledgerFile) async {
    final serializedImports = pendingImportSerializer.serialize(pendingEntries);
    final today = DateTime.now();
    final header = '## -- BEGIN IMPORT on ${today.year}-${today.month}-${today.day} --';
    final footer = '## -- END IMPORT on ${today.year}-${today.month}-${today.day} --';
    final decoratedData = '\n$header\n\n$serializedImports\n\n$footer\n';
    final ledger = File(ledgerFile);
    return ledger.writeAsString(decoratedData, mode: FileMode.writeOnlyAppend).then((file){});
  }

  Iterable<Entry> pendingEntriesAsEntries() {
    return pendingEntries.where((entry) => !entry.markedForDeletion).map((pendingEntry) => pendingEntry.asEntry());
  }
}