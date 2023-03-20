import '../../core/core.dart';

// Abstract parent of all ledger edits (results of reading a LedgerLine stream)
abstract class LedgerEdit {
}

// LedgerEdit representing the need to add an entry based on a sequence of LedgerLines
class LedgerEditAddEntry extends LedgerEdit {
  final Entry entry;
  LedgerEditAddEntry(this.entry);

  @override
  toString() => "LedgerEditAddEntry(entry: $entry)";

  @override
  bool operator ==(Object other) => (other is LedgerEditAddEntry) && (entry == other.entry);

  @override
  int get hashCode => entry.hashCode;
}

// LedgerEdit representing the need to add an account based on a sequence of LedgerLines
class LedgerEditAddAccount extends LedgerEdit {
  final String account;
  LedgerEditAddAccount(this.account);

  @override
  toString() => "LedgerEditAddAccount(account: $account)";

  @override
  bool operator ==(Object other) => (other is LedgerEditAddAccount) && (account == other.account);

  @override
  int get hashCode => account.hashCode;
}