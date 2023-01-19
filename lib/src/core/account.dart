
class LedgerAccount {
  String name;

  LedgerAccount({required this.name});
}

class LedgerAccountRegistry {
  final accounts = <String, LedgerAccount>{};

  LedgerAccount accountNamed(String name) {
    final existingAccount = accounts[name];
    if (existingAccount != null) return existingAccount;
    final newAccount = LedgerAccount(name: name);
    accounts[name] = newAccount;
    return newAccount;
  }
}
