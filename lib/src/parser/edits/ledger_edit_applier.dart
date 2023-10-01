import '../../core/core.dart';
import 'edits.dart';

typedef LedgerEditApplyFailureHandler = void Function(LedgerEdit?, Object, StackTrace);

// Interface for LedgerEdit handling classes
abstract class LedgerEditApplier {
  final LedgerEditApplyFailureHandler onApplyFailure;
  const LedgerEditApplier({required this.onApplyFailure});
  void apply(LedgerEdit edit);
}

// Default LedgerEditApplier, simply adds the entries/accounts it receives to a ledger
class LedgerEditApplierDefault extends LedgerEditApplier {
  final Ledger ledger;

  const LedgerEditApplierDefault({required this.ledger, required super.onApplyFailure});

  @override
  void apply(LedgerEdit edit) {
    if (edit is LedgerEditAddAccount) {
      ledger.accountManager.addAccount(edit.account, matchers: edit.matchers);
    }
    else if (edit is LedgerEditAddEntry) {
      ledger.entries.add(edit.entry);
    }
    else if (edit is LedgerEditInvalidLine) {
      onApplyFailure(edit, edit.reason, edit.stackTrace ?? StackTrace.current);
    }
    else {
      throw 'Unexpected LedgerEdit type "${edit.runtimeType}"';
    }
  }
}