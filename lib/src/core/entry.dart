
import 'posting.dart';

enum EntryState {
  uncleared, pending, cleared
}

extension EntryStatusMethods on EntryState {
  String symbolString() => this == EntryState.pending ? "!" : this == EntryState.cleared ? "*" : "";
}

class Entry {
  DateTime date;
  String code;
  String payee;
  EntryState state;
  String notes;
  final List<Posting> postings;
  Entry({required this.date, required this.code, required this.payee, required this.state, required this.postings, this.notes=""});

  @override
  String toString() => "Entry(date: $date, code: $code, payee: $payee, state: $state, notes: $notes, postings: $postings)";

  @override
  bool operator ==(Object other) => (other is Entry) &&
      (date == other.date) &&
      (code == other.code) &&
      (payee == other.payee) &&
      (state == other.state) &&
      (notes == other.notes) &&
      comparePostings(other);

  bool comparePostings(Entry other) {
    if (postings.length != other.postings.length) return false;
    for (var i = 0; i < postings.length; i += 1) {
      if (postings[i] != other.postings[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(date, code, payee, state, notes);
}