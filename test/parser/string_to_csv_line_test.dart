import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../core/test_formats.dart';

const testDataBank1 = """"Compte de ch&egrave;ques";"Compte de ch&amp;egrave;ques";****;09/01/2023;;20 000,10
02/01/2023;V;V;transfer 1;-1 200,00
03/01/2023;V;V;transfer 2;2 052,20
03/01/2023;F;F;charge 1;-2,50
04/01/2023;V;V;transfer 3;600,00
05/01/2023;P;P;charge 2;-110,59
05/01/2023;E;E;charge 2;-918,46
""";

const testDataBank2 = """TransferWise ID,Date,Amount,Currency,Description,Payment Reference,Running Balance,Exchange From,Exchange To,Exchange Rate,Payer Name,Payee Name,Payee Account Number,Merchant,Card Last Four Digits,Card Holder Full Name,Attachment,Note,Total fees
CARD-xyz,08-01-2023,-4.99,EUR,C,,146.65,,,,,,,charge 1,1234,Name,,,0
CARD-xyz,08-01-2023,-7,EUR,Ca,,151.64,,,,,,,charge 2,1234,Name,,,0
CARD-xyz,06-01-2023,-840.88,EUR,C,,158.64,EUR,GBP,0.88025,,,,charge 3,1234,Name,,,3.93
CARD-xyz,04-01-2023,50.99,EUR,C,,999.52,,,,,,,charge 4,1234,Name,,,0
CARD-xyz,03-01-2023,-27.13,EUR,C,,948.53,,,,,,,charge 5,1234,Name,,,0
""";


const testDataCRLF = """"Compte de ch&egrave;ques";"Compte de ch&amp;egrave;ques";****;09/01/2023;;20 000,10\r
02/01/2023;V;V;transfer 1;-1 200,00\r
03/01/2023;V;V;transfer 2;2 052,20\r
""";

final bank1CsvLine1 = CsvLine(date: DateTime(2023, 1, 2), description: 'transfer 1', amount: -1200.0);
final bank1CsvLine2 = CsvLine(date: DateTime(2023, 1, 3), description: "transfer 2", amount: 2052.20);
final bank1CsvLine3 = CsvLine(date: DateTime(2023, 1, 3), description: "charge 1", amount: -2.50);
final bank1CsvLine4 = CsvLine(date: DateTime(2023, 1, 4), description: "transfer 3", amount: 600.0);
final bank1CsvLine5 = CsvLine(date: DateTime(2023, 1, 5), description: "charge 2", amount: -110.59);
final bank1CsvLine6 = CsvLine(date: DateTime(2023, 1, 5), description: "charge 2", amount: -918.46);

void main() {
  group('CsvDataLoader', () {
    test('test crlf', () async {
      const csvDataLoader = CsvDataLoader();
      final csvDataStream = Stream.value(testDataCRLF);
      final csvLinesStream = csvDataLoader.openStreamFromStringData(csvDataStream, csvFormat: csvFormatBank1);
      final csvLines = await csvLinesStream.toList();
      expect(csvLines, [
        bank1CsvLine1,
        bank1CsvLine2
      ]);
    });

    test('convert bnp data to CsvLines', () async {
      const csvDataLoader = CsvDataLoader();
      final csvDataStream = Stream.value(testDataBank1);
      final csvLinesStream = csvDataLoader.openStreamFromStringData(csvDataStream, csvFormat: csvFormatBank1);
      final csvLines = await csvLinesStream.toList();
      expect(csvLines, [
        bank1CsvLine1,
        bank1CsvLine2,
        bank1CsvLine3,
        bank1CsvLine4,
        bank1CsvLine5,
        bank1CsvLine6
      ]);
    });

    test('convert wise data to CsvLines', () async {
      const csvDataLoader = CsvDataLoader();
      final csvDataStream = Stream.value(testDataBank2);
      final csvLinesStream = csvDataLoader.openStreamFromStringData(csvDataStream, csvFormat: csvFormatBank2);
      final csvLines = await csvLinesStream.toList();
      expect(csvLines, [
        CsvLine(date: DateTime(2023, 1, 8), description: 'charge 1', amount: -4.99),
        CsvLine(date: DateTime(2023, 1, 8), description: "charge 2", amount: -7.0),
        CsvLine(date: DateTime(2023, 1, 6), description: "charge 3", amount: -840.88),
        CsvLine(date: DateTime(2023, 1, 4), description: "charge 4", amount: 50.99),
        CsvLine(date: DateTime(2023, 1, 3), description: "charge 5", amount: -27.13)
      ]);
    });
  });

  group('ImportSession', () {
    test('ImportSession test 1', () async {
      final csvLinesStream = Stream.fromIterable([bank1CsvLine1, bank1CsvLine2, bank1CsvLine3]);
      final accountManager = AccountManager();
      final account1 = accountManager.accountNamed('Expenses:food');
      final account2 = accountManager.accountNamed('Expenses:gas');
      account1.matchers.add('transfer 1');
      account2.matchers.add('transfer 2');
      final importAccount = ImportAccount(
          label: 'bnp1',
          sourceAccount: 'Assets:checking',
          currency: 'EUR',
          csvFormat: csvFormatBank1,
          defaultDestinationAccount: 'Expenses:misc'
      );
      final importSession = ImportSession(accountManager: accountManager);
      await importSession.loadCsvLines(csvLinesStream, importAccount: importAccount);
      expect(importSession.pendingEntries, [
        PendingImportedEntry(csvLine: bank1CsvLine1, importAccount: importAccount, destinationAccount: 'Expenses:food'),
        PendingImportedEntry(csvLine: bank1CsvLine2, importAccount: importAccount, destinationAccount: 'Expenses:gas'),
        PendingImportedEntry(csvLine: bank1CsvLine3, importAccount: importAccount, destinationAccount: ''),
      ]);
    });
  });
}
