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
  LedgerLineProcessor({List<String> knownAccounts = const []}) {
    this.knownAccounts.addAll(knownAccounts);
  }

  Entry? _currentEntry;
  final List<PostingLine> _currentPostingLines = [];
  PostingLine? _currentPostingLine;
  var lineNumber = 0;

  Stream<LedgerEdit> process({required Stream<LedgerLine> lineStream}) async* {
    initialize();
    await for (final line in lineStream) {
      yield* processLine(line);
    }
    final lastEdit = finalize();
    if (lastEdit != null) {
      yield lastEdit;
    }
  }

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
  
  Stream<LedgerEdit> processLine(LedgerLine line) async* {
    lineNumber += 1;
    final currentEntry = _currentEntry;
    if (line is IncludeLine) {
      print("ignoring include line for [${line.path}]");
      return;
    }
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