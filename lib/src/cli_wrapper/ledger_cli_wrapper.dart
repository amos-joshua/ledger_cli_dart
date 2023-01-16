import 'dart:async';
import 'package:csv/csv.dart';

import "../core/core.dart";
import 'cli_wrapper.dart';

class LedgerCliWrapper implements TransactionSource {
  static const queryArgumentFormatter = QueryArgumentFormatter();
  final CliWrapper ledgerBinary;
  String ledgerFile;
  LedgerCliWrapper({required this.ledgerBinary, required this.ledgerFile});

  static LedgerCliWrapper forLedger({required String ledgerBinary, required String ledgerFile}) => LedgerCliWrapper(ledgerBinary: CliWrapper(executablePath: ledgerBinary), ledgerFile: ledgerFile);

  @override
  Future<Stream<Transaction>> query(Query query) async {
    final args = ['-f', ledgerFile, 'csv'];
    args.addAll(queryArgumentFormatter.asList(query));
    final csvData = await ledgerBinary.execute(args);
    return Stream.value(csvData).transform(CsvToListConverter(eol: "\n", shouldParseNumbers: true, allowInvalid: false)).transform(ListToTransactionConverter());
  }
}