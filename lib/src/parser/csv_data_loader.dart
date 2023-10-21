import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

import 'csv/list_to_csv_line_converter.dart';
import 'csv/csv_line.dart';
import '../core/csv_format.dart';

class CsvDataLoader {
  const CsvDataLoader();
  static final newLinePunctuator = StreamTransformer<String, String>.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);
        sink.add("\n");
      }
  );

  Stream<CsvLine> openStreamFromFile(String csvFilePath, {required CsvFormat csvFormat}) {
    final csvFile = File(csvFilePath);
    final csvDataStream = csvFile.openRead().transform(Utf8Decoder());
    return openStreamFromStringData(csvDataStream, csvFormat: csvFormat);
  }

  Stream<CsvLine> openStreamFromStringData(Stream<String> csvDataStream, {required CsvFormat csvFormat}) async* {
    final toCsvLineConverter = ListToCsvLineConverter(csvFormat: csvFormat);
    final newlineSeparatedStream = csvDataStream.transform(LineSplitter()).transform(newLinePunctuator); // LineSplitter splits at both CRLF and LF, newLinePunctuator will only add LF
    final csvListStream = newlineSeparatedStream.transform(CsvToListConverter(fieldDelimiter: csvFormat.valueSeparator, eol: "\n", shouldParseNumbers: true));
    yield* toCsvLineConverter.convert(csvListStream);
  }

}