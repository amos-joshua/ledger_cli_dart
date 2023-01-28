import 'dart:async';
import 'package:petitparser/petitparser.dart';
import 'ledger_line_parser.dart';
import 'ledger_line.dart';

// StreamTransformer to convert String lines into LedgerLines
class LedgerStringToLineTransformer implements StreamTransformer<String, LedgerLine> {
  static final ledgerLineDefinition = LedgerLineDefinition();
  late final Parser ledgerLineParser;

  late final StreamController<LedgerLine> _controller;
  StreamSubscription? _subscription;
  final bool cancelOnError;
  late final Stream<String> _incomingStream;
  var lineNumber = 0;

  LedgerStringToLineTransformer({bool sync = false, this.cancelOnError = true}) {
    _controller = StreamController<LedgerLine>(onListen: _onListen, onCancel: _onCancel, onPause: () {
      _subscription?.pause();
    }, onResume: () {
      _subscription?.resume();
    }, sync: sync);
    ledgerLineParser = ledgerLineDefinition.build();
  }

  LedgerStringToLineTransformer.broadcast({bool sync = false, this.cancelOnError = true}) {
    _controller = StreamController<LedgerLine>.broadcast(onListen: _onListen, onCancel: _onCancel, sync: sync);
  }

  void _onListen() {
    _subscription = _incomingStream.listen(onData,
        onError: _controller.addError,
        onDone: _controller.close,
        cancelOnError: cancelOnError);
  }

  void _onCancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  void onData(String data) {
    lineNumber += 1;
    final ledgerLineParser2 = ledgerLineDefinition.build();

    final ledgerLine = ledgerLineParser2.parse(data);
    if (ledgerLine.isSuccess) {
      if (ledgerLine.value is EmptyLine) return;
      _controller.add(ledgerLine.value);
    }
    else {
      throw Exception("Error parsing line #$lineNumber [$data]: ${ledgerLine.message} (at position:${ledgerLine.position})");
    }
  }

  @override
  Stream<LedgerLine> bind(Stream<String> stream) {
    lineNumber = 0;
    _incomingStream = stream;
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    throw UnimplementedError();
  }

}