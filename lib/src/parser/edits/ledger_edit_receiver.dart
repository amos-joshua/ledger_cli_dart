import 'dart:async';
import '../../core/core.dart';
import 'edits.dart';
import 'ledger_edit_applier.dart';

// Receives a stream of LedgerEdits and routes them to a LedgerEditApplier
class LedgerEditReceiver {
  final LedgerEditApplier editApplier;
  LedgerEditReceiver({required this.editApplier});
  static LedgerEditReceiver forLedger(Ledger ledger, {required LedgerEditApplyFailureHandler onApplyFailure}) => LedgerEditReceiver(editApplier: LedgerEditApplierDefault(ledger: ledger, onApplyFailure: onApplyFailure));

  Future<void> receive(Stream<LedgerEdit> incomingEdits) async {
    final transformer = StreamTransformer<LedgerEdit, LedgerEdit>.fromHandlers(
      handleData: (edit, sink) {
        try {
          editApplier.apply(edit);
        }
        catch (exc, stackTrace) {
          editApplier.onApplyFailure(edit, exc, stackTrace);
        }
      },
      handleError: (exc, stackTrace, sink) {
        editApplier.onApplyFailure(null, exc, stackTrace);
      },
      handleDone: (sink) {
        sink.close();
      });
    await for (final _ in incomingEdits.transform(transformer)) {
      // pass
    }

  }
}