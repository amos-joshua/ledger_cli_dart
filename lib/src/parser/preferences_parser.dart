import 'dart:convert';

import '../core/ledger_preferences.dart';
import '../core/import_account.dart';
import '../core/csv_format.dart';

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
    final csvFormatsObjects = jsonObject['csvFormats'];

    if (defaultLedgerFile is! String) throw Exception('Error parsing preferences, expected a string attribute "defaultLedgerFile" but found [$defaultLedgerFile] which is a [${defaultLedgerFile.runtimeType}]');
    if (defaultLedgerFile.trim().isEmpty) throw Exception('Error parsing preferences, "defaultLedgerFile" is empty');

    if (defaultCsvImportDirectory is! String) throw Exception('Error parsing preferences, expected a string attribute "defaultCsvImportDirectory" but found [$defaultCsvImportDirectory] which is a [${defaultCsvImportDirectory.runtimeType}]');
    if (defaultCsvImportDirectory.trim().isEmpty) throw Exception('Error parsing preferences, "defaultCsvImportDirectory" is empty');

    if (importAccountsObjects is! List<dynamic>) throw Exception('Error parsing preferences, expected a list attribute "importAccounts" but found [$importAccountsObjects] which is a [${importAccountsObjects.runtimeType}]');
    if (csvFormatsObjects is! List<dynamic>) throw Exception('Error parsing preferences, expected a list attribute "csvFormats" but found [$csvFormatsObjects] which is a [${csvFormatsObjects.runtimeType}]');

    final csvFormats = _parseCsvFormats(csvFormatsObjects);
    final importAccounts = _parseImportAccounts(importAccountsObjects, csvFormats);

    return LedgerPreferences(
        defaultLedgerFile: defaultLedgerFile,
        defaultCsvImportDirectory: defaultCsvImportDirectory,
        importAccounts: importAccounts,
        csvFormats: csvFormats
    );
  }

  List<CsvFormat> _parseCsvFormats(List<dynamic> jsonObjects) {
    final csvFormats = <CsvFormat>[];
    for (final jsonObject in jsonObjects) {
      if (jsonObject is! Map<String, dynamic>) throw Exception("Cannot parse csv formats, object [$jsonObject] is not a Map<String, dynamic> but rather a [${jsonObject.runtimeType}]");
      final csvFormat = _parseCsvFormat(jsonObject);
      csvFormats.add(csvFormat);
    }

    return csvFormats;
  }

  CsvFormat _parseCsvFormat(Map<String, dynamic> jsonObject) {
    final name = jsonObject['name'];
    final dateColumnIndex = jsonObject['dateColumnIndex'];
    final descriptionColumnIndex = jsonObject['descriptionColumnIndex'];
    final amountColumnIndex = jsonObject['amountColumnIndex'];
    final dateFormat = jsonObject['dateFormat'];
    final numberFormat = jsonObject['numberFormat'];
    final locale = jsonObject['locale'];
    final lineSkip = jsonObject['lineSkip'];
    final valueSeparator = jsonObject['valueSeparator'];
    final quoteCharacter = jsonObject[' quoteCharacter'];

    if (name is! String) throw Exception('Error parsing csv format, expected a String "name" attribute in [$jsonObject] but found [$name]');
    if (dateColumnIndex is! int) throw Exception('Error parsing csv format, expected an int "dateColumnIndex" attribute in [$jsonObject] but found [$dateColumnIndex]');
    if (descriptionColumnIndex is! int) throw Exception('Error parsing csv format, expected an int "descriptionColumnIndex" attribute in [$jsonObject] but found [$descriptionColumnIndex]');
    if (amountColumnIndex is! int) throw Exception('Error parsing csv format, expected an int "amountColumnIndex" attribute in [$jsonObject] but found [$amountColumnIndex]');

    if (dateFormat is! String) throw Exception('Error parsing csv format, expected a String "dateFormat" attribute in [$jsonObject] but found [$dateFormat]');
    if (numberFormat is! String) throw Exception('Error parsing csv format, expected a String "numberFormat" attribute in [$jsonObject] but found [$numberFormat]');
    if (locale is! String) throw Exception('Error parsing csv format, expected a String "locale" attribute in [$jsonObject] but found [$locale]');
    if (lineSkip is! int) throw Exception('Error parsing csv format, expected an int "lineSkip" attribute in [$jsonObject] but found [$lineSkip]');
    if (valueSeparator is! String) throw Exception('Error parsing csv format, expected a String "valueSeparator" attribute in [$jsonObject] but found [$valueSeparator]');
    if (quoteCharacter is! String?) throw Exception('Error parsing csv format, expected a String? " quoteCharacter" attribute in [$jsonObject] but found [$quoteCharacter]');

    return CsvFormat(
        name: name,
        dateColumnIndex: dateColumnIndex,
        descriptionColumnIndex: descriptionColumnIndex,
        amountColumnIndex: amountColumnIndex,
        dateFormat: dateFormat,
        numberFormat: numberFormat,
        locale: locale,
        lineSkip: lineSkip,
        valueSeparator: valueSeparator,
        quoteCharacter: quoteCharacter?.isEmpty == true ? null : quoteCharacter
    );
  }

  List<ImportAccount> _parseImportAccounts(List<dynamic> jsonObjects, List<CsvFormat> csvFormats) {
    final importAccounts = <ImportAccount>[];
    for (final jsonObject in jsonObjects) {
      if (jsonObject is! Map<String, dynamic>) throw Exception("Cannot parse import accounts, object [$jsonObject] is not a Map<String, dynamic> but rather a [${jsonObject.runtimeType}]");
      final importAccount = _parseImportAccount(jsonObject, csvFormats);
      importAccounts.add(importAccount);
    }

    return importAccounts;
  }

  ImportAccount _parseImportAccount(Map<String, dynamic> jsonObject, List<CsvFormat> csvFormats) {
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
    final csvFormat = csvFormats.firstWhere((csvFormat) => csvFormat.name == csvFormatLabel, orElse: () {
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
