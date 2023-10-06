
import 'csv_format.dart';

class ImportAccount {
  final String label;
  final String sourceAccount;
  final String currency;
  final CsvFormat csvFormat;
  final String defaultDestinationAccount;
  const ImportAccount({required this.label, required this.sourceAccount, required this.currency, required this.csvFormat, required this.defaultDestinationAccount});

  @override
  String toString() => 'ImportAccount(label: $label, sourceAccount: $sourceAccount, currency: $currency, csvFormat: $csvFormat, defaultDestinationAccount: $defaultDestinationAccount)';

  @override
  bool operator ==(Object other) {
    return (other is ImportAccount) && (other.label == label) && (other.sourceAccount == sourceAccount) && (other.currency == currency) && (other.csvFormat == csvFormat) && (defaultDestinationAccount == defaultDestinationAccount);
  }

  @override
  int get hashCode => Object.hash(label, sourceAccount, currency, csvFormat, defaultDestinationAccount);
}