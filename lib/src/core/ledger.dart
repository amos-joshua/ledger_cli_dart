import 'entry.dart';
import 'account.dart';

class Ledger {
  final entries = <Entry>[];
  final accountManager = AccountManager();

  void clear() {
    entries.clear();
    accountManager.clear();
  }
}