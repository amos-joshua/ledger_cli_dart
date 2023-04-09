
import '../import/pending_imported_entry.dart';
import '../core/formatters.dart';

class PendingImportSerializer {
  static const dateFormatter = LedgerDateFormatter();

  String serializePendingEntry(PendingImportedEntry pendingEntry) {
    final padLength = 60;
    final date = dateFormatter.format(pendingEntry.csvLine.date);
    final source = pendingEntry.importAccount.sourceAccount;
    final destination = pendingEntry.destinationAccount;
    final sourceAmount = "${-1*pendingEntry.csvLine.amount} ${pendingEntry.importAccount.currency}";
    final destinationAmount = "${pendingEntry.csvLine.amount} ${pendingEntry.importAccount.currency}";

    return """$date * ${pendingEntry.csvLine.description}
    $source ${sourceAmount.padLeft(padLength - source.length, ' ')}
    $destination ${destinationAmount.padLeft(padLength - destination.length, ' ')}""";
  }

  String serialize(List<PendingImportedEntry> pendingEntries) => pendingEntries.map((pendingEntry) => serializePendingEntry(pendingEntry)).join("\n\n");
}