import 'dart:async';
import 'edits.dart';
import '../ledger_lines/ledger_line.dart';
import 'ledger_line_processor.dart';

class LedgerLineToEditsConverter {
  final LedgerLineStreamProvider streamForIncludedFileCallback;
  LedgerLineToEditsConverter({required this.streamForIncludedFileCallback});

  Stream<LedgerEdit> convert(Stream<LedgerLine> lines, {List<String> knownAccounts = const []}) async* {
    final ledgerLineProcessor = LedgerLineProcessor(knownAccounts: knownAccounts, streamForIncludedFileCallback: streamForIncludedFileCallback);
    ledgerLineProcessor.initialize();
    await for (final line in lines) {
      try {
        yield* ledgerLineProcessor.processLineWithIncludes(line);
      }
      catch (exc, stackTrace) {
        yield LedgerEditInvalidLine(invalidLine: '$line', reason: '$exc', stackTrace: stackTrace);
      }
    }
    final lastEdit = ledgerLineProcessor.finalize();
    if (lastEdit != null) {
      yield lastEdit;
    }
  }
}