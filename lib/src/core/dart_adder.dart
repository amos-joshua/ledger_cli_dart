/*
class DateAdder {
  const DateAdder();

  DateTime addMonth(DateTime date) {
    final nextMonth = (date.month % 12) + 1;
    DateTime monthLater = DateTime(
        date.year, date.month + 1,
        date.day);
    if (monthLater.month - nextMonth > 0) {
      for (var i = 0; (i < 3) &&
          (monthLater.month - nextMonth > 0); i += 1) {
        monthLater =
            monthLater.subtract(const Duration(days: 1));
      }
    }
    return monthLater;
  }

  DateTime addYear(DateTime date) {
    final nextYear = date.year + 1;
    DateTime yearLater = DateTime(
        nextYear, date.month,
        date.day);
    if (yearLater.month - date.month > 0) {
      for (var i = 0; (i < 3) &&
          (yearLater.month - date.month > 0); i += 1) {
        yearLater =
            yearLater.subtract(const Duration(days: 1));
      }
    }
    return yearLater;
  }
}*/