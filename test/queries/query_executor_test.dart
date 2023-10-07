
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
  Entry(date: DateTime(2000, 01, 04), code:'', payee: 'UVW', state: EntryState.cleared, postings: [
    Posting(account: 'Assets:Credit Card', currency: 'EUR', amount: -5),
    Posting(account: 'Expenses:Food', currency: 'EUR', amount: 5),
  ])
]);

void main() {
  final queryExecutor = QueryExecutor();

  group('balance queries', () {
    test('query assets', () {
      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets']));
      expect(result, BalanceResult(
        balances: [
          BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(70, 'USD')),
          BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-35, 'EUR'))
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
            BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-35, 'EUR'))
          ]
      ));
    });

    test('query assets with monthly period', () {
      final feb1_1999 = DateTime(1999, 02, 01);
      final apr1_1999 = DateTime(1999, 04, 01);
      final jan4_2000 = DateTime(2000, 01, 04);
      final feb_1999 = Period.monthFor(feb1_1999, feb1_1999);
      final apr_1999 = Period.monthFor(feb1_1999, apr1_1999);
      final jan_2000 = Period.monthFor(feb1_1999, jan4_2000);

      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets'], startDate: feb1_1999, groupBy: PeriodLength.month));
      expect(result.balances, [
        BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-5, 'EUR'), period: jan_2000),
        BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(-30, 'USD'), period: apr_1999),
        BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-30, 'EUR'), period: feb_1999),
        BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(100, 'USD'), period: feb_1999)
      ]
      );
    });

    test('query assets with yearly period', () {
      final jan1_1999 = DateTime(1999, 01, 01);
      final jan1_2000 = DateTime(2000, 01, 01);
      //final jan4_2000 = DateTime(2000, 01, 04);
      final year_1999 = Period.yearFor(jan1_1999, jan1_1999);
      final year_2000 = Period.yearFor(jan1_1999, jan1_2000);

      final result = queryExecutor.queryBalance(testLedger, Query(accounts: ['Assets'], startDate: jan1_1999, groupBy: PeriodLength.year));
      expect(result.balances, [
        BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-5, 'EUR'), period: year_2000),
        BalanceEntry(account: 'Assets:Credit Card', denominatedAmount: DenominatedAmount(-30, 'EUR'), period: year_1999),
        BalanceEntry(account: 'Assets:Checking Account', denominatedAmount: DenominatedAmount(70, 'USD'), period: year_1999),
      ]
      );
    });
  });

  group('filter queries', () {
    final entry1 = testLedger.entries[1];
    final entry2 = testLedger.entries[2];
    final entry3 = testLedger.entries[3];
    final entry4 = testLedger.entries[4];
    final entry5 = testLedger.entries[5];
    final entry6 = testLedger.entries[6];


    test('filter by expense accounts', () {
      final result = queryExecutor.queryFilter(testLedger, Query(accounts: ['Expenses']));
      expect(result, EntryFilterResult(matches: [
        entry1,
        entry2,
        entry3,
        entry4,
        entry5,
        entry6
      ]));
    });

    test('filter by payee', () {
      final result = queryExecutor.queryFilter(testLedger, Query(searchTerm: 'AB'));
      expect(result.matches,  [
        entry1, entry4
      ]);
    });
  });

}
