import 'dart:convert';

import '../core/ledger_preferences.dart';
import '../core/import_account.dart';
import 'csv/format.dart';

class LedgerPreferencesParser {
  const LedgerPreferencesParser();

  LedgerPreferences parse(String jsonData) {
    final jsonObject = jsonDecode(jsonData);
    if (jsonObject is! Map<String, dynamic>) {
      throw Exception("Cannot parse preferences, root object is not a Map but a [${jsonData.runtimeType}] instead");
    }

    final defaultLedgerFile = jsonObject['defaultLedgerFile'];
    final defaultCsvImportDirectory = jsonObject['defaultCsvImportDirectory'];
    final importAccountsObjects = jsonObject['importAccounts'];

    if (defaultLedgerFile is! String) throw Exception('Error parsing preferences, expected a string attribute "defaultLedgerFile" but found [$defaultLedgerFile] which is a [${defaultLedgerFile.runtimeType}]');
    if (defaultLedgerFile.trim().isEmpty) throw Exception('Error parsing preferences, "defaultLedgerFile" is empty');

    if (defaultCsvImportDirectory is! String) throw Exception('Error parsing preferences, expected a string attribute "defaultCsvImportDirectory" but found [$defaultCsvImportDirectory] which is a [${defaultCsvImportDirectory.runtimeType}]');
    if (defaultCsvImportDirectory.trim().isEmpty) throw Exception('Error parsing preferences, "defaultCsvImportDirectory" is empty');

    if (importAccountsObjects is! List<dynamic>) throw Exception('Error parsing preferences, expected a list attribute "importAccounts" but found [$importAccountsObjects] which is a [${importAccountsObjects.runtimeType}]');
    final importAccounts = _parseImportAccounts(importAccountsObjects);

    return LedgerPreferences(
        defaultLedgerFile: defaultLedgerFile,
        defaultCsvImportDirectory: defaultCsvImportDirectory,
        importAccounts: importAccounts
    );
  }

  List<ImportAccount> _parseImportAccounts(List<dynamic> jsonObjects) {
    final importAccounts = <ImportAccount>[];
    for (final jsonObject in jsonObjects) {
      if (jsonObject is! Map<String, dynamic>) throw Exception("Cannot parse import accounts, object [$jsonObject] is not a Map<String, dynamic> but rather a [${jsonObject.runtimeType}]");
      final importAccount = _parseImportAccount(jsonObject);
      importAccounts.add(importAccount);
    }

    return importAccounts;
  }

  ImportAccount _parseImportAccount(Map<String, dynamic> jsonObject) {
    final label = jsonObject['label'];
    final sourceAccount = jsonObject['sourceAccount'];
    final currency = jsonObject['currency'];
    final csvFormatLabel = jsonObject['format'];
    final defaultDestinationAccount = jsonObject['defaultDestinationAccount'];

    if (label is! String) throw Exception('Error parsing import accounts, expected a String "label" attribute in [$jsonObject] but found [$label]');
    if (label.trim().isEmpty) throw Exception('Error parsing import accounts, jsonObject [$jsonObject] has an empty label attribute');

    if (sourceAccount is! String) throw Exception('Error parsing import accounts, expected a String "sourceAccount" attribute in [$jsonObject] but found [$sourceAccount]');
    if (sourceAccount.trim().isEmpty) throw Exception('Error parsing import accounts, jsonObject [$jsonObject] has an empty sourceAccount attribute');

    if (currency is! String) throw Exception('Error parsing import accounts, expected a String "currency" attribute in [$jsonObject] but found [$currency]');
    if (currency.trim().isEmpty) throw Exception('Error parsing import accounts, jsonObject [$jsonObject] has an empty currency attribute');

    if (csvFormatLabel is! String) throw Exception('Error parsing import accounts, expected a String "format" attribute in [$jsonObject] but found [$csvFormatLabel]');
    final csvFormat = CsvFormat.all.firstWhere((csvFormat) => csvFormat.name == csvFormatLabel, orElse: () {
      throw Exception("Error parsing import accounts, format [$csvFormatLabel] is unknown");
    });

    if (defaultDestinationAccount is! String) throw Exception('Error parsing import accounts, expected a String "defaultDestinationAccount" attribute in [$jsonObject] but found [$defaultDestinationAccount]');
    if (defaultDestinationAccount.trim().isEmpty) throw Exception('Error parsing import accounts, jsonObject [$jsonObject] has an empty defaultDestinationAccount attribute');

    return ImportAccount(
        label: label,
        sourceAccount: sourceAccount,
        currency: currency,
        csvFormat: csvFormat,
        defaultDestinationAccount: defaultDestinationAccount
    );
  }
}