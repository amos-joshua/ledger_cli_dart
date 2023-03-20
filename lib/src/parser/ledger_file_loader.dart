import 'dart:convert';
import 'dart:io';

import '../core/core.dart';
import 'edits/ledger_edit_receiver.dart';
import 'edits/ledger_edit_applier.dart';
import 'ledger_lines/string_to_line_transformer.dart';
import 'edits/line_to_edit_transformer.dart';

// Reads a ledger file and loads a Ledger instance from it
//
// This is accomplished by stringing together a line splitter, a
// LedgerStringToLineTransformer and a LedgerLineToEditsTransformer and feeding
// them into a LedgerEditReceiver
class LedgerFileLoader {

  const  LedgerFileLoader();

  Future<Ledger> load(String ledgerFilePath, {required LedgerEditApplyFailureHandler onApplyFailure}) async {
    final ledger = Ledger();
    final knownAccounts =  ledger.accountManager.accounts.values.toList(growable: false).map((account) => account.name).toList();
    final editReceiver = LedgerEditReceiver.forLedger(ledger, onApplyFailure: onApplyFailure);

    final ledgerFile = File(ledgerFilePath);
    final editStream = ledgerFile.openRead()
        .transform(Utf8Decoder())
        .transform(LineSplitter())
        .transform(LedgerStringToLineTransformer())
        .transform(LedgerLineToEditsTransformer(knownAccounts: knownAccounts));

    await editReceiver.receive(editStream);
    return ledger;
  }

}