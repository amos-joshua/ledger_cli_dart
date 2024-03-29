import '../parser/csv/csv_line.dart';
import '../core/core.dart';

class PendingImportedEntry {
  final CsvLine csvLine;
  final ImportAccount importAccount;
  String destinationAccount;
  bool processed = false;
  bool markedForDeletion = false;
  PendingImportedEntry({required this.csvLine, required this.importAccount, this.destinationAccount = ''});

  void updateDestinationAccount(String newDestinationAccount) {
    destinationAccount = newDestinationAccount;
    processed = true;
  }

  void toggleMarkForDeletion() {
    markedForDeletion = !markedForDeletion;
  }

  @override
  String toString() => 'PendingImportedEntry(csvLine: $csvLine, importAccount: $importAccount, destinationAccount: $destinationAccount)';

  @override
  bool operator ==(Object other) => (other is PendingImportedEntry) && (other.csvLine == csvLine) && (other.importAccount == importAccount) && (other.destinationAccount == destinationAccount);

  @override
  int get hashCode => Object.hash(csvLine, importAccount, destinationAccount);

  Entry asEntry() {
    return Entry(
      code: '',
      date: csvLine.date,
      payee: csvLine.description,
      state: EntryState.cleared,
      postings: [
        Posting(
            account: destinationAccount,
            currency: importAccount.currency,
            amount: csvLine.amount
        ),
        Posting(
            account: importAccount.sourceAccount,
            currency: importAccount.currency,
            amount: -csvLine.amount
        ),
      ],
    );
  }
}