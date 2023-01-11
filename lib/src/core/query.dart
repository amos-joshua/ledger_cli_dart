

class Query {
  List<String> accounts;
  DateTime? startDate;
  DateTime? endDate;
  Duration? period;
  Query({this.accounts = const [], this.startDate, this.endDate, this.period});
}