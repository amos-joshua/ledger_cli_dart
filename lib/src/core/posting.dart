import 'account.dart';

class Posting {
  Account account;
  String currency;
  double amount;
  String notes;
  Posting({required this.account, required this.currency, required this.amount, this.notes=""});

  @override
  String toString() => "Posting(account: $account, currency: $currency, amount: $amount, notes: $notes)";

  @override
  bool operator ==(Object other) => (other is Posting) &&
      (account == other.account) &&
      (currency == other.currency) &&
      (amount == other.amount) &&
      (notes == other.notes);

  @override
  int get hashCode => Object.hash(account, currency, amount, notes);
}