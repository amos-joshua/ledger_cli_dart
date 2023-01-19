import 'package:ledger_cli/ledger_cli.dart';

import '../../core/core.dart';

abstract class LedgerEdit {
}

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