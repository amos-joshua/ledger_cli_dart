
import 'package:ledger_cli/src/core/core.dart';

import 'denominated_amount.dart';
import 'date_range.dart';
import 'formatters.dart';

enum PeriodLength {
  day, week, month, year, forever
}

class Period {
  static const ledgerDateFormatter = LedgerDateFormatter();

  static final forever = Period._(dateRange: DateRange(startDateInclusive: DateTime.fromMillisecondsSinceEpoch(0), endDateInclusive: DateTime(9999, 12, 31)), length: PeriodLength.forever);
  final DateRange dateRange;
  final PeriodLength length;
  const Period._({required this.dateRange, required this.length});

  bool includesDate(DateTime date) => dateRange.includes(date);
  bool get isForever => length == PeriodLength.forever;

  static Period dayFor(DateTime startDate, DateTime date) => periodFor(startDate, date, PeriodLength.day);
  static Period weekFor(DateTime startDate, DateTime date) => periodFor(startDate, date, PeriodLength.week);
  static Period monthFor(DateTime startDate, DateTime date) => periodFor(startDate, date, PeriodLength.month);
  static Period yearFor(DateTime startDate, DateTime date) => periodFor(startDate, date, PeriodLength.year);
  
  static Period periodFor(DateTime startDate, DateTime date, PeriodLength periodLength) {
    switch (periodLength) {
      case PeriodLength.forever:
        return forever;
      case PeriodLength.day:
        return Period._(dateRange: DateRange(startDateInclusive: date, endDateInclusive: date), length: periodLength);
      case PeriodLength.week:
        final weeksDelta = date.difference(startDate).inDays ~/ 7;
        final startDaysDelta = Duration(days: weeksDelta * 7);
        final endDaysDelta = Duration(days: (weeksDelta + 1) * 7 - 1);
        return Period._(dateRange: DateRange(startDateInclusive: startDate.add(startDaysDelta), endDateInclusive: startDate.add(endDaysDelta)), length: periodLength);
      case PeriodLength.month:
        if (date.day >= startDate.day) {
          final startDateInclusive = DateTime(date.year, date.month, startDate.day);
          final endDateInclusive = DateTime(date.year, date.month + 1, startDate.day - 1);
          return Period._(
            dateRange: DateRange(
              startDateInclusive: startDateInclusive,
              endDateInclusive: endDateInclusive),
            length: periodLength
          );
        }
        else {
          final startDateInclusive = DateTime(date.year, date.month-1, startDate.day);
          final endDateInclusive = DateTime(date.year, date.month, startDate.day - 1);
          return Period._(
            dateRange: DateRange(
              startDateInclusive: startDateInclusive,
              endDateInclusive: endDateInclusive), 
            length: periodLength
          );
        }
      case PeriodLength.year:
        if ((date.month >= startDate.month) && (date.day >= startDate.day)) {
          final startDateInclusive = DateTime(date.year, startDate.month, startDate.day);
          final endDateInclusive = DateTime(date.year + 1, startDate.month, startDate.day-1);
          return Period._(
            dateRange: DateRange(
              startDateInclusive: startDateInclusive,
              endDateInclusive: endDateInclusive
            ),
            length: periodLength
          );
        }
        else {
          final startDateInclusive = DateTime(date.year - 1, startDate.month, startDate.day);
          final endDateInclusive = DateTime(date.year, startDate.month, startDate.day-1);
          return Period._(
            dateRange: DateRange(
              startDateInclusive: startDateInclusive,
              endDateInclusive: endDateInclusive
            ),
            length: periodLength
          );
        }
    }
  }

  @override
  bool operator ==(Object other) => (other is Period) && (other.dateRange == dateRange);

  @override
  int get hashCode => dateRange.hashCode;

  @override
  String toString() => 'Period.${length.name}(${ledgerDateFormatter.format(dateRange.startDateInclusive)}, ${ledgerDateFormatter.format(dateRange.endDateInclusive)})';
}

/*
class PeriodBucket {
  final Period period;
  DenominatedAmount denominatedAmount = DenominatedAmount(0, '');
  
  PeriodBucket({required this.period});

  void add(DenominatedAmount newDenominatedAmount) {
    if (denominatedAmount.amount == 0) {
      denominatedAmount.currency = newDenominatedAmount.currency;
      denominatedAmount.amount = newDenominatedAmount.amount;
    }
    else if (denominatedAmount.currency == newDenominatedAmount.currency) {
      denominatedAmount.amount += newDenominatedAmount.amount;
    }
    else {
      throw CurrencyMismatch('Cannot add $newDenominatedAmount to $denominatedAmount, currency mismatch');
    }
  }
  
  bool acceptsDate(DateTime date) => period.includesDate(date);
}*/


class AccountAmountsMap {
  final Map<String, DenominatedAmount> _amounts = {};
  AccountAmountsMap();

  Iterable<String> get accounts => _amounts.keys;

  // TODO test
  void add(String account, DenominatedAmount newDenominatedAmount) {
    final denominatedAmount = _amounts[account] ?? DenominatedAmount(0, newDenominatedAmount.currency);
    denominatedAmount.amount += newDenominatedAmount.amount;
    _amounts[account] = denominatedAmount;
  }

  DenominatedAmount denominatedAmountFor(String account) => _amounts[account] ?? DenominatedAmount(0, '');
}

class PeriodAccountAmountsMap {
  final Map<Period, AccountAmountsMap> _accountAmounts = {};
  PeriodAccountAmountsMap();

  // TODO test
  void add(Period period, String account, DenominatedAmount denominatedAmount) {
    final accountAmountsMap = _accountAmounts[period] ?? AccountAmountsMap();
    accountAmountsMap.add(account, denominatedAmount);
    _accountAmounts[period] = accountAmountsMap;
  }

  Iterable<Period> get periods => _accountAmounts.keys;

  AccountAmountsMap amountsFor(Period period) => _accountAmounts[period] ?? AccountAmountsMap();
}

/*
class PeriodBucketsContainer {
  final Map<Period, PeriodBucket> periods = {};
  final DateTime startDate;
  final PeriodLength periodLength;
  PeriodBucketsContainer({required this.startDate, required this.periodLength});
  
  void add(DateTime date, DenominatedAmount newDenominatedAmount) {
    final period = Period.periodFor(startDate, date, periodLength);
    final bucket = periods[period] ?? PeriodBucket(period: period);
    bucket.add(newDenominatedAmount);
    periods[period] = bucket;
  }
}*/

/*
class PeriodBucketSorter {
  final Map<String, PeriodBucketsContainer> _bucketContainers = {};
  final DateTime startDate;
  final PeriodLength periodLength;
  PeriodBucketSorter({required this.startDate, required this.periodLength});
  
  void add(String account, DateTime date, DenominatedAmount denominatedAmount) {
    final bucketContainer = _bucketContainers[account] ?? PeriodBucketsContainer(startDate: startDate, periodLength: periodLength);
    bucketContainer.add(date, denominatedAmount);
    _bucketContainers[account] = bucketContainer;
  }
}*/