


enum TransactionStatus {
  uncleared, pending, cleared
}

class Transaction {
  DateTime date;
  String code;
  String description;
  String account;
  String currency;
  double amount;
  TransactionStatus status;
  String notes;
  Transaction({required this.date, required this.code, required this.description, required this.account, required this.currency, required this.amount, required this.status, this.notes=""});

  @override
  String toString() => "Transaction(date: $date, code: $code, description: $description, account: $account, currency: $currency, amount: $amount, status: $status, notes: $notes)}";

  @override
  bool operator ==(Object other) => (other is Transaction) &&
        (date == other.date) &&
        (code == other.code) &&
        (description == other.description) &&
        (account == other.account) &&
        (currency == other.currency) &&
        (amount == other.amount) &&
        (status == other.status) &&
        (notes == other.notes);

  @override
  int get hashCode => Object.hash(date, code, description, account, currency, amount, status, notes);

}

