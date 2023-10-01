
Parse [ledger-cli](https://ledger-cli.org) ledger files. 

This is a work in progress.

## Usage

The simplest way to parse a ledger file is to pass it to `LedgerLoader`, like so:

```dart
final source = LedgerSource.forFile('/path/to/ledger/file');
final ledger = await ledgerFileLoader.load(source, onApplyFailure: (edit, exc, stackTrace) {
  print("ERROR: could not apply $edit: $exc\n$stackTrace");
});
print("Found a ledger with entries: ${ledger.entries} and accounts: ${ledger.accountManager.accounts.values}");
```

Currently only basic parsing of a single file is supported, with simple queries.

See also [ledger_cli_flutter](https://github.com/amos-joshua/ledger_cli_flutter).