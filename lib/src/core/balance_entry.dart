import 'denominated_amount.dart';
import 'period.dart';

class BalanceEntry {
  final Period? period;
  final DenominatedAmount denominatedAmount;
  final String account;

  const BalanceEntry({required this.account, required this.denominatedAmount, this.period});

  @override
  String toString() => 'BalanceEntry($account, $denominatedAmount, period: $period)';

  @override
  bool operator ==(Object other) => (other is BalanceEntry) && (other.account == account) && (other.period == period) && (other.denominatedAmount == denominatedAmount);

  @override
  int get hashCode => Object.hash(period, denominatedAmount, account);
}