
class CsvFormat {
  final String name;
  final int dateColumnIndex;
  final int descriptionColumnIndex;
  final int amountColumnIndex;

  final String dateFormat;
  final String numberFormat;
  final String locale;
  final int lineSkip;
  final String valueSeparator;
  final String? quoteCharacter;

  const CsvFormat({
    required this.name,
    required this.dateColumnIndex,
    required this.descriptionColumnIndex,
    required this.amountColumnIndex,
    required this.dateFormat,
    required this.numberFormat,
    required this.locale,
    required this.lineSkip,
    required this.valueSeparator,
    required this.quoteCharacter
  });

  @override
  String toString() => 'CsvFormat($name)';

  @override
  bool operator ==(Object other) => (other is CsvFormat) && (other.name == name) && (other.dateColumnIndex == dateColumnIndex) && (other.descriptionColumnIndex == descriptionColumnIndex) && (other.amountColumnIndex == amountColumnIndex)
      && (other.dateFormat == dateFormat) && (other.numberFormat == numberFormat) && (other.locale == locale) && (other.lineSkip == lineSkip) && (other.valueSeparator == valueSeparator) && (other.quoteCharacter == quoteCharacter);

  @override
  int get hashCode => Object.hash(name, dateColumnIndex, descriptionColumnIndex, amountColumnIndex, dateFormat, numberFormat, locale, lineSkip, valueSeparator, quoteCharacter);

}