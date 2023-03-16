import '../../core/core.dart';
import 'query_result.dart';

class EntryFilterResult implements QueryResult {
  List<Entry> matches;
  EntryFilterResult({required this.matches});

  @override
  String toString() => 'EntryFilterResult(${matches.map((invertedPosting) => '$invertedPosting').join('\n')})';

  @override
  bool operator ==(Object other) {
    if (other is! EntryFilterResult) return false;
    if (other.matches.length != matches.length) return false;
    for (int i= 0; i < matches.length; i += 1) {
      if (matches[i] != other.matches[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => matches.hashCode;
}
