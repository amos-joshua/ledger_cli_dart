import 'entry.dart';
import 'denominated_amount.dart';
/*
class EntryCollection {
  final List<Entry> entries = [];
  EntryCollection();

  // TODO: test
  DenominatedAmount sumForAccount(String account) {
    return entries.fold(DenominatedAmount(0, ''), (denominatedAmount, entry) {
      final entryDenominatedAmount = entry.amountForAccount(account);
      if (denominatedAmount.currency.isEmpty) {
        denominatedAmount.currency = entryDenominatedAmount.currency;
      }
      denominatedAmount.amount += entryDenominatedAmount.amount;
      return denominatedAmount;
    });
  }
}*/