
import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

const testData1 = """
{
  "defaultLedgerFile": "/path/to/ledger",
  "defaultCsvImportDirectory": "/path/to/imports",
  "importAccounts": [
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
  ],
  "csvFormats": [
    {
      "name": "Test format",
      "dateColumnIndex": 0,
      "descriptionColumnIndex": 3,
      "amountColumnIndex": 4,
      "dateFormat": "dd/mm/y",
      "numberFormat": "###,##",
      "locale": "fr_FR",
      "lineSkip": 1,
      "valueSeparator": ";",
      "quoteCharacter": ""
    }
  ]
}
""";

void main() {
  group('PreferencesParser', () {
    test('basic parsing', () {
      final preferencesParser = LedgerPreferencesParser();
      final preferences = preferencesParser.parse(testData1);
      expect(preferences.defaultLedgerFile, "/path/to/ledger");
      expect(preferences.defaultCsvImportDirectory, "/path/to/imports");
      expect(preferences.importAccounts.length, 2);
      expect(preferences.importAccounts[0], ImportAccount(
          label: 'BNP account 1',
          sourceAccount: 'Assets:checking',
          currency: 'EUR',
          csvFormat: csvFormatBnp,
          defaultDestinationAccount: 'Expenses:misc')
      );
      expect(preferences.importAccounts[1], ImportAccount(
          label: 'Wise account 2',
          sourceAccount: 'Assets:wise-cc',
          currency: 'USD',
          csvFormat: csvFormatWise,
          defaultDestinationAccount: 'Expenses:work')
      );
      expect(preferences.csvFormats.length, 1);
      expect(preferences.csvFormats[0], CsvFormat(
          name: 'Test format',
          dateColumnIndex: 0,
          descriptionColumnIndex: 3,
          amountColumnIndex: 4,
          dateFormat: "dd/mm/y",
          numberFormat: '###,##',
          locale: 'fr_FR',
          lineSkip: 1,
          valueSeparator: ';',
          quoteCharacter: null)
      );
    });
  });
}
