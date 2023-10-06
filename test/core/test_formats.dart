import 'package:ledger_cli/ledger_cli.dart';

const csvFormatBank1 = CsvFormat(name: 'bank1',
    dateColumnIndex: 0,
    descriptionColumnIndex: 3,
    amountColumnIndex: 4,
    dateFormat: "dd/mm/y",
    numberFormat: '###,##',
    locale: 'fr_FR',
    lineSkip: 1,
    valueSeparator: ';',
    quoteCharacter: null);

const csvFormatBank2 = CsvFormat(name: 'bank2',
    dateColumnIndex: 1,
    descriptionColumnIndex: 13,
    amountColumnIndex: 2,
    dateFormat: "dd-mm-y",
    numberFormat: '###.##',
    locale: 'en_US',
    lineSkip: 1,
    valueSeparator: ",",
    quoteCharacter: null);
