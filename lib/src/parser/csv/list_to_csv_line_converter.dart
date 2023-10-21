import 'package:intl/intl.dart';

import '../../core/core.dart';
import 'csv_line.dart';

class ListToCsvLineConverter {
  final CsvFormat csvFormat;

  const ListToCsvLineConverter({required this.csvFormat});

  Stream<CsvLine> convert(Stream<List<dynamic>> listStream) async* {
    final dateFormat = DateFormat(csvFormat.dateFormat);
    final numberFormat = NumberFormat(csvFormat.numberFormat, csvFormat.locale);
    var lineNumber = 0;
    var linesSkipped = 0;

    await for (final data in listStream) {
      try {
        lineNumber += 1;
        if (linesSkipped < csvFormat.lineSkip) {
          linesSkipped += 1;
          continue;
        }
        final dateString = data[csvFormat.dateColumnIndex];
        final description = data[csvFormat.descriptionColumnIndex];
        final amountObj = data[csvFormat.amountColumnIndex];
        double amount = 0.0;

        if (dateString is! String) {
          throw Exception("Error parsing line #$lineNumber [$data]: expected value at index ${csvFormat.dateColumnIndex} to be a string but got [$dateString] which is a [${dateString.runtimeType}] instead");
        }
        if (description is! String) {
          throw Exception("Error parsing line #$lineNumber [$data]: expected value at index ${csvFormat.descriptionColumnIndex} to be a string but got [$description] which is a [${description.runtimeType}] instead");
        }

        if (amountObj is num) {
          amount = amountObj.toDouble();
        }
        else {
          try {
            //final spaceLessString = amountObj.toString().replaceAll(' ', '');
            final parsedDouble = numberFormat.parse(amountObj);
            amount = parsedDouble.toDouble();
          }
          catch (exc){
            throw Exception("Error parsing line #$lineNumber [$data]: expected value at index ${csvFormat.amountColumnIndex} to be a double but got [$amountObj] which is a [${amountObj.runtimeType}] and failed to parse as a double with error: $exc");
          }
        }

        final date = dateFormat.parse(dateString);
        final csvLine = CsvLine(date: date, description: description, amount: amount);
        yield csvLine;
      }
      catch (exc, stackTrace) {
        throw "Error parsing line #$lineNumber: $exc\n$stackTrace";
      }
    }
  }
}