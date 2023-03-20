
class Account {
  String name;
  final matchers = <String>[];

  Account({required this.name});

  bool matches(String description) => matchers.any((matcher) => description.contains(matcher));

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

  Account? accountMatching(String description) {
    final lowercaseDescription = description.toLowerCase();
    return accounts.values.cast<Account?>().firstWhere((account) => account?.matches(lowercaseDescription) == true, orElse: () => null);
  } 

  void clear() {
    accounts.clear();
  }
}
