import 'dart:math';

import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

final posting1 = Posting(account:'Expenses:books', currency: r'$', amount: 500);
final posting2 = Posting(account:'Liabilities:credit card', currency: r'EUR', amount: -500.3);
final posting3 = Posting(account:'Liabilities:debit card', currency: r'EUR', amount: -500.0);


void main() {
  final definition = LedgerLineDefinition();
  final parser = definition.build();

  group('entry header lines', () {
    test('basic parsing', () {
      expect(parser.parse('2023/01/06 XYZ').value, EntryLine(date:DateTime(2023, 01, 06), code:'', state:EntryState.uncleared, payee:'XYZ', note:''));
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

  group('posting line', () {
    test('with amount', () {
      expect(parser.parse(r'    Expenses:books     $ 500').value, PostingLine(account:'Expenses:books', currency:r'$', amount:500.0, note:''));
    });

    test('with note', () {
      expect(parser.parse(r'    Expenses:books     $ -3.14159 ; this is a note').value,PostingLine(account:'Expenses:books', currency:r'$', amount:-3.14159, note:'this is a note'));
    });
  });
}
