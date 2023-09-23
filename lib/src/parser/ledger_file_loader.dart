import 'dart:convert';
import 'dart:io';

import '../core/core.dart';
import 'edits/ledger_edit_receiver.dart';
import 'edits/ledger_edit_applier.dart';
import 'ledger_lines/string_to_line_transformer.dart';
import 'edits/line_to_edit_transformer.dart';

// Reads a ledger source and loads a Ledger instance from it
//
// This is accomplished by stringing together a line splitter, a
// LedgerStringToLineTransformer and a LedgerLineToEditsTransformer and feeding
// them into a LedgerEditReceiver
class LedgerLoader {
  const  LedgerLoader();

  Future<Ledger> load(LedgerSource source, {required LedgerEditApplyFailureHandler onApplyFailure}) {
    return switch(source.sourceType) {
      LedgerSourceType.file => loadFromFile(source.data, onApplyFailure: onApplyFailure),
      LedgerSourceType.stringData => loadFromString(source.data, onApplyFailure: onApplyFailure)
    };
  }

  Future<Ledger> loadFromString(String data, {required LedgerEditApplyFailureHandler onApplyFailure}) {
    return _loadFromStream(Stream<String>.value(data), onApplyFailure: onApplyFailure);
  }

  Future<Ledger> loadFromFile(String ledgerFilePath, {required LedgerEditApplyFailureHandler onApplyFailure}) {
    final ledgerFile = File(ledgerFilePath);
    final editStream = ledgerFile.openRead()
        .transform(Utf8Decoder());
    return _loadFromStream(editStream, onApplyFailure: onApplyFailure);
  }

  Future<Ledger> _loadFromStream(Stream<String> stringStream, {required LedgerEditApplyFailureHandler onApplyFailure}) async {
    final ledger = Ledger();
    final knownAccounts =  ledger.accountManager.accounts.values.toList(growable: false).map((account) => account.name).toList();
    final editReceiver = LedgerEditReceiver.forLedger(ledger, onApplyFailure: onApplyFailure);

    final ledgerStringToLineTransformer = LedgerStringToLineTransformer(onTransformError: (exc, stackTrace) {
      onApplyFailure(null, exc, stackTrace);
    });
    final editStream = stringStream
        .transform(LineSplitter())
        .transform(ledgerStringToLineTransformer)
        .transform(LedgerLineToEditsTransformer(knownAccounts: knownAccounts));
    await editReceiver.receive(editStream);

    return ledger;
  }



}