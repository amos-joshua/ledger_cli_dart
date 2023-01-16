import 'dart:async';
import 'dart:convert';
import 'transaction.dart';


/*
Ledger CSV format (https://devhints.io/ledger-csv):
date         , code  , desc     , account            , currency , amt     , pending/cleared , notes
"2013/09/02" , ""    , "things" , "Assets:Cash"      , "P"      , "-2000" , "*"             , ""
 */

/// A codec for converting Transactions to/from List<dynamic>s as suitable for the csv dart package
class TransactionListCodec extends Codec<Transaction, List<dynamic>> {
  @override
  Converter<List, Transaction> get decoder => ListToTransactionConverter();

  @override
  Converter<Transaction, List> get encoder => TransactionToListConverter();

  
}

class ChunkedConversionAdaptorSink<T, S> extends ChunkedConversionSink<T> {
  final Converter<T, S> _converter;
  final Sink<S> _outSink;
  ChunkedConversionAdaptorSink(this._outSink, this._converter);

  @override
  void add(T chunk) => _outSink.add(_converter.convert(chunk));


  @override
  void close() => _outSink.close();
}

/// Converts a Transaction to a List<dynamic>, as suitable for feeding to the dart csv package
class TransactionToListConverter extends Converter<Transaction, List<dynamic>> {
  @override
  List<dynamic> convert(Transaction input) {
    return ["${input.date.year}/${input.date.month}/${input.date.day}", input.description, input.account, input.currency, input.amount, input.status.toString(), input.notes];
  }


  @override
  Sink<Transaction> startChunkedConversion(Sink<List<dynamic>> sink) => ChunkedConversionAdaptorSink<Transaction, List<dynamic>>(sink, this);
}

/// Converts a List<dynamic> to a Transaction, as suitable for feeding to the dart csv package
class ListToTransactionConverter extends Converter<List<dynamic>, Transaction> {
  @override
  Transaction convert(List<dynamic> input) {
    if (input.length != 8) {
      throw Exception("Invalid input list: expected list of length 8 but found length ${input.length}");
    }

    final dateStr = input[0];
    final code = input[1];
    final description = input[2];
    final account = input[3];
    final currency = input[4];
    var amountNumber = input[5];
    final statusStr = input[6];
    final notes = input[7];

    if (amountNumber is String) {
      try {
        amountNumber = double.parse(amountNumber);
      }
      catch(exc) {
        throw Exception("Invalid amount '$amountNumber': expected a parsable double but parsing failed on '$amountNumber': $exc");
      }
    }

    final amountIsInt = amountNumber is int;
    final amountIsDouble = amountNumber is double;

    if (dateStr is! String) throw Exception("Invalid date '$dateStr' encountered while converting csv List into a Transaction, expected a String but found ${dateStr.runtimeType}");
    if (description is! String) throw Exception("Invalid description '$description' encountered while converting csv List into a Transaction, expected a String but found ${description.runtimeType}");
    if (code is! String) throw Exception("Invalid code '$code' encountered while converting csv List into a Transaction, expected a String but found ${code.runtimeType}");
    if (account is! String) throw Exception("Invalid account '$account' encountered while converting csv List into a Transaction, expected a String but found ${account.runtimeType}");
    if (currency is! String) throw Exception("Invalid currency '$currency' encountered while converting csv List into a Transaction, expected a String but found ${currency.runtimeType}");
    if (!amountIsInt && !amountIsDouble) throw Exception("Invalid amount '$amountNumber' encountered while converting csv List into a Transaction, expected a double or int but found ${amountNumber.runtimeType}");
    if (statusStr is! String) throw Exception("Invalid status '$statusStr' encountered while converting csv List into a Transaction, expected a String but found ${statusStr.runtimeType}");
    if (notes is! String) throw Exception("Invalid notes '$notes' encountered while converting csv List into a Transaction, expected a String but found ${notes.runtimeType}");

    var date = DateTime.now();
    try {
      date = DateTime.parse(dateStr.replaceAll("/", "-"));
    }
    on FormatException catch(exc) {
      throw Exception("Invalid date format '$dateStr encountered while converting csv List into a Transaction for list $input: $exc");
    }
    var amount = amountIsInt ? amountNumber.toDouble() : amountNumber;
    var status = TransactionStatus.uncleared;
    switch (statusStr) {
      case "!": status = TransactionStatus.pending; break;
      case "*": status = TransactionStatus.cleared; break;
      default: status = TransactionStatus.uncleared; break;
    }
    return Transaction(
      date: date,
      code: code,
      description: description,
      account: account,
      currency: currency,
      amount: amount,
      status: status,
      notes: notes
    );
  }

  @override
  Sink<List<dynamic>> startChunkedConversion(Sink<Transaction> sink) => ChunkedConversionAdaptorSink<List<dynamic>, Transaction>(sink, this);
}

