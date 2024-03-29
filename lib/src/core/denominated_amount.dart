
// An amount with an associated currency
class DenominatedAmount {
  double amount;
  String currency;
  DenominatedAmount(this.amount, this.currency);

  @override toString() => "${amount.toStringAsFixed(2)}${currency.isEmpty ? '' : ' $currency'}";

  @override
  bool operator ==(Object other) => (other is DenominatedAmount) && (amount == other.amount) && (currency == other.currency);

  @override
  int get hashCode => Object.hash(amount, currency);
}

class CurrencyMismatch implements Exception {
  final String message;
  const CurrencyMismatch(this.message);

  @override
  String toString() => 'CurrencyMismatch($message)';
}