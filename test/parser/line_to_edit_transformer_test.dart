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

const testDataWithError = """
account Assets:Checking
this line is invalid!
account Assets:Savings
""";

const toLineConverter = LedgerStringToLineConverter();
final toEditConverter = LedgerLineToEditsConverter(streamForIncludedFileCallback: (path) => Stream.empty());

void main() {
  group('line to edit converter', () {
    test('convert strings in stream', () async {

      final stringStream = Stream<String>.fromIterable(testData1.split("\n"));
      final ledgerLineStream = toLineConverter.convert(stringStream);
      final ledgerEditsStream = toEditConverter.convert(ledgerLineStream);

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
      final ledgerLineStream = toLineConverter.convert(stringStream);
      final ledgerEditsStream = toEditConverter.convert(ledgerLineStream);
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

    test('handle data with error', () async {
      final stringStream = Stream<String>.fromIterable(testDataWithError.split("\n"));
      final ledgerLineStream = toLineConverter.convert(stringStream);
      final ledgerEditsStream = toEditConverter.convert(ledgerLineStream);
      final ledgerEdits = await ledgerEditsStream.toList();
      expect(ledgerEdits.length, 3);
      expect(ledgerEdits[0], LedgerEditAddAccount('Assets:Checking'));
      expect(ledgerEdits[1] is LedgerEditInvalidLine, true);
      expect(ledgerEdits[2], LedgerEditAddAccount('Assets:Savings'));
    });
  });
}
