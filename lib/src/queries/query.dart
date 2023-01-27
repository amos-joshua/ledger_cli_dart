

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

abstract class Query {
  List<String> accounts;
  DateTime? startDate;
  DateTime? endDate;
  Query({this.accounts = const [], this.startDate, this.endDate});
}

class BalanceQuery extends Query {
  BalanceQuery({super.accounts, super.startDate, super.endDate});
}

class PostingFilterQuery extends Query {
  PostingFilterQuery({super.accounts, super.startDate, super.endDate});
}
