import '../../core/core.dart';

// Abstract parent for all LedgerLines, i.e. a parsed line in a ledger file
abstract class LedgerLine {
}

// Represents an "include ..." line in a ledger file
class IncludeLine extends LedgerLine {
  final String path;
  IncludeLine(this.path);

  @override
  String toString() => "IncludeLine(path: $path)";

  @override
  bool operator ==(Object other) => (other is IncludeLine) && (path == other.path);

  @override
  int get hashCode => path.hashCode;
}

// Represents an "entry" line in a ledger file, i.e. something like "2023/01/03 * Payee"
class EntryLine extends LedgerLine {
  final DateTime date;
  final String code;
  final EntryState state;
  final String payee;
  final String note;

  EntryLine({required this.date, required this.code, required this.state, required this.payee, required this.note});

  @override
  String toString() => "EntryLine(date: $date, code: $code, payee: $payee, state: $state, note: $note)";

  @override
  bool operator ==(Object other) => (other is EntryLine) &&
      (date == other.date) &&
      (code == other.code) &&
      (payee == other.payee) &&
      (state == other.state) &&
      (note == other.note);

  @override
  int get hashCode => Object.hash(date, code, payee, state, note);
}

// Represents an empty line in a ledger file
class EmptyLine extends LedgerLine {
  static final empty = EmptyLine();
}

// Represents a note line in a ledger file
class NoteLine extends LedgerLine {
  final String note;
  NoteLine(this.note);

  @override
  String toString() => "NoteLine(note: $note)";

  @override
  bool operator ==(Object other) => (other is NoteLine) && (note == other.note);

  @override
  int get hashCode => note.hashCode;
}

// Represents an account line in a ledger file, i.e. "account ...."
class AccountLine extends LedgerLine {
  final String name;
  AccountLine(this.name);

  @override
  String toString() => "AccountLine(name: $name)";

  @override
  bool operator ==(Object other) => (other is AccountLine) && (name == other.name);

  @override
  int get hashCode => name.hashCode;
}

// Represents a posting line in a ledger file, i.e. looks like "  Assets::CC     50 USD"
class PostingLine extends LedgerLine {
  String account;
  String currency;
  double? amount;
  String note;
  PostingLine({required this.account, required this.currency, required this.amount, required this.note});


  @override
  String toString() => "PostingLine(account: $account, currency: $currency, amount: $amount, note: $note)";

  @override
  bool operator ==(Object other) => (other is PostingLine) &&
      (account == other.account) &&
      (currency == other.currency) &&
      (amount == other.amount) &&
      (note == other.note);

  @override
  int get hashCode => Object.hash(account, currency, amount, note);
}
