
class DateRange {
  final DateTime startDateInclusive;
  final DateTime endDateInclusive;

  const DateRange({required this.startDateInclusive, required this.endDateInclusive});

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