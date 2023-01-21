import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

const testData1 = """
account Assets:Checking
account Assets:Savings

2023/01/02 * ABC
    Assets:Checking      \$ 50
    Expenses:Food        \$ -50
""";

const testDataAdjustingBlankLine = """
2023/01/02 * CC1
    Assets:Checking      
    Expenses:Food        \$ 50
    Expenses:Music       \$ 20
""";

void main() {
  group('line to edit transformer', () {
    test('transform strings in stream', () async {
      final stringStream = Stream<String>.fromIterable(testData1.split("\n"));
      final ledgerLineStream = stringStream.transform(LedgerStringToLineTransformer());
      final ledgerEditsStream = ledgerLineStream.transform(LedgerLineToEditsTransformer());
      final ledgerEdits = await ledgerEditsStream.toList();
      expect(ledgerEdits, [
        LedgerEditAddAccount('Assets:Checking'),
        LedgerEditAddAccount('Assets:Savings'),
        LedgerEditAddAccount('Expenses:Food'),
        LedgerEditAddEntry(Entry(date: DateTime(2023,01,02), code: '', payee: 'ABC', state: EntryState.cleared, note: '', postings: [
          Posting(account: 'Assets:Checking', currency: r'$', amount: 50.0, note: ''),
          Posting(account: 'Expenses:Food', currency: r'$', amount: -50.0, note: '')
        ]))
      ]);
    });

    test('handle posting with no amount', () async {
      final stringStream = Stream<String>.fromIterable(testDataAdjustingBlankLine.split("\n"));
      final ledgerLineStream = stringStream.transform(LedgerStringToLineTransformer());
      final ledgerEditsStream = ledgerLineStream.transform(LedgerLineToEditsTransformer());
      final ledgerEdits = await ledgerEditsStream.toList();
      expect(ledgerEdits, [
        LedgerEditAddAccount('Assets:Checking'),
        LedgerEditAddAccount('Expenses:Food'),
        LedgerEditAddAccount('Expenses:Music'),
        LedgerEditAddEntry(Entry(date: DateTime(2023,01,02), code: '', payee: 'CC1', state: EntryState.cleared, note: '', postings: [
          Posting(account: 'Assets:Checking', currency: r'$', amount: -70.0, note: ''),
          Posting(account: 'Expenses:Food', currency: r'$', amount: 50.0, note: ''),
          Posting(account: 'Expenses:Music', currency: r'$', amount: 20.0, note: '')
        ]))
      ]);
    });
  });
}
