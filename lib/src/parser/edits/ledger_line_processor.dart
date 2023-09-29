import 'dart:async';
import 'package:ledger_cli/src/parser/edits/edits.dart';

import '../../core/core.dart';
import '../ledger_lines/ledger_line.dart';

// A class that "processes" a stream of LedgerLines into a stream of LedgerEdits.
//
// Currently implemented as a state machine that builds up each entry separately,
// throwing an error if the next line received does not make sense for the
// currently-built-up entry.
// see also LedgerLineToEditsTransformer
class LedgerLineProcessor {
  final knownAccounts = <String>[];
  final LedgerLineStreamProvider streamForIncludedFileCallback;

  LedgerLineProcessor({List<String> knownAccounts = const [], required this.streamForIncludedFileCallback}) {
    this.knownAccounts.addAll(knownAccounts);
  }

  Entry? _currentEntry;
  final List<PostingLine> _currentPostingLines = [];
  PostingLine? _currentPostingLine;
  var lineNumber = 0;

  void initialize() {
    _currentEntry = null;
    _currentPostingLine = null;
  }

  LedgerEdit? finalize() {
    final currentEntry = _currentEntry;
    final currentPostingLine = _currentPostingLine;
    if (currentEntry != null) {
      if (currentPostingLine != null) {
        _currentPostingLines.add(currentPostingLine);
        _currentPostingLine = null;
      }
      final editAddEntry = editEntryForCurrentEntry(currentEntry);
      return editAddEntry;
    }
    return null;
  }

  Stream<LedgerEdit> processLineWithIncludes(LedgerLine line) async* {
    try {
      if (line is IncludeLine) {
        // When an include line is encountered, request the associated stream
        // and yield each line
        final includedStream = await streamForIncludedFileCallback(line.path);
        await for (final line2 in includedStream) {
          yield* processLineWithIncludes(line2);
        }
      }
      else {
        // If it's not an include line, just process the line
        yield* processLine(line);
      }
    }
    catch (exc, stackTrace) {
      yield* Stream.error(exc, stackTrace);
    }
  }

  Stream<LedgerEdit> processLine(LedgerLine line) async* {
    lineNumber += 1;
    final currentEntry = _currentEntry;
    if (currentEntry == null) {
      if (line is NoteLine) {
        return;
      } else if (line is PostingLine) {
        throw Exception("Unexpected posting line at $lineNumber, not associated to an Entry");
      } else if (line is EntryLine) {
        _currentEntry = Entry(date: line.date, code: line.code, payee: line.payee, state: line.state, postings: [], note: line.note);
        _currentPostingLine = null;
      }
      else if (line is AccountLine) {
        if (!knownAccounts.contains(line.name)) {
          knownAccounts.add(line.name);
          yield LedgerEditAddAccount(line.name);
        }
      }
    }
    else {
      final currentPostingLine = _currentPostingLine;
      if (currentPostingLine == null) {
        if (line is NoteLine) {
          currentEntry.note += ' ${line.note}';
        }
        else if (line is EntryLine) {
          throw Exception("Unexpected entry at line $lineNumber, the previous entry is not fully defined (it has no postings)");
        }
        else if (line is AccountLine) {
          throw Exception("Unexpected account at line $lineNumber, the previous entry is not fully defined (it has no postings)");
        }
        else if (line is PostingLine) {
          if (!knownAccounts.contains(line.account)) {
            knownAccounts.add(line.account);
            yield LedgerEditAddAccount(line.account);
          }
          _currentPostingLine = line;
        }
      }
      else {
        if (line is NoteLine) {
          currentPostingLine.note += ' ${line.note}';
        }
        else if (line is PostingLine) {
          if (!knownAccounts.contains(line.account)) {
            knownAccounts.add(line.account);
            yield LedgerEditAddAccount(line.account);
          }
          _currentPostingLines.add(currentPostingLine);
          _currentPostingLine = line;
        }
        else if (line is EntryLine) {
          _currentPostingLines.add(currentPostingLine);
          yield editEntryForCurrentEntry(currentEntry);
          _currentEntry = Entry(date: line.date, code: line.code, payee: line.payee, state: line.state, postings: [], note: line.note);
        }
        else if (line is AccountLine) {
          if (!knownAccounts.contains(line.name)) {
            knownAccounts.add(line.name);
            yield LedgerEditAddAccount(line.name);
          }
          yield editEntryForCurrentEntry(currentEntry);
        }
      }
    }
  }

  LedgerEditAddEntry editEntryForCurrentEntry(Entry currentEntry) {
    final postingLinesWithNoAmount = _currentPostingLines.where((postingLine) => postingLine.amount == null);
    final postingWithAmount = _currentPostingLines.where((postingLine) => postingLine.amount != null);
    if (postingLinesWithNoAmount.length > 1) {
      throw Exception("Error at line $lineNumber: cannot add entry defined in previous lines, it contains more than one posting without an amount:\n${postingLinesWithNoAmount.join("\n")}");
    }
    else if (postingLinesWithNoAmount.length == 1) {
      if (postingWithAmount.isEmpty) throw Exception("Error at line $lineNumber: cannot add entry defined in previous lines, it contains a single posting with no amount defined");
      postingLinesWithNoAmount.first.currency = postingWithAmount.first.currency;
      postingLinesWithNoAmount.first.amount = _currentPostingLines.fold<double>(0.0, (previousValue, postingLine) => previousValue - (postingLine.amount ?? 0));
    }
    final postings = _currentPostingLines.map((postingLine) => Posting(account: postingLine.account, currency: postingLine.currency, amount: postingLine.amount ?? 0, note: postingLine.note));
    currentEntry.postings.addAll(postings);
    _currentEntry = null;
    _currentPostingLine = null;
    _currentPostingLines.clear();
    return LedgerEditAddEntry(currentEntry);
  }
}