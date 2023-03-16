
import 'posting.dart';
import 'denominated_amount.dart';

// An entry's state, corresponding to '*', '!' or ''
enum EntryState {
  uncleared, pending, cleared
}

extension EntryStatusMethods on EntryState {
  String symbolString() => this == EntryState.pending ? "!" : this == EntryState.cleared ? "*" : "";
}

// An entry in the ledger
class Entry {
  DateTime date;
  String code;
  String payee;
  EntryState state;
  String note;
  final List<Posting> postings;
  Entry({required this.date, required this.code, required this.payee, required this.state, required this.postings, this.note=""});

  @override
  String toString() => "Entry(date: $date, code: $code, payee: $payee, state: $state, note: $note, postings: $postings)";

  @override
  bool operator ==(Object other) => (other is Entry) &&
      (date == other.date) &&
      (code == other.code) &&
      (payee == other.payee) &&
      (state == other.state) &&
      (note == other.note) &&
      comparePostings(other);

  bool comparePostings(Entry other) {
    if (postings.length != other.postings.length) return false;
    for (var i = 0; i < postings.length; i += 1) {
      if (postings[i] != other.postings[i]) return false;
    }
    return true;
  }

  // TODO: test
  Iterable<Posting> postingsForAccount(String account) => postings.where((posting) => posting.account == account);

  // TODO: test
  DenominatedAmount amountForAccount(String account) {
    final accountPostings = postingsForAccount(account);
    if (accountPostings.isEmpty) return DenominatedAmount(0, '');
    return DenominatedAmount(accountPostings.fold(0, (initialValue, posting) => initialValue + posting.amount), accountPostings.first.currency);
  }

  @override
  int get hashCode => Object.hash(date, code, payee, state, note);
}