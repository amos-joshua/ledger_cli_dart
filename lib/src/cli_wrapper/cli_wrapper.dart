import "../core/core.dart";

class LedgerCliWrapper implements TransactionSource {
  @override
  Future<Stream<Transaction>> query(Query query) async {
    return Stream.empty();
  }

}
