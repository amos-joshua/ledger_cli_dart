
import 'transaction.dart';
import 'query.dart';

abstract class TransactionSource {
  Future<Stream<Transaction>> query(Query query);
}

