
import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

class PeriodMatcher extends Matcher {
  static const ledgerDateFormatter = LedgerDateFormatter();

  final DateTime startDateInclusive;
  final DateTime endDateInclusive;
  final PeriodLength periodLength;
  PeriodMatcher(this.startDateInclusive, this.endDateInclusive, this.periodLength);

  @override
  Description describe(Description description) {
    return description.add("${periodLength.name} of ${ledgerDateFormatter.format(startDateInclusive)} - ${ledgerDateFormatter.format(endDateInclusive)}");
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    if (item is! Period) return mismatchDescription.add("$item is not a Period instance");
    if (item.dateRange.startDateInclusive != startDateInclusive) mismatchDescription.add("Start date ${ledgerDateFormatter.format(item.dateRange.startDateInclusive)} is different than expected ${ledgerDateFormatter.format(startDateInclusive)}");
    if (item.dateRange.endDateInclusive != endDateInclusive) mismatchDescription.add("end date ${ledgerDateFormatter.format(item.dateRange.endDateInclusive)} is different than expected ${ledgerDateFormatter.format(endDateInclusive)}");
    if (item.length != periodLength) mismatchDescription.add("period length ${item.length} is different than expected period length ${periodLength}");
    return mismatchDescription;
  }

  @override
  bool matches(item, Map matchState) {
    if (item is! Period) return false;
    if (item.dateRange.startDateInclusive != startDateInclusive) return false;
    if (item.dateRange.endDateInclusive != endDateInclusive) return false;
    return true;
  }

  static PeriodMatcher day(DateTime startDate) => PeriodMatcher(startDate, startDate, PeriodLength.day);
  static PeriodMatcher week(DateTime startDate, DateTime endDate) => PeriodMatcher(startDate, endDate, PeriodLength.week);
  static PeriodMatcher month(DateTime startDate, DateTime endDate) => PeriodMatcher(startDate, endDate, PeriodLength.month);
  static PeriodMatcher year(DateTime startDate, DateTime endDate) => PeriodMatcher(startDate, endDate, PeriodLength.year);
}



