import 'dart:math';

import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

final posting1 = Posting(account:'Expenses:books', currency: r'$', amount: 500);
final posting2 = Posting(account:'Liabilities:credit card', currency: r'EUR', amount: -500.3);
final posting3 = Posting(account:'Liabilities:debit card', currency: r'EUR', amount: -500.0);


void main() {
  group('entry header', () {
    test('basic parsing', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.entryHeader);

      expect(parser.parse('2023/01/06 XYZ').value, [DateTime(2023, 01, 06), null, EntryState.uncleared, 'XYZ', []]);
    });

    test('header with code', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.entryHeader);

      expect(parser.parse('2023/02/04 (#100) ABC').value, [DateTime(2023, 02, 04), '#100', EntryState.uncleared, 'ABC', []]);
    });

    test('header with state', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.entryHeader);

      expect(parser.parse('2023/02/01 * DEF').value, [DateTime(2023, 02, 01), null, EntryState.cleared, 'DEF', []]);
    });

    test('header with note', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.entryHeader);

      expect(parser.parse('2023/02/01 * DEF GHI ; something or other').value, [DateTime(2023, 02, 01), null, EntryState.cleared, 'DEF GHI', ['something or other']]);
    });

    test('header with multiline notes', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.entryHeader);

      expect(parser.parse('2023/02/01 * DEF GHI ; something or other\n ; on two lines').value, [DateTime(2023, 02, 01), null, EntryState.cleared, 'DEF GHI', ['something or other', 'on two lines']]);
    });
  });

  group('posting header', () {
    test('with amount', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.postingHeader);

      expect(parser.parse(r'    Expenses:books     $ 500').value, ['    ', 'Expenses:books', r'$', 500.0, []]);
    });

    test('with note', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.postingHeader);

      expect(parser.parse(r'    Expenses:books     $ -3.14159 ; this is a note').value, ['    ', 'Expenses:books', r'$', -3.14159, ['this is a note']]);
    });
  });

  group('posting', () {
    test('with amount', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.posting);

      expect(parser.parse(r'    Expenses:books     $ 500').value, Posting(account: 'Expenses:books', currency: r'$', amount: 500.0));
    });

    test('with end-line note', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.posting);

      expect(parser.parse(r'    Expenses:books     $ -3.14159 ; this is a note').value, Posting(account: 'Expenses:books', currency: r'$', amount: -3.14159, notes: 'this is a note'));
    });

    test('with multiline note', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.posting);

      expect(parser.parse('    Expenses:books     \$ -3.14159 ; this is a note\n    ; on two lines').value, Posting(account: 'Expenses:books', currency: r'$', amount: -3.14159, notes: 'this is a note\non two lines'));
    });
  });

  group('postings', () {
    test('posting with amount', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.posting);

      expect(parser.parse(r'    Expenses:books     $ 500').value, posting1);
      expect(parser.parse(r'    Liabilities:credit card     EUR -500.3').value, posting2);
    });

    test('multiple postings', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.postings);
      expect(parser.parse("""    Expenses:books     \$ 500
    Liabilities:credit card     EUR -500.3
""").value, [posting1, posting2]);
    });
  });

  group('entries', () {

    test('simple entry', () {
      final definition = EntryDefinition();
      final parser = definition.build(start: definition.entry);

      final parsedEntry = parser.parse(
          r"""2023/02/04 (#100) ABC
    Expenses:books     $ 500
    Liabilities:debit card     EUR -500
""").value as Entry;

      final expectedEntry =  Entry(date:DateTime(2023, 02, 04), code: '#100', payee: 'ABC', state: EntryState.uncleared, postings: [posting1, posting3]);
      expect(parsedEntry.date, expectedEntry.date);
      expect(parsedEntry.code, expectedEntry.code);
      expect(parsedEntry.payee, expectedEntry.payee);
      expect(parsedEntry.state, expectedEntry.state);
      expect(parsedEntry.postings, expectedEntry.postings);
    });
  });



  group('blarg', () {

    test('simple entry', () {
      final definition = BlargDefinition();
      final parser = definition.build(start: definition.note);

      expect(parser.parse("; this is a note").value, []);
    });

    test('multilinezz', () {
      final definition = BlargDefinition();
      final parser = definition.build(start: definition.note);

      expect(parser.parse("; this is a note \n ; blarfds").value, []);
    });
  });
}
