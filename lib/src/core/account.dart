
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

// Manages a list of accounts
class AccountManager {
  final accounts = <String, Account>{};

  // Returns an account with the given name, adding it if necessary
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