void main() {
  final mar11_2019 = DateTime(2019, 03, 11);

  final jan1_2020 = DateTime(2020, 01, 01);
  final jan5_2020 = DateTime(2020, 01, 05);
  final jan8_2020 = DateTime(2020, 01, 08);
  final jan11_2020 = DateTime(2020, 01, 11);
  final jan12_2020 = DateTime(2020, 01, 12);
  final jan14_2020 = DateTime(2020, 01, 12);
  final jan18_2020 = DateTime(2020, 01, 18);
  final jan31_2020 = DateTime(2020, 01, 31);

  final feb1_2020 = DateTime(2020, 02, 01);
  final feb11_2020 = DateTime(2020, 02, 11);
  final feb12_2020 = DateTime(2020, 02, 12);
  final feb29_2020 = DateTime(2020, 02, 29);

  final mar1_2020 = DateTime(2020, 03, 01);
  final mar10_2020 = DateTime(2020, 03, 10);
  final mar11_2020 = DateTime(2020, 03, 11);

  final apr11_2020 = DateTime(2020, 04, 11);

  final dec31_2020 = DateTime(2020, 12, 31);

  final jan12_2021 = DateTime(2021, 01, 12);

  final feb1_2021 = DateTime(2021, 02, 01);
  final feb8_2021 = DateTime(2021, 02, 08);
  final feb11_2021 = DateTime(2021, 02, 11);
  final feb12_2021 = DateTime(2021, 02, 12);
  final feb28_2021 = DateTime(2021, 02, 28);

  final mar10_2021 = DateTime(2021, 03, 10);
  final mar11_2021 = DateTime(2021, 03, 11);

  final dec31_2021 = DateTime(2021, 12, 31);


  group('period for', () {
    test('day tests', () {
      expect(Period.periodFor(jan5_2020, DateTime(2023, 03, 22), PeriodLength.day), PeriodMatcher.day(DateTime(2023, 03, 22)));
    });

    test('week tests', () {
      expect(Period.weekFor(jan5_2020, jan5_2020), PeriodMatcher.week(jan5_2020, jan11_2020));
      expect(Period.weekFor(jan5_2020, jan8_2020), PeriodMatcher.week(jan5_2020, jan11_2020));
      expect(Period.weekFor(jan5_2020, jan11_2020), PeriodMatcher.week(jan5_2020, jan11_2020));

      expect(Period.weekFor(jan5_2020, jan12_2020), PeriodMatcher.week(jan12_2020, jan18_2020));
      expect(Period.weekFor(jan5_2020, jan14_2020), PeriodMatcher.week(jan12_2020, jan18_2020));
      expect(Period.weekFor(jan5_2020, jan18_2020), PeriodMatcher.week(jan12_2020, jan18_2020));
    });

    test('month tests starting on 1st', () {
      expect(Period.monthFor(jan1_2020, jan1_2020), PeriodMatcher.month(jan1_2020, jan31_2020));
      expect(Period.monthFor(jan1_2020, jan18_2020), PeriodMatcher.month(jan1_2020, jan31_2020));
      expect(Period.monthFor(jan1_2020, jan31_2020), PeriodMatcher.month(jan1_2020, jan31_2020));

      expect(Period.monthFor(jan1_2020, feb1_2020), PeriodMatcher.month(feb1_2020, feb29_2020));
      expect(Period.monthFor(jan1_2020, feb11_2020), PeriodMatcher.month(feb1_2020, feb29_2020));
      expect(Period.monthFor(jan1_2020, feb29_2020), PeriodMatcher.month(feb1_2020, feb29_2020));

      expect(Period.monthFor(jan1_2020, feb1_2021), PeriodMatcher.month(feb1_2021, feb28_2021));
      expect(Period.monthFor(jan1_2020, feb8_2021), PeriodMatcher.month(feb1_2021, feb28_2021));
      expect(Period.monthFor(jan1_2020, feb28_2021), PeriodMatcher.month(feb1_2021, feb28_2021));
    });


    test('month tests starting on 12th', () {
      expect(Period.monthFor(jan12_2020, jan12_2020), PeriodMatcher.month(jan12_2020, feb11_2020));
      expect(Period.monthFor(jan12_2020, jan18_2020), PeriodMatcher.month(jan12_2020, feb11_2020));
      expect(Period.monthFor(jan12_2020, feb1_2020), PeriodMatcher.month(jan12_2020, feb11_2020));

      expect(Period.monthFor(jan12_2020, feb12_2020), PeriodMatcher.month(feb12_2020, mar11_2020));
      expect(Period.monthFor(jan12_2020, feb29_2020), PeriodMatcher.month(feb12_2020, mar11_2020));
      expect(Period.monthFor(jan12_2020, mar1_2020), PeriodMatcher.month(feb12_2020, mar11_2020));

      expect(Period.monthFor(jan12_2020, feb1_2021), PeriodMatcher.month(jan12_2021, feb11_2021));
      expect(Period.monthFor(jan12_2020, feb8_2021), PeriodMatcher.month(jan12_2021, feb11_2021));
      expect(Period.monthFor(jan12_2020, feb28_2021), PeriodMatcher.month(feb12_2021, mar11_2021));
    });

    test('year tests starting on 1/1', () {
      expect(Period.yearFor(jan1_2020, jan1_2020), PeriodMatcher.year(jan1_2020, dec31_2020));
      expect(Period.yearFor(jan1_2020, mar11_2020), PeriodMatcher.year(jan1_2020, dec31_2020));
      expect(Period.yearFor(jan1_2020, dec31_2020), PeriodMatcher.year(jan1_2020, dec31_2020));
    });

    test('year tests starting on 2020-03-11', () {
      expect(Period.yearFor(mar11_2020, jan8_2020), PeriodMatcher.year(mar11_2019, mar10_2020));
      expect(Period.yearFor(mar11_2020, mar10_2020), PeriodMatcher.year(mar11_2019, mar10_2020));
      expect(Period.yearFor(mar11_2020, mar11_2020), PeriodMatcher.year(mar11_2020, mar10_2021));
      expect(Period.yearFor(mar11_2020, apr11_2020), PeriodMatcher.year(mar11_2020, mar10_2021));
      expect(Period.yearFor(mar11_2020, mar10_2021), PeriodMatcher.year(mar11_2020, mar10_2021));
    });
  });

}
