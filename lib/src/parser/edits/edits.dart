import '../../core/core.dart';

abstract class LedgerEdit {
}

class LedgerEditAddEntry extends LedgerEdit {
  final Entry entry;
  LedgerEditAddEntry(this.entry);

  @override
  toString() => "LedgerEditAddEntry(entry: $entry)";
}

class LedgerEditAddAccount extends LedgerEdit {
  final String account;
  LedgerEditAddAccount(this.account);

  @override
  toString() => "LedgerEditAddAccount(account: $account)";
}