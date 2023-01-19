import 'dart:async';
import 'edits.dart';
import '../lines/ledger_line.dart';
import 'ledger_line_pocessor.dart';

class LedgerLineToEditsTransformer implements StreamTransformer<LedgerLine, LedgerEdit> {
  late final StreamController<LedgerEdit> _controller;
  StreamSubscription? _subscription;
  final bool cancelOnError;
  late final Stream<LedgerLine> _incomingStream;
  late final LedgerLineProcessor ledgerLineProcessor;

  LedgerLineToEditsTransformer({bool sync = false, this.cancelOnError = true, List<String> knownAccounts = const []}) {
    _controller = StreamController<LedgerEdit>(onListen: _onListen, onCancel: _onCancel, onPause: () {
      _subscription?.pause();
    }, onResume: () {
      _subscription?.resume();
    }, sync: sync);
    ledgerLineProcessor = LedgerLineProcessor(knownAccounts: knownAccounts);
  }

  LedgerLineToEditsTransformer.broadcast({bool sync = false, this.cancelOnError = true}) {
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
    ledgerLineProcessor.processLine(data).toList().then((lines) {
      lines.forEach(_controller.add);
    }).catchError((err, stackTrace) {
      print("ERROR adding edits to stream: $err\n$stackTrace");
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