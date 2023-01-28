import 'entry.dart';

// Convenience class to formats date as 'YYYY/mm/dd`
class LedgerDateFormatter {
  const LedgerDateFormatter();

  // Formats a DateTime as YYYY/mm/dd, always padding the month and day to 2 digits
  String format(DateTime date) => "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
}

// Convenience class to format stats as '* ' or '! ' or ''
class EntryStateFormatter {
  const EntryStateFormatter();

  // Returns either an empty string for uncleared state, or the state's symbol followed by a space for cleared/pending state
  String format(EntryState state) => state == EntryState.uncleared ? "" : "${state.symbolString()} ";
}

// Convenience class to format notes
class EntryNoteFormatter {
  const EntryNoteFormatter();

  // Prefixes all lines with two spaces and a semi-colon
  String format(String note) => note.trim().isEmpty ? "" : """\n${note.split("\n").map((line) => "    ; $line").join("\n")}""";
}