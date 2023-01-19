import 'entry.dart';
import 'posting.dart';
import 'package:petitparser/petitparser.dart';


abstract class LedgerLine {
}

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

class PostingLine extends LedgerLine {
  final String account;
  final String currency;
  final double amount;
  final String note;
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

class LedgerLineDefinition extends GrammarDefinition {
  @override
  Parser start() => (ref0(entryLine) | ref0(noteLine) | ref0(postingLine)).end();

  Parser spaces() => char(' ').star();
  Parser space() => char(' ');
  Parser entryLine() => seq5(ref0(date), ref0(code), ref0(state), ref0(payee), ref0(note).optional()).map5((date, code, state, payee, note) => EntryLine(date: date, code: code ?? '', state: state, payee: payee, note: note ?? ''));

  Parser dateComponent(String label) => digit().plus().flatten(label).map(int.parse);
  Parser date() => seq3(ref1(dateComponent, 'year').skip(after:char('/')), ref1(dateComponent, 'month').skip(after:char('/')), ref1(dateComponent, 'day')).map3((year, month, day) => DateTime(year, month, day));
  Parser state() => (char('*') | char('!')).skip(before:ref0(space), after:ref0(space)).optional().map((val) => val == '*' ? EntryState.cleared : val == '!' ? EntryState.pending : EntryState.uncleared);
  Parser code() => pattern('0-9a-zA-Z#').plus().flatten().trim().skip(before:whitespace().star() & char('('), after:char(')') & whitespace().star()).optional();
  Parser payee() => (char('\n') | char(';')).neg().plus().flatten().map((strVal) => strVal.trim());
  Parser note() => (spaces() & char(';') & spaces() & char('\n').neg().star().flatten()).pick(3);
  
  Parser noteLine() => note().map((val) => NoteLine(val));


  Parser currency() => char(' ').neg().plus().flatten().trim();
  Parser amount() => (char('-').optional() & char('0').or(digit().plus()) & char('.').seq(digit().plus()).optional()).flatten().map(double.parse);
  Parser account() => '    '.toParser().neg().plus().flatten().trim();
  Parser<PostingLine> postingLine() => seq5('    '.toParser(message: 'Posting should start with four spaces'), account(), currency(), amount(), ref0(note).optional()).map5((_, account, currency, amount, note) => PostingLine(account: account, currency: currency, amount: amount, note: note ?? ''));
}

