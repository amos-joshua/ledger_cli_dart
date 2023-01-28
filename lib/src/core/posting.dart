
import 'package:ledger_cli/src/core/denominated_amount.dart';

// A posting in a ledger
class Posting {
  String account;
  String currency;
  double amount;
  String note;
  Posting({required this.account, required this.currency, required this.amount, this.note=""});

  DenominatedAmount get denominatedAmount => DenominatedAmount(amount, currency);

  @override
  String toString() => "Posting(account: $account, currency: $currency, amount: $amount, note: $note)";

  @override
  bool operator ==(Object other) => (other is Posting) &&
      (account == other.account) &&
      (currency == other.currency) &&
      (amount == other.amount) &&
      (note == other.note);

  @override
  int get hashCode => Object.hash(account, currency, amount, note);
}
