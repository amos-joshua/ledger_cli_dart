import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

/*
final sampleDatTransactions = [
  Transaction(date: DateTime.parse("2004-05-01 00:00:00.000"),
      code: '',
      description: "Checking balance",
      account: "Assets:Bank:Checking",
      currency: r"$",
      amount: 1000.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-01 00:00:00.000"),
      code: '',
      description: "Checking balance",
      account: "Equity:Opening Balances",
      currency: r"$",
      amount: -1000.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-03 00:00:00.000"),
      code: '',
      description: "Investment balance",
      account: "Assets:Brokerage",
      currency: "AAPL",
      amount: 50.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-03 00:00:00.000"),
      code: '',
      description: "Investment balance",
      account: "Equity:Opening Balances",
      currency: r"$",
      amount: -1500.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-14 00:00:00.000"),
      code: '',
      description: "Páy dày",
      account: "Assets:Bank:Checking",
      currency: "€",
      amount: 500.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-14 00:00:00.000"),
      code: '',
      description: "Páy dày",
      account: "Income:Salary",
      currency: "€",
      amount: -500.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-14 00:00:00.000"),
      code: '',
      description: "Another dày in which there is Páying",
      account: "Asséts:Bánk:Chécking:Asséts:Bánk:Chécking",
      currency: r"$",
      amount: 500.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-14 00:00:00.000"),
      code: '',
      description: "Another dày in which there is Páying",
      account: "Income:Salary",
      currency: r"$",
      amount: -500.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-14 00:00:00.000"),
      code: '',
      description: "Another dày in which there is Páying",
      account: "Русский язык:Активы:Русский язык:Русский язык",
      currency: r"$",
      amount: 1000.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-14 00:00:00.000"),
      code: '',
      description: "Another dày in which there is Páying",
      account: "Income:Salary",
      currency: r"$",
      amount: -1000.0,
      state: TransactionStatus.cleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-27 00:00:00.000"),
      code: '',
      description: "Book Store",
      account: "Expenses:Books",
      currency: r"$",
      amount: 20.0,
      state: TransactionStatus.uncleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-27 00:00:00.000"),
      code: '',
      description: "Book Store",
      account: "Expenses:Cards",
      currency: r"$",
      amount: 40.0,
      state: TransactionStatus.uncleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-27 00:00:00.000"),
      code: '',
      description: "Book Store",
      account: "Expenses:Docs",
      currency: r"$",
      amount: 30.0,
      state: TransactionStatus.uncleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-27 00:00:00.000"),
      code: '',
      description: "Book Store",
      account: "Liabilities:MasterCard",
      currency: r"$",
      amount: -90.0,
      state: TransactionStatus.uncleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-27 00:00:00.000"),
      code: '',
      description: "Book Store",
      account: "(Liabilities:Taxes)",
      currency: r"$",
      amount: -2.0,
      state: TransactionStatus.uncleared,
      notes: ""),
  Transaction(date: DateTime.parse("2004-05-27 00:00:00.000"),
      code: '100',
      description: "Credit card company",
      account: "Liabilities:MasterCard",
      currency: r"$",
      amount: 20.0,
      state: TransactionStatus.uncleared,
      notes: r" This is a posting note!\n Sample: Another Value\n :MyTag: This is an xact note!\n Sample: Value"),
  Transaction(date: DateTime.parse("2004-05-27 00:00:00.000"),
      code: '100',
      description: "Credit card company",
      account: "Assets:Bank:Checking",
      currency: r"$",
      amount: -20.0,
      state: TransactionStatus.uncleared,
      notes: r" :AnotherTag: This is an xact note!\n Sample: Value")
];

void main() {
  group('ledger cli wrapper', () {
    test('csv data with empty query', () async {
      final ledger = LedgerCliWrapper.forLedger(ledgerBinary: '/usr/bin/ledger', ledgerFile: 'test/sample.dat');
      final Stream<Transaction> transactionStream = await ledger.query(Query());
      final transactions = await transactionStream.toList();
      expect(transactions, sampleDatTransactions);
    });

    test('csv data with accounts', () async {
      final ledger = LedgerCliWrapper.forLedger(ledgerBinary: '/usr/bin/ledger', ledgerFile: 'test/sample.dat');
      final query = Query(accounts: ["Expenses"]);
      final Stream<Transaction> transactionStream = await ledger.query(query);
      final transactions = await transactionStream.toList();
      expect(transactions, [sampleDatTransactions[10], sampleDatTransactions[11], sampleDatTransactions[12]]);
    });

    test('csv data with date range', () async {
      final ledger = LedgerCliWrapper.forLedger(ledgerBinary: '/usr/bin/ledger', ledgerFile: 'test/sample.dat');
      final query = Query(startDate: DateTime(2004, 5, 1), endDate: DateTime(2004, 5, 2));
      final Stream<Transaction> transactionStream = await ledger.query(query);
      final transactions = await transactionStream.toList();
      expect(transactions, [sampleDatTransactions[0], sampleDatTransactions[1]]);
    });
  });
}


 */