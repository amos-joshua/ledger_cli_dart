import '../../core/core.dart';
import 'edits.dart';

typedef LedgerEditApplyFailureHandler = void Function(LedgerEdit, Object, StackTrace);
abstract class LedgerEditApplier {
  final LedgerEditApplyFailureHandler onApplyFailure;
  const LedgerEditApplier({required this.onApplyFailure});
  void apply(LedgerEdit edit);
}

class LedgerEditApplierDefault extends LedgerEditApplier {
  final Ledger ledger;

  const LedgerEditApplierDefault({required this.ledger, required super.onApplyFailure});

  @override
  void apply(LedgerEdit edit) {
    if (edit is LedgerEditAddAccount) {
      ledger.accountManager.accountNamed(edit.account);
    }
    else if (edit is LedgerEditAddEntry) {
      ledger.entries.add(edit.entry);
    }
    else {
      throw 'Unexpected LedgerEdit type "${edit.runtimeType}"';
    }
  }
}