import 'entry.dart';

class LedgerDateFormatter {
  const LedgerDateFormatter();

  // Formats a DateTime as YYYY/mm/dd, always padding the month and day to 2 digits
  String format(DateTime date) => "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
}

class EntryStateFormatter {
  const EntryStateFormatter();

  // Returns either an empty string for uncleared state, or the state's symbol followed by a space for cleared/pending state
  String format(EntryState state) => state == EntryState.uncleared ? "" : "${state.symbolString()} ";
}

class EntryNoteFormatter {
  const EntryNoteFormatter();

  // Prefixes all lines with two spaces and a semi-colon
  String format(String note) => note.trim().isEmpty ? "" : """\n${note.split("\n").map((line) => "    ; $line").join("\n")}""";
}