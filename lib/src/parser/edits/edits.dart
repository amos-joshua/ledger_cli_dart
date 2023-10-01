import '../../core/core.dart';

// Abstract parent of all ledger edits (results of reading a LedgerLine stream)
abstract class LedgerEdit {
}

// LedgerEdit representing a line that could not be processed
class LedgerEditInvalidLine extends LedgerEdit {
  final String invalidLine;
  final String reason;
  final StackTrace? stackTrace;
  LedgerEditInvalidLine({required this.invalidLine, required this.reason, required this.stackTrace});

  @override
  toString() => "LedgerEditInvalidLine(invalidLine: $invalidLine, reason: $reason)";

  @override
  bool operator ==(Object other) => (other is LedgerEditInvalidLine) && (invalidLine == other.invalidLine) && (reason == other.reason);

  @override
  int get hashCode => Object.hashAll([invalidLine, reason]);
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
  final List<String> matchers;
  LedgerEditAddAccount(this.account, {this.matchers = const []});

  @override
  toString() => "LedgerEditAddAccount(account: $account)";

  bool hasMatchers(List<String> otherMatchers) {
    if (otherMatchers.length != matchers.length) return false;
    for (int i=0; i < matchers.length; i += 1) {
      if (otherMatchers[i] != matchers[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) => (other is LedgerEditAddAccount) && (account == other.account) && hasMatchers(other.matchers);

  @override
  int get hashCode => account.hashCode;
}