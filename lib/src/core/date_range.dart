import 'package:ledger_cli/src/core/dart_adder.dart';

/*
import 'date_adder.dart';

enum DateRangeLength {
  day, week, month, year
}*/

class DateRange {
//  static const dateAdder = DateAdder();

  final DateTime startDateInclusive;
  final DateTime endDateInclusive;

  const DateRange({required this.startDateInclusive, required this.endDateInclusive});

  /*
  factory DateRange.withLength(DateTime startDateInclusive, DateRangeLength length) {
    if (length == DateRangeLength.day) {
      return DateRange(startDateInclusive: startDateInclusive, endDateInclusive: startDateInclusive);
    } else if (length == DateRangeLength.week) {
      return DateRange(startDateInclusive: startDateInclusive, endDateInclusive: startDateInclusive.add(Duration(days: 7)));
    } else if (length == DateRangeLength.month) {
      return DateRange(startDateInclusive: startDateInclusive, endDateInclusive: dateAdder.addMonth(startDateInclusive).subtract(const Duration(days: 1)));
    }
    else {
      return DateRange(startDateInclusive: startDateInclusive, endDateInclusive: dateAdder.addYear(startDateInclusive).subtract(const Duration(days: 1)));
    }
  }*/

  bool includes(DateTime date) {
    return startDateInclusive.isBefore(date) && endDateInclusive.isAfter(date);
  }

  @override
  String toString() => 'DateRange($startDateInclusive, $endDateInclusive)';

  @override
  bool operator ==(Object other) => (other is DateRange) && (other.startDateInclusive == startDateInclusive) && (other.endDateInclusive == endDateInclusive);

  @override
  int get hashCode => Object.hash(startDateInclusive, endDateInclusive);


  static bool compareDates(DateTime date1, DateTime date2) => (date1.year == date2.year) && (date1.month == date2.month) && (date1.day == date2.day);
}