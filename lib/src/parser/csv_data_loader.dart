import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'csv/list_to_csv_line_transformer.dart';
import 'csv/csv_line.dart';
import '../core/csv_format.dart';

class CsvDataLoader {
  const  CsvDataLoader();

  Stream<CsvLine> openStreamFromFile(String csvFilePath, {required CsvFormat csvFormat}) {
    final csvFile = File(csvFilePath);
    final csvDataStream = csvFile.openRead().transform(Utf8Decoder());
    return openStreamFromStringData(csvDataStream, csvFormat: csvFormat);
  }

  Stream<CsvLine> openStreamFromStringData(Stream<String> csvDataStream, {required CsvFormat csvFormat}) {
    return csvDataStream
        .transform(CsvToListConverter(fieldDelimiter: csvFormat.valueSeparator, eol: "\n", shouldParseNumbers: true))
        .transform(ListToCsvLineTransformer(csvFormat: csvFormat));
  }

}