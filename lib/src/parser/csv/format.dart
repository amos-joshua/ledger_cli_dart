
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

final csvFormatBnp = CsvFormat(name: 'bnp',
    dateColumnIndex: 0,
    descriptionColumnIndex: 3,
    amountColumnIndex: 4,
    dateFormat: "dd/mm/y",
    numberFormat: '###,##',
    locale: 'fr_FR',
    lineSkip: 1,
    valueSeparator: ';',
    quoteCharacter: null);

final csvFormatWise = CsvFormat(name: 'wise',
    dateColumnIndex: 1,
    descriptionColumnIndex: 13,
    amountColumnIndex: 2,
    dateFormat: "dd-mm-y",
    numberFormat: '###.##',
    locale: 'en_US',
    lineSkip: 1,
    valueSeparator: ",",
    quoteCharacter: null);

final csvFormatBankOfAmerica = CsvFormat(name: 'bank-of-america',
    dateColumnIndex: 0,
    descriptionColumnIndex: 1,
    amountColumnIndex: 2,
    dateFormat: 'mm/dd/YY',
    numberFormat: '###.##',
    locale: 'en_US',
    lineSkip: 8,
    valueSeparator: ',',
    quoteCharacter: '"');

final csvFormatUsBank = CsvFormat(name: 'usbank',
    dateColumnIndex: 0,
    descriptionColumnIndex: 2,
    amountColumnIndex: 4,
    dateFormat: 'mm/dd/YY',
    numberFormat: '###.##',
    locale: 'en_US',
    lineSkip: 1,
    valueSeparator: ',',
    quoteCharacter: '"');

final csvFormatChase = CsvFormat(name: 'chase',
    dateColumnIndex: 0,
    descriptionColumnIndex: 2,
    amountColumnIndex: 5,
    dateFormat: 'mm/dd/YY',
    numberFormat: '###.##',
    locale: 'en_US',
    lineSkip: 1,
    valueSeparator: ',',
    quoteCharacter: null);