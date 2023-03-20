import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

const testDataBnp = """"Compte de ch&egrave;ques";"Compte de ch&amp;egrave;ques";****;09/01/2023;;20 000,10
02/01/2023;V;V;transfer 1;-1 200,00
03/01/2023;V;V;transfer 2;2 052,20
03/01/2023;F;F;charge 1;-2,50
04/01/2023;V;V;transfer 3;600,00
05/01/2023;P;P;charge 2;-110,59
05/01/2023;E;E;charge 2;-918,46
""";

const testDataWise = """TransferWise ID,Date,Amount,Currency,Description,Payment Reference,Running Balance,Exchange From,Exchange To,Exchange Rate,Payer Name,Payee Name,Payee Account Number,Merchant,Card Last Four Digits,Card Holder Full Name,Attachment,Note,Total fees
CARD-xyz,08-01-2023,-4.99,EUR,C,,146.65,,,,,,,charge 1,1234,Name,,,0
CARD-xyz,08-01-2023,-7,EUR,Ca,,151.64,,,,,,,charge 2,1234,Name,,,0
CARD-xyz,06-01-2023,-840.88,EUR,C,,158.64,EUR,GBP,0.88025,,,,charge 3,1234,Name,,,3.93
CARD-xyz,04-01-2023,50.99,EUR,C,,999.52,,,,,,,charge 4,1234,Name,,,0
CARD-xyz,03-01-2023,-27.13,EUR,C,,948.53,,,,,,,charge 5,1234,Name,,,0
""";

void main() {
  group('CsvDataLoader', () {
    test('convert bnp data to CsvLines', () async {
      final csvDataLoader = const CsvDataLoader();
      final csvDataStream = Stream.value(testDataBnp);
      final csvLinesStream = csvDataLoader.openStreamFromStringData(csvDataStream, csvFormat: csvFormatBnp);
      final csvLines = await csvLinesStream.toList();
      expect(csvLines, [
        CsvLine(date: DateTime(2023, 1, 2), description: 'transfer 1', amount: -1200.0),
        CsvLine(date: DateTime(2023, 1, 3), description: "transfer 2", amount: 2052.20),
        CsvLine(date: DateTime(2023, 1, 3), description: "charge 1", amount: -2.50),
        CsvLine(date: DateTime(2023, 1, 4), description: "transfer 3", amount: 600.0),
        CsvLine(date: DateTime(2023, 1, 5), description: "charge 2", amount: -110.59),
        CsvLine(date: DateTime(2023, 1, 5), description: "charge 2", amount: -918.46)
      ]);
    });

    test('convert wise data to CsvLines', () async {
      final csvDataLoader = const CsvDataLoader();
      final csvDataStream = Stream.value(testDataWise);
      final csvLinesStream = csvDataLoader.openStreamFromStringData(csvDataStream, csvFormat: csvFormatWise);
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
}
