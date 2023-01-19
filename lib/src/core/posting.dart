
class Posting {
  String account;
  String currency;
  double amount;
  String note;
  Posting({required this.account, required this.currency, required this.amount, this.note=""});

  @override
  String toString() => "Posting(account: $account, currency: $currency, amount: $amount, notes: $note)";

  @override
  bool operator ==(Object other) => (other is Posting) &&
      (account == other.account) &&
      (currency == other.currency) &&
      (amount == other.amount) &&
      (note == other.note);

  @override
  int get hashCode => Object.hash(account, currency, amount, note);
}