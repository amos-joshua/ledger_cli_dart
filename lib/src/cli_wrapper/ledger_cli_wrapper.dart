import "../core/core.dart";
import 'cli_wrapper.dart';

class LedgerCliWrapper implements TransactionSource {
  final CliWrapper ledgerBinary;
  LedgerCliWrapper({required this.ledgerBinary});

  static forLedgerBinaryPath(String ledgerBinaryPath) => LedgerCliWrapper(ledgerBinary: CliWrapper(executablePath: ledgerBinaryPath));

  @override
  Future<Stream<Transaction>> query(Query query) async {
    return Stream.empty();
  }
}