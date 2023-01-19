import 'dart:async';
import 'package:ledger_cli/src/parser/edits/edits.dart';

import '../../core/core.dart';
import '../lines/ledger_line.dart';

class LedgerLineProcessor {
  final knownAccounts = <String>[];
  LedgerLineProcessor({List<String> knownAccounts = const []}) {
    this.knownAccounts.addAll(knownAccounts);
  }

  Entry? _currentEntry;
  Posting? _currentPosting;
  var lineNumber = 0;

  Stream<LedgerEdit> process({required Stream<LedgerLine> lineStream}) async* {
    initialize();
    await for (final line in lineStream) {
      yield* processLine(line);
    }
  }

  void initialize() {
    _currentEntry = null;
    _currentPosting = null;
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
        _currentPosting = null;
      }
      else if (line is AccountLine) {
        if (!knownAccounts.contains(line.name)) {
          knownAccounts.add(line.name);
          yield LedgerEditAddAccount(line.name);
        }
      }
    }
    else {
      final currentPosting = _currentPosting;
      if (currentPosting == null) {
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
          _currentPosting = Posting(account: line.account, currency: line.currency, amount: line.amount, note: line.note);
        }
      }
      else {
        if (line is NoteLine) {
          currentPosting.note += ' ${line.note}';
        }
        else if (line is PostingLine) {
          if (!knownAccounts.contains(line.account)) {
            knownAccounts.add(line.account);
            yield LedgerEditAddAccount(line.account);
          }
          currentEntry.postings.add(currentPosting);
          _currentPosting = Posting(account: line.account, currency: line.currency, amount: line.amount, note: line.note);
        }
        else if (line is EntryLine) {
          currentEntry.postings.add(currentPosting);
          yield LedgerEditAddEntry(currentEntry);
          _currentEntry = Entry(date: line.date, code: line.code, payee: line.payee, state: line.state, postings: [], note: line.note);
          _currentPosting = null;
        }
        else if (line is AccountLine) {
          if (!knownAccounts.contains(line.name)) {
            knownAccounts.add(line.name);
            yield LedgerEditAddAccount(line.name);
          }
          currentEntry.postings.add(currentPosting);
          yield LedgerEditAddEntry(currentEntry);
          _currentEntry = null;
          _currentPosting = null;
        }
      }
    }
  }
}