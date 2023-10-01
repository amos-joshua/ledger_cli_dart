import 'dart:async';
import 'package:petitparser/petitparser.dart';
import 'ledger_line_parser.dart';
import 'ledger_line.dart';

final ledgerLineParser = LedgerLineDefinition().build();

class LedgerStringToLineConverter {
  const LedgerStringToLineConverter();

  Stream<LedgerLine> convert(Stream<String> stream) async* {
    var lineNumber = 0;

    await for (final str in stream) {
      lineNumber += 1;
      try {
        final line = _convertString(str, lineNumber);
        if (line is! EmptyLine) {
          yield line;
        }
      }
      catch (exc, stackTrace) {
        yield InvalidLine(str, '$exc', stackTrace);
      }
    }
  }

  LedgerLine _convertString(String data, int lineNumber) {
    final ledgerLine = ledgerLineParser.parse(data);
    if (ledgerLine is Success) {
      return ledgerLine.value;
    }
    else {
      throw Exception("Error parsing line #$lineNumber [$data]: ${ledgerLine
          .message} (at position:${ledgerLine.position})");
    }
  }
}