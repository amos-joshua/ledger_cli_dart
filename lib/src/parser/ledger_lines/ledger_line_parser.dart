import 'package:petitparser/petitparser.dart';
import '../../core/core.dart';
import 'ledger_line.dart';

// Users PetitParser to parse strings into LedgerLines
class LedgerLineDefinition extends GrammarDefinition {
  @override
  // NOTE: emptyLine should be last
  Parser start() => (ref0(entryLine) | ref0(noteLine) | ref0(postingLine) | ref0(accountLine) | ref0(includeLine) | ref0(emptyLine) ).end();

  Parser emptyLine() => spaces().flatten().map((val) => EmptyLine.empty);

  Parser spaces() => char(' ').star();
  Parser space() => char(' ');
  Parser entryLine() => seq5(ref0(date), ref0(code), ref0(state), ref0(payee), ref0(note).optional()).map5((date, code, state, payee, note) => EntryLine(date: date, code: code ?? '', state: state, payee: payee, note: note ?? ''));

  Parser dateComponent(String label) => digit().plus().flatten(label).map(int.parse);
  Parser date() => seq3(ref1(dateComponent, 'year').skip(after:char('/') | char('-')), ref1(dateComponent, 'month').skip(after:char('/') | char('-')), ref1(dateComponent, 'day')).map3((year, month, day) => DateTime(year, month, day));
  Parser state() => (char('*') | char('!')).skip(before:ref0(space), after:ref0(space)).optional().map((val) => val == '*' ? EntryState.cleared : val == '!' ? EntryState.pending : EntryState.uncleared);
  Parser code() => pattern('0-9a-zA-Z#').plus().flatten().trim().skip(before:whitespace().star() & char('('), after:char(')') & whitespace().star()).optional();
  Parser payee() => (char('\n') | char(';')).neg().plus().flatten().map((strVal) => strVal.trim());
  Parser note() => (spaces() & (char(';') | char('#')) & spaces() & char('\n').neg().star().flatten()).pick(3);

  Parser noteLine() => note().map((val) => NoteLine(val));

  Parser accountLine() => ('account '.toParser() & char('\n').neg().star().flatten().trim()).pick(1).map((val) => AccountLine(val));

  Parser currency() => ((char(' ') | pattern('0-9') | char(';') | char('#') | char('-') | char('+')).neg() & (char(' ') | char(';') | char('#')).neg().star()).flatten().trim();
  Parser amount() => (char('-').optional() & char('0').or(digit().plus()) & char('.').seq(digit().plus()).optional()).flatten().map(double.parse);
  Parser account() => '    '.toParser().neg().plus().flatten().trim();

  Parser<IncludeLine> includeLine() => ('include '.toParser() & char('\n').neg().star().flatten().trim()).pick(1).map((path) => IncludeLine(path));

  Parser<PostingLine> postingLine() => seq6('    '.toParser(message: 'Posting should start with four spaces'), ref0(account), ref0(currency).optional(), ref0(amount).optional(), ref0(currency).optional(), ref0(note).optional()).map6((_, account, preCurrency, amount, postCurrency, note) => PostingLine(account: account, currency: preCurrency ?? postCurrency ?? '', amount: amount, note: note ?? ''));

}


