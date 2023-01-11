


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
}

