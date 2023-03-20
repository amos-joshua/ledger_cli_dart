import '../parser/csv/csv_line.dart';
import 'import_account.dart';

class PendingImportedEntry {
  final CsvLine csvLine;
  final ImportAccount importAccount;
  String destinationAccount = '';
  PendingImportedEntry({required this.csvLine, required this.importAccount});

  @override
  String toString() => 'PendingImportedEntry(csvLine: $csvLine, importAccount: $importAccount, destinationAccount: $destinationAccount)';

  @override
  bool operator ==(Object other) => (other is PendingImportedEntry) && (other.csvLine == csvLine) && (other.importAccount == importAccount) && (other.destinationAccount == destinationAccount);

  @override
  int get hashCode => Object.hash(csvLine, importAccount, destinationAccount);
}