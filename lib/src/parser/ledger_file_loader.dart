import 'dart:convert';
import 'dart:io';

import '../core/core.dart';
import 'edits/ledger_edit_receiver.dart';
import 'edits/ledger_edit_applier.dart';
import 'ledger_lines/string_to_line_transformer.dart';
import 'edits/line_to_edit_transformer.dart';
import 'ledger_lines/ledger_line.dart';

// Reads a ledger source and loads a Ledger instance from it
//
// This is accomplished by stringing together a line splitter, a
// LedgerStringToLineTransformer and a LedgerLineToEditsTransformer and feeding
// them into a LedgerEditReceiver
class LedgerLoader {
  const LedgerLoader();

  Future<Ledger> load(LedgerSource source, {required LedgerEditApplyFailureHandler onApplyFailure, LedgerLineStreamProvider? loadStreamForIncludedFile}) {
    return switch(source.sourceType) {
      LedgerSourceType.file => loadFromFile(source.data, onApplyFailure: onApplyFailure),
      LedgerSourceType.stringData => loadFromString(source.data, onApplyFailure: onApplyFailure, loadStreamForIncludedFile: loadStreamForIncludedFile ?? _emptyLedgerLineStream)
    };
  }

  Future<Ledger> loadFromString(String data, {required LedgerEditApplyFailureHandler onApplyFailure, required LedgerLineStreamProvider loadStreamForIncludedFile}) {
    return _loadFromStream(Stream<String>.value(data), onApplyFailure: onApplyFailure, streamForIncludedFileCallback: loadStreamForIncludedFile);
  }

  Future<Ledger> loadFromFile(String ledgerFilePath, {required LedgerEditApplyFailureHandler onApplyFailure}) {
    final ledgerFile = File(ledgerFilePath);
    final editStream = ledgerFile.openRead()
        .transform(Utf8Decoder());
    return _loadFromStream(editStream, onApplyFailure: onApplyFailure, streamForIncludedFileCallback: (path) => _ledgerLineStreamFromFile(path, workingDirectory: ledgerFile.parent, onApplyFailure: onApplyFailure));
  }

  Future<Stream<LedgerLine>> _emptyLedgerLineStream(String path) {
    print("Ignoring included file at path [$path]");
    return Future.value(Stream.empty());
  }

  Future<Stream<LedgerLine>> _ledgerLineStreamFromFile(String path, {Directory? workingDirectory, required LedgerEditApplyFailureHandler onApplyFailure}) {
    final fileFromPathAsPassed = File(path);
    var sourceFile = fileFromPathAsPassed;
    if (!fileFromPathAsPassed.isAbsolute && workingDirectory != null) {
      sourceFile = File("${workingDirectory.path}/$path}");
    }

    final toLineTransformer = LedgerStringToLineTransformer(onTransformError: (exc, stackTrace) {
      onApplyFailure(null, exc, stackTrace);
    });

    return Future.value(sourceFile.openRead()
        .transform(Utf8Decoder())
        .transform(toLineTransformer));
  }

  Future<Ledger> _loadFromStream(Stream<String> stringStream, {required LedgerEditApplyFailureHandler onApplyFailure, required LedgerLineStreamProvider streamForIncludedFileCallback}) async {
    final ledger = Ledger();
    final knownAccounts =  ledger.accountManager.accounts.values.toList(growable: false).map((account) => account.name).toList();
    final editReceiver = LedgerEditReceiver.forLedger(ledger, onApplyFailure: onApplyFailure);

    final toLineTransformer = LedgerStringToLineTransformer(onTransformError: (exc, stackTrace) {
      onApplyFailure(null, exc, stackTrace);
    });

    final toEditTransformer = LedgerLineToEditsTransformer(
      knownAccounts: knownAccounts,
      streamForIncludedFileCallback: streamForIncludedFileCallback,
      onTransformError: (exc, stackTrace) {
        onApplyFailure(null, exc, stackTrace);
      });

    final editStream = stringStream
        .transform(LineSplitter())
        .transform(toLineTransformer)
        .transform(toEditTransformer);
    await editReceiver.receive(editStream);

    return ledger;
  }



}