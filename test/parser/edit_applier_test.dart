import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';


void main() {
  group('edit applier default', () {
    test('apply basic edits', () async {
      final addAccount1 = LedgerEditAddAccount('Assets:Checking', matchers: []);
      final addAccount2 = LedgerEditAddAccount('Assets:Credit card', matchers: []);
      final addEntry1 = LedgerEditAddEntry(Entry(date: DateTime(2023,01,02), code: '', payee: 'ABC', state: EntryState.cleared, note: '', postings: [
        Posting(account: 'Assets:Checking', currency: r'$', amount: 50.0, note: ''),
        Posting(account: 'Expenses:Music', currency: r'$', amount: -50.0, note: '')
      ]));

      final ledgerEditsStream = Stream<LedgerEdit>.fromIterable([addAccount1, addAccount2, addEntry1]);

      final ledger = Ledger();
      final editReceiver = LedgerEditReceiver.forLedger(ledger, onApplyFailure: (edit, exc, stackTrace) {
        print("ERROR applying edit $edit: $exc\n$stackTrace");
      });
      await editReceiver.receive(ledgerEditsStream);
      expect(ledger.accountManager.accounts, {
        'Assets:Checking': Account(name: 'Assets:Checking'),
        'Assets:Credit card': Account(name: 'Assets:Credit card'),
      });
      expect(ledger.entries, [
        Entry(date: DateTime(2023,01,02), code: '', payee: 'ABC', state: EntryState.cleared, note: '', postings: [
          Posting(account: 'Assets:Checking', currency: r'$', amount: 50.0, note: ''),
          Posting(account: 'Expenses:Music', currency: r'$', amount: -50.0, note: '')
        ])
      ]);
    });
  });
}
