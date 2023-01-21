import '../../core/core.dart';
import 'edits.dart';
import 'ledger_edit_applier.dart';

class LedgerEditReceiver {
  final LedgerEditApplier editApplier;
  LedgerEditReceiver({required this.editApplier});
  static LedgerEditReceiver forLedger(Ledger ledger, {required LedgerEditApplyFailureHandler onApplyFailure}) => LedgerEditReceiver(editApplier: LedgerEditApplierDefault(ledger: ledger, onApplyFailure: onApplyFailure));

  Future<void> receive(Stream<LedgerEdit> incomingEdits) async {
    await for (final edit in incomingEdits) {
      try {
        editApplier.apply(edit);
      }
      catch (exc, stackTrace) {
        editApplier.onApplyFailure(edit, exc, stackTrace);
      }
    }
  }
}