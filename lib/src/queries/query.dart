

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
  String searchTerm;
  DateTime? startDate;
  DateTime? endDate;
  Query({this.accounts = const [], this.searchTerm = '', this.startDate, this.endDate});

  Query modify({List<String>? accounts, String? searchTerm, DateTime? startDate, DateTime? endDate}) {
    return Query(
      accounts: accounts ?? this.accounts,
      searchTerm: searchTerm ?? this.searchTerm,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate
    );
  }
}
