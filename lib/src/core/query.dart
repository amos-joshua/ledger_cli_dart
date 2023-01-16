

enum LedgerPeriod {
  daily, weekly, monthly, yearly, always
}

extension LedgerPeriodFunctions on LedgerPeriod {
  String label() => toString().replaceFirst("LedgerPeriods.", "").toUpperCase();
  String ledgerDuration() => this == LedgerPeriod.daily ? "every 1 days" :
      this == LedgerPeriod.weekly ? "ever 1 weeks" :
      this == LedgerPeriod.monthly ? "every 1 months" :
      this == LedgerPeriod.yearly ? "every 1 years" : "every 999 years";

}

class Query {
  List<String> accounts;
  DateTime? startDate;
  DateTime? endDate;
  LedgerPeriod? period;
  Query({this.accounts = const [], this.startDate, this.endDate, this.period});
}

class QueryArgumentFormatter {
  const QueryArgumentFormatter();

  String _formatDate(DateTime date) => "${date.year}/${date.month}/${date.day}";
  
  List<String> asList(Query query) {
    final args = <String>[if (query.accounts.isNotEmpty) query.accounts.join(" ")]; //, "--sort date"];
    final startDate = query.startDate;
    final endDate = query.endDate;
    final period = query.period;
    if (startDate != null) args.addAll(["--begin", _formatDate(startDate)]);
    if (endDate != null) args.addAll(["--end", _formatDate(endDate)]);
    if (period != null) args.addAll(["--period", period.ledgerDuration()]);
    return args;
  }
}