import 'query_result.dart';
import '../../core/core.dart';

class BalanceResult implements QueryResult {
  List<BalanceEntry> balances = [];
  BalanceResult({required this.balances});

  @override
  String toString() => 'BalanceResult($balances)';

  @override
  bool operator ==(Object other) {
    if (other is! BalanceResult) return false;
    if (other.balances.length != balances.length) return false;
    return balances.asMap().keys.every((index) => balances[index] == other.balances[index]);
  }

  @override
  int get hashCode => balances.hashCode;
}


class BalanceResultsBuilder {
  final DateTime? startDate;
  final PeriodLength? periodLength;
  final periodAccountAmountsMap = PeriodAccountAmountsMap();

  BalanceResultsBuilder({this.startDate, this.periodLength});

  void add(String account, DateTime date, DenominatedAmount denominatedAmount) {
    final period = _periodFor(date);
    periodAccountAmountsMap.add(period, account, denominatedAmount);
  }

  Period _periodFor(DateTime date) {
    final startDate = this.startDate;
    final periodLength = this.periodLength;
    if ((startDate == null) || (periodLength == null)) return Period.forever;
    return Period.periodFor(startDate, date, periodLength);
  }

  BalanceResult build() {
    final entries = <BalanceEntry>[];
    final periods = periodAccountAmountsMap.periods;
    for (final period in periods) {
      final accountsAmountMap = periodAccountAmountsMap.amountsFor(period);
      for (final account in accountsAmountMap.accounts) {
        final denominatedAmount = accountsAmountMap.denominatedAmountFor(account);
        final entry = BalanceEntry(account: account, denominatedAmount: denominatedAmount, period: period.isForever ? null : period);
        entries.add(entry);
      }
    }
    return BalanceResult(balances: entries);
  }
}