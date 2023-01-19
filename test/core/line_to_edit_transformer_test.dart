import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

const testData1 = """
account Assets:Checking
account Assets:Savings

2023/01/02 * ABC
    Assets:Checking      \$ 50
    Expenses:Food        \$ -50
""";

void main() {
  group('line to edit transformer', () {
    test('transform strings in stream', () async {
      final stringStream = Stream<String>.fromIterable(testData1.split("\n"));
      final ledgerLineStream = stringStream.transform(LedgerStringToLineTransformer());
      final ledgerEditsStream = ledgerLineStream.transform(LedgerLineToEditsTransformer());
      final ledgerEdits = await ledgerEditsStream.toList();
      expect(ledgerEdits, [
      ]);
    });
  });
}
