import 'package:ledger_cli/src/queries/inverted_posting.dart';

import '../core/core.dart';
import 'query.dart';
import 'query_result.dart';

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

  Iterable<InvertedPosting> postingsMatching(Ledger ledger, Query query) {
    return ledger.entries.expand((entry) => entry.postings.where((posting) => postingMatches(posting, query, entry.date, entry.payee.toLowerCase())).map((posting) => InvertedPosting(posting:posting, parent:entry)));
  }

  BalanceResult queryBalance(Ledger ledger, Query query) {
    final matches = postingsMatching(ledger, query);
    final result = BalanceResult(balances: {});
    for (final invertedPosting in matches) {
      result.add(invertedPosting.posting.account, invertedPosting.posting.denominatedAmount);
    }
    return result;
  }

  PostingFilterResult queryFilter(Ledger ledger, Query query) {
    final matches = postingsMatching(ledger, query);
    return PostingFilterResult(matches: matches.toList(growable: false));
  }
}