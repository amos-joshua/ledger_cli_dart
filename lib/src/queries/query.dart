
import './../core/period.dart';

class Query {
  List<String> accounts;
  String searchTerm;
  DateTime? startDate;
  DateTime? endDate;
  PeriodLength? groupBy;
  Query({this.accounts = const [], this.searchTerm = '', this.startDate, this.endDate, this.groupBy});

  Query modify({List<String>? accounts, String? searchTerm}) {
    return Query(
      accounts: accounts ?? this.accounts,
      searchTerm: searchTerm ?? this.searchTerm,
      startDate: startDate,
      endDate: endDate,
      groupBy: groupBy
    );
  }

}
