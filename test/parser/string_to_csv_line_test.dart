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

void main() {
  group('CsvDataLoader', () {
    test('convert string to CsvLines', () async {
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
  });
}
