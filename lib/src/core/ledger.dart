import 'entry.dart';
import 'account.dart';


// A ledger with entries and an account manager
class Ledger {
  final entries = <Entry>[];
  final accountManager = AccountManager();

  void clear() {
    entries.clear();
    accountManager.clear();
  }

  void loadFrom(Ledger otherLedger) {
    entries.addAll(otherLedger.entries);
    accountManager.accounts.addAll(otherLedger.accountManager.accounts);
  }
}