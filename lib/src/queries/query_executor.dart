
import '../core/core.dart';
import 'results/balance_result.dart';
import 'results/entry_filter_result.dart';
import 'query.dart';

class QueryExecutor {
  const QueryExecutor();

  bool postingMatches(Posting posting, Query query, DateTime date, String payee) {
    if (query.accounts.isNotEmpty && !query.accounts.any((queryAccount) => posting.account.toLowerCase().startsWith(queryAccount.toLowerCase()))) return false;
    if (query.searchTerm.isNotEmpty && !payee.contains(query.searchTerm.toLowerCase())) return false;
    final startDate = query.startDate;
    if ((startDate != null) && (startDate.isAfter(date))) return false;
    final endDate = query.endDate;
    if ((endDate != null) && (endDate.isBefore(date))) return false;
    return true;
  }

  Iterable<Entry> entriesMatching(Ledger ledger, Query query) {
    return ledger.entries.where((entry) => entry.postings.any((posting) => postingMatches(posting, query, entry.date, entry.payee.toLowerCase())));
  }

  BalanceResult queryBalance(Ledger ledger, Query query) {
    final matches = entriesMatching(ledger, query);
    final resultBuilder = BalanceResultsBuilder(startDate: query.startDate, periodLength: query.groupBy);
    for (final entry in matches) {
      final postings = entry.postings.where((posting) => postingMatches(posting, query, entry.date, entry.payee.toLowerCase()));
      final uniqueAccounts = [];
      for (final posting in postings) {
        if (uniqueAccounts.contains(posting.account)) continue;
        final denominatedAmount = entry.amountForAccount(posting.account);
        resultBuilder.add(posting.account, entry.date, denominatedAmount);
        uniqueAccounts.add(posting.account);
      }
    }
    return resultBuilder.build();
  }

  EntryFilterResult queryFilter(Ledger ledger, Query query) {
    final matches = entriesMatching(ledger, query);
    return EntryFilterResult(matches: matches.toList(growable: false));
  }
}