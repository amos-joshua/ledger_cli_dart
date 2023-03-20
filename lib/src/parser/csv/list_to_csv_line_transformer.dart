import 'package:intl/intl.dart';
import 'dart:async';
import 'csv_line.dart';
import 'format.dart';


class ListToCsvLineTransformer implements StreamTransformer<List<dynamic>, CsvLine> {
  final CsvFormat csvFormat;

  late final StreamController<CsvLine> _controller;
  StreamSubscription? _subscription;
  final bool cancelOnError;
  late final Stream<List<dynamic>> _incomingStream;
  late final DateFormat dateFormat;
  late final NumberFormat numberFormat;
  var lineNumber = 0;
  var linesSkipped = 0;

  ListToCsvLineTransformer({required this.csvFormat, bool sync = false, this.cancelOnError = true}) {
    dateFormat = DateFormat(csvFormat.dateFormat);
    numberFormat = NumberFormat(csvFormat.numberFormat, csvFormat.locale);
    _controller = StreamController<CsvLine>(onListen: _onListen, onCancel: _onCancel, onPause: () {
      _subscription?.pause();
    }, onResume: () {
      _subscription?.resume();
    }, sync: sync);
  }

  ListToCsvLineTransformer.broadcast({required this.csvFormat, bool sync = false, this.cancelOnError = true}) {
    dateFormat = DateFormat(csvFormat.dateFormat);
    numberFormat = NumberFormat(csvFormat.numberFormat, csvFormat.locale);
    _controller = StreamController<CsvLine>.broadcast(onListen: _onListen, onCancel: _onCancel, sync: sync);
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

  void onData(List<dynamic> data) {
    lineNumber += 1;
    if (linesSkipped < csvFormat.lineSkip) {
      linesSkipped += 1;
      return;
    }
    final dateString = data[csvFormat.dateColumnIndex];
    final description = data[csvFormat.descriptionColumnIndex];
    final amountObj = data[csvFormat.amountColumnIndex];
    double amount = 0.0;

    if (dateString is! String) {
      throw Exception("Error parsing line #$lineNumber [$data]: expected value at index ${csvFormat.dateColumnIndex} to be a string but got [$dateString] which is a [${dateString.runtimeType}] instead");
    }
    if (description is! String) {
      throw Exception("Error parsing line #$lineNumber [$data]: expected value at index ${csvFormat.descriptionColumnIndex} to be a string but got [$description] which is a [${description.runtimeType}] instead");
    }

    if (amountObj is num) {
      amount = amountObj.toDouble();
    }
    else {
      try {
        //final spaceLessString = amountObj.toString().replaceAll(' ', '');
        final parsedDouble = numberFormat.parse(amountObj);
        amount = parsedDouble.toDouble();
      }
      catch (exc){
        throw Exception("Error parsing line #$lineNumber [$data]: expected value at index ${csvFormat.amountColumnIndex} to be a double but got [$amountObj] which is a [${amountObj.runtimeType}] and failed to parse as a double with error: $exc");
      }
    }

    final date = dateFormat.parse(dateString);
    final csvLine = CsvLine(date: date, description: description, amount: amount);
    _controller.add(csvLine);
  }

  @override
  Stream<CsvLine> bind(Stream<List<dynamic>> stream) {
    lineNumber = 0;
    _incomingStream = stream;
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    throw UnimplementedError();
  }
}