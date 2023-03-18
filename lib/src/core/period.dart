

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

  @override
  String prettyPrint() {
    final startDate = ledgerDateFormatter.format(dateRange.startDateInclusive);
    final endDate = ledgerDateFormatter.format(dateRange.endDateInclusive);
    switch (length) {
      case PeriodLength.day: return startDate;
      case PeriodLength.week: return "week starting $startDate";
      case PeriodLength.month:
        if (dateRange.startDateInclusive.month  == dateRange.endDateInclusive.month) {
          return "${dateRange.startDateInclusive.year}-${dateRange.startDateInclusive.month.toString().padLeft(2, '0')}";
        }
        return "month starting $startDate";
      case PeriodLength.year:
        if (dateRange.startDateInclusive.year  == dateRange.endDateInclusive.year) {
          return "${dateRange.startDateInclusive.year}";
        }
        return "year starting $startDate";
      case PeriodLength.forever:
        return "(always)";
    }
  }
}

class AccountAmountsMap {
  final Map<String, DenominatedAmount> _amounts = {};
  AccountAmountsMap();

  Iterable<String> get accounts => _amounts.keys;

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

  void add(Period period, String account, DenominatedAmount denominatedAmount) {
    final accountAmountsMap = _accountAmounts[period] ?? AccountAmountsMap();
    accountAmountsMap.add(account, denominatedAmount);
    _accountAmounts[period] = accountAmountsMap;
  }

  Iterable<Period> get periods => _accountAmounts.keys;

  AccountAmountsMap amountsFor(Period period) => _accountAmounts[period] ?? AccountAmountsMap();
}
