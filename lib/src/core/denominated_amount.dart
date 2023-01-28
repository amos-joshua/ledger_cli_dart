
// An amount with an associated currency
class DenominatedAmount {
  double amount;
  String currency;
  DenominatedAmount(this.amount, this.currency);

  @override toString() => "$amount${currency.isEmpty ? '' : ' $currency}'}";

  @override
  bool operator ==(Object other) => (other is DenominatedAmount) && (amount == other.amount) && (currency == other.currency);

  @override
  int get hashCode => Object.hash(amount, currency);
}