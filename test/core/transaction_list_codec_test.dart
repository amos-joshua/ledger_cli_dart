import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

class SampleTransactions {
  static const clearedTransaction = [
  "2013/09/02" , "314159" , "things" , "Assets:Cash" , "P" , -2000 , "*" , "some notes"
  ];

  static const pendingTransaction = [
  "2014/09/02" , "100" , "stuff" , "Assets:Cash" , r"$" , 30.1 , "!" , "other notes"
  ];

  static const invalidDateTransaction = [
    "not a date" , "314159" , "things" , "Assets:Cash" , "P" , -2000 , "*" , "some notes"
  ];

  static const invalidAmountTransaction = [
    "2013/09/02" , "314159" , "things" , "Assets:Cash" , "P" , "not-an-amount" , "*" , "some notes"
  ];
}


void main() {
  group('Converting lists to transactions', () {
    final transactionListCodec = TransactionListCodec();

    test('cleared transaction', () {
      final transaction = TransactionListCodec().decode(SampleTransactions.clearedTransaction);
      expect(transaction.date, DateTime(2013, 09, 02));
      expect(transaction.code, '314159');
      expect(transaction.description, "things");
      expect(transaction.account, "Assets:Cash");
      expect(transaction.currency, "P");
      expect(transaction.amount, -2000);
      expect(transaction.status, TransactionStatus.cleared);
      expect(transaction.notes, "some notes");
    });

    test('pending transaction', () {
      final transaction = TransactionListCodec().decode(SampleTransactions.pendingTransaction);
      expect(transaction.date, DateTime(2014, 09, 02));
      expect(transaction.code, '100');
      expect(transaction.description, "stuff");
      expect(transaction.account, "Assets:Cash");
      expect(transaction.currency, r"$");
      expect(transaction.amount, 30.1);
      expect(transaction.status, TransactionStatus.pending);
      expect(transaction.notes, "other notes");
    });

    test('invalid date transaction', () {
      expect(
          () => TransactionListCodec().decode(SampleTransactions.invalidDateTransaction),
          throwsA(isA<Exception>())
      );
    });

    test('invalid amount', () {
      expect(
              () => TransactionListCodec().decode(SampleTransactions.invalidAmountTransaction),
          throwsA(isA<Exception>())
      );
    });
  });
}
