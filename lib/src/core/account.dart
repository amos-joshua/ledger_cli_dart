
import 'package:ledger_cli/ledger_cli.dart';

class Account {
  String name;

  Account({required this.name});

  @override
  String toString() => 'Account($name)';

  @override
  bool operator ==(Object other) => (other is Account) && (name == other.name);

  @override
  int get hashCode => name.hashCode;
}

class AccountManager {
  final accounts = <String, Account>{};

  Account accountNamed(String name) {
    final existingAccount = accounts[name];
    if (existingAccount != null) return existingAccount;
    final newAccount = Account(name: name);
    accounts[name] = newAccount;
    return newAccount;
  }

  void clear() {
    accounts.clear();
  }
}
