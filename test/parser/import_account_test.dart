
import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

const testData1 = """
[
  {
    "label": "BNP account 1",
    "sourceAccount": "Assets:checking",
    "currency": "EUR",
    "format": "bnp",
    "defaultDestinationAccount": "Expenses:misc"
  },
  {
    "label": "Wise account 2",
    "sourceAccount": "Assets:wise-cc",
    "currency": "USD",
    "format": "wise",
    "defaultDestinationAccount": "Expenses:work"
  }
]
""";

void main() {
  group('ImportAccountParser', () {
    test('basic parsing', () {
      final importAccountParser = ImportAccountParser();
      final importAccounts = importAccountParser.parseImportAccounts(testData1);
      expect(importAccounts.length, 2);
      expect(importAccounts[0], ImportAccount(
          label: 'BNP account 1',
          sourceAccount: 'Assets:checking',
          currency: 'EUR',
          csvFormat: csvFormatBnp,
          defaultDestinationAccount: 'Expenses:misc')
      );
      expect(importAccounts[1], ImportAccount(
          label: 'Wise account 2',
          sourceAccount: 'Assets:wise-cc',
          currency: 'USD',
          csvFormat: csvFormatWise,
          defaultDestinationAccount: 'Expenses:work')
      );
    });
  });
}
