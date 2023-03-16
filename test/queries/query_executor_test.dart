
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
  Entry(date: DateTime(1999, 04, 03), code: '', payee: 'ABEX', state: EntryState.cleared, postings: [
    Posting(account: 'Assets:Checking Account', currency: 'USD', amount: -10),
    Posting(account: 'Expenses:Music', currency: 'USD', amount: 10),
  ]),
  Entry(date: DateTime(1999, 04, 07), code: '', payee: 'XYZ', state: EntryState.cleared, postings: [
    Posting(account: 'Assets:Checking Account', currency: 'USD', amount: -20),
    Posting(account: 'Expenses:Music', currency: 'USD', amount: 20),
  ]),
]);

void main() {
  final queryExecutor = QueryExecutor();

  group('balance queries', () {
    test('query assets', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets']));
      expect(result, BalanceResult(
        balances: [
          BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(70, 'USD')),
          BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-30, 'EUR'))
        ]
      ));
    });

    test('query assets with end date', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets'], endDate: DateTime(1999, 02, 02)));
      expect(result, BalanceResult(
          balances: [
          BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(180, 'USD')),
          BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(0, 'EUR'))
        ]
      ));
    });

    test('query assets with start date', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets'], startDate: DateTime(1999, 02, 02)));
      expect(result, BalanceResult(
          balances: [
            BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(-130, 'USD')),
            BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-30, 'EUR'))
          ]
      ));
    });

    test('query assets with monthly period', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets'], startDate: DateTime(1999, 02, 02)));
      expect(result, BalanceResult(
          balances: [
            BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(-130, 'USD')),
            BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-30, 'EUR'))
          ]
      ));
    });
  });

  group('filter queries', () {
    final entry1 = testLedger.entries[1];
    final entry2 = testLedger.entries[2];
    final entry3 = testLedger.entries[3];
    final entry4 = testLedger.entries[4];
    final entry5 = testLedger.entries[5];

    test('filter by expense accounts', () {

      final result = queryExecutor.queryFilter(testLedger, Query(accounts: ['Expenses']));
      expect(result, PostingFilterResult(matches: [
        InvertedPosting(posting: entry1.postings[1], parent: entry1),
        InvertedPosting(posting: entry2.postings[1], parent: entry2),
        InvertedPosting(posting: entry2.postings[2], parent: entry2),
        InvertedPosting(posting: entry3.postings[1], parent: entry3),
        InvertedPosting(posting: entry4.postings[1], parent: entry4),
        InvertedPosting(posting: entry5.postings[1], parent: entry5),
      ]));
    });

    test('filter by payee', () {
      final result = queryExecutor.queryFilter(testLedger, Query(searchTerm: 'AB'));
      expect(result.matches,  [
        InvertedPosting(posting: entry1.postings[0], parent: entry1),
        InvertedPosting(posting: entry1.postings[1], parent: entry1),
        InvertedPosting(posting: entry4.postings[0], parent: entry4),
        InvertedPosting(posting: entry4.postings[1], parent: entry4),
      ]);
    });
  });

}
