import 'package:ledger_cli/ledger_cli.dart';

void main() async {
  final ledgerFileLoader = LedgerLoader();
  try {
    final source = LedgerSource.forFile('/path/to/ledger/file');
    final ledger = await ledgerFileLoader.load(
        source, onApplyFailure: (edit, exc, stackTrace) {
      print("ERROR: could not apply $edit: $exc\n$stackTrace");
    });
    print("Found a ledger with entries: ${ledger.entries} and accounts: ${ledger
        .accountManager.accounts.values}");
  }
  catch (exc, stackTrace) {
    print("Error loading ledger: $exc\n$stackTrace");
  }
}