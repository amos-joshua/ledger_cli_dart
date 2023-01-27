import 'package:ledger_cli/ledger_cli.dart';

import '../core/core.dart';
import 'inverted_posting.dart';

abstract class QueryResult {
}

class PostingFilterResult implements QueryResult {
  List<InvertedPosting> matches;
  PostingFilterResult({required this.matches});


  @override
  String toString() => 'PostingFilterResult(${matches.map((invertedPosting) => '$invertedPosting').join('\n')}';

  @override
  bool operator ==(Object other) {
    if (other is! PostingFilterResult) return false;
    if (other.matches.length != matches.length) return false;
    for (int i= 0; i < matches.length; i += 1) {
      if (matches[i] != other.matches[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => matches.hashCode;
}

class BalanceResult implements QueryResult {
  Map<String, DenominatedAmount> balances;
  BalanceResult({Map<String, DenominatedAmount>? balances}): balances = balances ?? {};

  void add(String account, DenominatedAmount denominatedAmount) {
    final balance = balances[account];
    if (balance == null) {
      balances[account] = denominatedAmount;
    }
    else {
      balance.amount += denominatedAmount.amount;
    }
  }

  @override
  String toString() => 'BalanceResult(${balances.keys.map((account) => '$account = ${balances[account]}').join('\n')})';

  @override
  bool operator ==(Object other) {
    if (other is! BalanceResult) return false;
    if (other.balances.keys.length != balances.keys.length) return false;
    return balances.keys.every((account) => balances[account] == other.balances[account]);
  }

  @override
  int get hashCode => balances.hashCode;
}