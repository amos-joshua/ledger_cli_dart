

class Query {
  List<String> accounts;
  DateTime? startDate;
  DateTime? endDate;
  Duration? period;
  Query({this.accounts = const [], this.startDate, this.endDate, this.period});
}

class QueryArgumentFormatter {
  const QueryArgumentFormatter();

  String _formatDate(DateTime date) => "${date.year}/${date.month}/${date.day}";
  
  List<String> asList(Query query) {
    final args = <String>[query.accounts.join(" ")]; //, "--sort date"];
    final startDate = query.startDate;
    final endDate = query.endDate;
    final period = query.endDate;
    if (startDate != null) args.add("--begin ${_formatDate(startDate)}");
    if (endDate != null) args.add("--end ${_formatDate(endDate)}");
    if (period != null) args.add("--period $period");
    return args;
  }
}