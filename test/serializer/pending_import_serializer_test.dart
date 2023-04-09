
import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

const importAccount = ImportAccount(
    label: 'Test account',
    sourceAccount: 'Assets:Test account',
    currency: 'EUR',
    csvFormat: csvFormatWise,
    defaultDestinationAccount: 'Expenses:misc'
);

final testPendingEntries = [
  PendingImportedEntry(
      csvLine: CsvLine(
        amount: 10.0,
        date: DateTime(2001, 02, 03),
        description: 'SOCKS INC'
      ),
      importAccount: importAccount
  )..destinationAccount = 'Expenses:clothes',
  PendingImportedEntry(
      csvLine: CsvLine(
          amount: 15.8,
          date: DateTime(2003, 05, 09),
          description: 'THE PIZZA SHOP'
      ),
      importAccount: importAccount
  )..destinationAccount = 'Expenses:food'
];

void main() {
  final queryExecutor = QueryExecutor();

  group('pending imported entry serializer', () {
    test('serialize list', () {
      final pendingImportSerializer = PendingImportSerializer();
      final serialized = pendingImportSerializer.serialize(testPendingEntries);
      expect(serialized, """2001/02/03 * SOCKS INC
    Assets:Test account                                 -10.0 EUR
    Expenses:clothes                                     10.0 EUR

2003/05/09 * THE PIZZA SHOP
    Assets:Test account                                 -15.8 EUR
    Expenses:food                                        15.8 EUR""");
    });

  });


}
