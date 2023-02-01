
import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

final testLedger = Ledger()..entries.addAll([
  Entry(date: DateTime(1999, 02, 01), code: '', payee: 'Opening balances', state: EntryState.cleared, postings: [
    Posting(account: 'Assets:Checking Account', currency: 'USD', amount: 200),
    Posting(account: 'Assets:Credit Card', currency: 'EUR', amount: 0),
  ]),
  Entry(date: DateTime(1999, 02, 02), code: '', payee: 'ABC', state: EntryState.cleared, postings: [
    Posting(account: 'Assets:Checking Account', currency: 'USD', amount: -20),
    Posting(account: 'Expenses:Food', currency: 'USD', amount: 20),
  ]),
  Entry(date: DateTime(1999, 02, 03), code: '', payee: 'DEF', state: EntryState.cleared, postings: [
    Posting(account: 'Assets:Checking Account', currency: 'USD', amount: -80),
    Posting(account: 'Expenses:Music', currency: 'USD', amount: 50),
    Posting(account: 'Expenses:Movies', currency: 'USD', amount: 30),
  ]),
  Entry(date: DateTime(1999, 02, 04), code: '', payee: 'GHI', state: EntryState.cleared, postings: [
    Posting(account: 'Assets:Credit Card', currency: 'EUR', amount: -30),
    Posting(account: 'Expenses:Gas', currency: 'EUR', amount: 30),
  ]),
]);

void main() {
  final queryExecutor = QueryExecutor();

  group('balance queries', () {
    test('query assets', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets']));
      expect(result, BalanceResult(balances: {
        'Assets:Checking Account': DenominatedAmount(100, 'USD'),
        'Assets:Credit Card': DenominatedAmount(-30, 'EUR'),
      }));
    });

    test('query assets with end date', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets'], endDate: DateTime(1999, 02, 02)));
      expect(result, BalanceResult(balances: {
        'Assets:Checking Account': DenominatedAmount(180, 'USD'),
        'Assets:Credit Card': DenominatedAmount(0, 'EUR'),
      }));
    });

    test('query assets with start date', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets'], startDate: DateTime(1999, 02, 02)));
      expect(result, BalanceResult(balances: {
        'Assets:Checking Account': DenominatedAmount(-100, 'USD'),
        'Assets:Credit Card': DenominatedAmount(-30, 'EUR'),
      }));
    });
  });

  group('filter queries', () {
    test('filter by expense accounts', () {
      final entry1 = testLedger.entries[1];
      final entry2 = testLedger.entries[2];
      final entry3 = testLedger.entries[3];
      final result = queryExecutor.queryFilter(testLedger, Query(accounts: ['Expenses']));
      expect(result, PostingFilterResult(matches: [
        InvertedPosting(posting: entry1.postings[1], parent: entry1),
        InvertedPosting(posting: entry2.postings[1], parent: entry2),
        InvertedPosting(posting: entry2.postings[2], parent: entry2),
        InvertedPosting(posting: entry3.postings[1], parent: entry3),
      ]));
    });

    test('filter by payee', () {
      final entry1 = testLedger.entries[1];
      final result = queryExecutor.queryFilter(testLedger, Query(searchTerm: 'AB'));
      expect(result, PostingFilterResult(matches: [
        InvertedPosting(posting: entry1.postings[0], parent: entry1),
        InvertedPosting(posting: entry1.postings[1], parent: entry1),
      ]));
    });
  });

}
