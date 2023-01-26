
import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

const testData1 = """
account Assets:Checking
account Assets:Savings

2023/01/02 * ABC
    Assets:Checking      \$ 50
    Expenses:Food        \$ -50
""";

void main() {
  final definition = LedgerLineDefinition();
  final parser = definition.build();

  group('entry header lines', () {
    test('basic parsing', () {
      expect(parser.parse('2023/01/06 XYZ').value, EntryLine(date:DateTime(2023, 01, 06), code:'', state:EntryState.uncleared, payee:'XYZ', note:''));
    });

    test('basic parsing with dash date', () {
      expect(parser.parse('2023-01-06 XYZ').value, EntryLine(date:DateTime(2023, 01, 06), code:'', state:EntryState.uncleared, payee:'XYZ', note:''));
    });

    test('header with code', () {
      expect(parser.parse('2023/02/04 (#100) ABC').value, EntryLine(date:DateTime(2023, 02, 04), code:'#100', state:EntryState.uncleared, payee:'ABC', note:''));
    });

    test('header with state', () {
      expect(parser.parse('2023/02/01 * DEF').value, EntryLine(date:DateTime(2023, 02, 01), code:'', state:EntryState.cleared, payee:'DEF', note:''));
    });

    test('header with note', () {
      expect(parser.parse('2023/02/01 * DEF GHI ; something or other').value, EntryLine(date: DateTime(2023, 02, 01), code:'', state:EntryState.cleared, payee:'DEF GHI', note:'something or other'));
    });
  });

  group('note lines', () {
    test('simple note line', () {
      expect(parser.parse('  ; this is a note').value, NoteLine('this is a note'));
    });
  });

  group('account lines', () {
    test('simple account line', () {
      expect(parser.parse('account Assets:checking').value, AccountLine('Assets:checking'));
    });
  });

  group('include lines', () {
    test('include line', () {
      expect(parser.parse('include accounts').value, IncludeLine('accounts'));
    });

  });

  group('posting line', () {
    test('with amount', () {
      expect(parser.parse(r'    Expenses:books     $ 500').value, PostingLine(account:'Expenses:books', currency:r'$', amount:500.0, note:''));
    });

    test('with currency after amount', () {
      expect(parser.parse(r'    Expenses:books     500 EUR').value, PostingLine(account:'Expenses:books', currency:r'EUR', amount:500.0, note:''));
    });

    test('with negative currency after amount', () {
      expect(parser.parse(r'    Expenses:books     -500 EUR').value, PostingLine(account:'Expenses:books', currency:r'EUR', amount:-500.0, note:''));
    });

    test('with note', () {
      expect(parser.parse(r'    Expenses:books     $ -3.14159 ; this is a note').value,PostingLine(account:'Expenses:books', currency:r'$', amount:-3.14159, note:'this is a note'));
    });
  });

  group('string line transformer', () {
    test('transform strings in stream', () async {
      final stringStream = Stream<String>.fromIterable([r'    Expenses:books     $ 500', '  ; this is a note']);
      final ledgerLineStream = stringStream.transform(LedgerStringToLineTransformer());
      final ledgerLines = await ledgerLineStream.toList();
      expect(ledgerLines, [
        PostingLine(account:'Expenses:books', currency:r'$', amount:500.0, note:''),
        NoteLine('this is a note')
      ]);
    });

    test('transform strings in stream', () async {
      final stringStream = Stream<String>.fromIterable(testData1.split("\n"));
      final ledgerLineStream = stringStream.transform(LedgerStringToLineTransformer());
      final ledgerLines = await ledgerLineStream.toList();
      expect(ledgerLines, [
          AccountLine('Assets:Checking'),
          AccountLine('Assets:Savings'),
          EntryLine(date: DateTime(2023, 01, 02), code: '', payee: 'ABC', state: EntryState.cleared, note: ''),
          PostingLine(account: 'Assets:Checking', currency: r'$', amount: 50.0, note: ''),
          PostingLine(account: 'Expenses:Food', currency: r'$', amount: -50.0, note: '')
      ]);
    });
  });
}
