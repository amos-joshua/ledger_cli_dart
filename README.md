
Parse [ledger-cli](https://ledger-cli.org) ledger files. 

This is a work in progress.

## Usage

The simplest way to parse a ledger file is to pass it to `LedgerFileLoader`, like so:

```dart
final ledgerFileLoader = LedgerFileLoader();
ledgerFileLoader.load('/path/to/ledger/file', onApplyFailure: (edit, exc, stackTrace) {
      print("ERROR: could not apply $edit: $exc\n$stackTrace");
    }).then((ledger) {
      print("Found a ledger with entries: ${ledger.entries} and accounts: ${ledger.accountManager.accounts.values}")
    });
```

Currently only basic parsing of a single file is supported, with very basic queries.

See also [ledger_cli_flutter](https://github.com/amos-joshua/ledger_cli_flutter).