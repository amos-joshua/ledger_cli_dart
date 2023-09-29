import 'dart:async';
import 'edits.dart';
import '../ledger_lines/ledger_line.dart';
import 'ledger_line_processor.dart';

// A StreamTransformer that converts LedgerLines into LedgerEdits
//
// Under the hood, uses LedgerLineProcessor
class LedgerLineToEditsTransformer implements StreamTransformer<LedgerLine, LedgerEdit> {
  final LedgerLineStreamProvider streamForIncludedFileCallback;
  late final StreamController<LedgerEdit> _controller;
  StreamSubscription? _subscription;
  final bool cancelOnError;
  late final Stream<LedgerLine> _incomingStream;
  late final LedgerLineProcessor ledgerLineProcessor;
  final void Function(Object, StackTrace) onTransformError;


  LedgerLineToEditsTransformer({bool sync = false, this.cancelOnError = true, List<String> knownAccounts = const [], required this.streamForIncludedFileCallback, required this.onTransformError}) {
    _controller = StreamController<LedgerEdit>(onListen: _onListen, onCancel: _onCancel, onPause: () {
      _subscription?.pause();
    }, onResume: () {
      _subscription?.resume();
    }, sync: sync);
    ledgerLineProcessor = LedgerLineProcessor(knownAccounts: knownAccounts, streamForIncludedFileCallback: streamForIncludedFileCallback);
  }

  LedgerLineToEditsTransformer.broadcast({bool sync = false, this.cancelOnError = true, required this.streamForIncludedFileCallback, required this.onTransformError}) {
    _controller = StreamController<LedgerEdit>.broadcast(onListen: _onListen, onCancel: _onCancel, sync: sync);
  }

  void _onListen() {
    _subscription = _incomingStream.listen(onData,
        onError: _controller.addError,
        onDone: () {
          final lastEdit = ledgerLineProcessor.finalize();
          if (lastEdit != null) {
            _controller.add(lastEdit);
          }
          _controller.close();
        },
        cancelOnError: cancelOnError);
  }

  void _onCancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  void onData(LedgerLine data) {
    ledgerLineProcessor.processLineWithIncludes(data).toList().then((lines) {
      lines.forEach(_controller.add);
    }).catchError((exc, stackTrace) {
      onTransformError(exc, stackTrace);
      return null;
    });
  }

  @override
  Stream<LedgerEdit> bind(Stream<LedgerLine> stream) {
    _incomingStream = stream;
    ledgerLineProcessor.initialize();
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    throw UnimplementedError();
  }

}