
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

  bool accountsEqualTo(List<String> otherAccounts) {
    if (otherAccounts.length != accounts.length) return false;
    for (int i = 0; i < accounts.length; i += 1) {
      if (otherAccounts[i] != accounts[i]) return false;
    }
    return true;
  }

  @override
  String toString() => "Query($searchTerm, $startDate, $endDate, $groupBy, ${accounts.length} accounts)";

  @override
  bool operator ==(Object other) => (other is Query) && (searchTerm == other.searchTerm) && (startDate == other.startDate) && (endDate == other.endDate) && (groupBy == other.groupBy) && accountsEqualTo(other.accounts);

  @override
  int get hashCode => Object.hashAll([searchTerm, startDate, endDate, groupBy, ...accounts]);

}
