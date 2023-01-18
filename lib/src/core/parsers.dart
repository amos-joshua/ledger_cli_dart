import 'entry.dart';
import 'posting.dart';
import 'package:petitparser/petitparser.dart';


class EntryDefinition extends GrammarDefinition {
  @override
  Parser start() => ref0(entry).end();

  Parser spaces() => char(' ').star();

  Parser<Entry> entry() => seq2<dynamic, List<Posting>>(ref0(entryHeader), postings()).map2<Entry>((entryHeader, postings) => Entry(date: entryHeader[0], code: entryHeader[1], state: entryHeader[2], payee: entryHeader[3], postings: postings));

  Parser entryHeader() => ref0(date) & ref0(code)& ref0(state) & ref0(payee) & ref0(note);

  Parser<List<Posting>> postings() => (ref0(posting).skip(before: char('\n').optional())).plus().castList<Posting>();



  Parser dateComponent(String label) => digit().plus().flatten(label).map(int.parse);
  Parser date() => seq3(ref1(dateComponent, 'year').skip(after:char('/')), ref1(dateComponent, 'month').skip(after:char('/')), ref1(dateComponent, 'day')).map3((year, month, day) => DateTime(year, month, day));
  Parser state() => (char('*') | char('!')).skip(before:char(' ').star().optional(), after:char(' ').star().optional()).optional().map((val) => val == '*' ? EntryState.cleared : val == '!' ? EntryState.pending : EntryState.uncleared);
  Parser code() => pattern('0-9a-zA-Z#').plus().flatten().trim().skip(before:whitespace().star() & char('('), after:char(')') & whitespace().star()).optional();
  Parser payee() => (char('\n') | char(';')).neg().plus().flatten().map((strVal) => strVal.trim());

  Parser noteFragment() => (spaces() & char(';') & spaces() & char('\n').neg().star().flatten()).pick(3);
  Parser note() => (ref0(noteFragment) & char('\n').optional()).pick(0).star();

  Parser currency() => char(' ').neg().plus().flatten().trim();
  Parser amount() => (char('-').optional() & char('0').or(digit().plus()) & char('.').seq(digit().plus()).optional()).flatten().map(double.parse);
  Parser account() => '    '.toParser().neg().plus().flatten().trim();
  Parser<List> postingHeader() => '    '.toParser(message: 'Posting should start with four spaces') & account() & currency() & amount() & note();

  Parser<Posting> posting() => ref0(postingHeader).map((header) => Posting(account: header[1], currency: header[2], amount: header[3], notes: header[4].join("\n")));
  //Parser posting() => seq5('    '.toParser(message: 'Posting should start with four spaces'), account(), currency(), amount(), noteFragment()).map5((_, account, currency, amount, noteFragment) => Posting(account:account, currency:currency, amount: amount));
}




class BlargDefinition extends GrammarDefinition {
  @override
  Parser start() => ref0(note).end();

  Parser spaces() => char(' ').star();
  Parser noteFragment() => (spaces() & char(';') & char('\n').neg().star().flatten()).pick(2);
  Parser note() => (ref0(noteFragment) & char('\n').optional()).pick(0).star();
}