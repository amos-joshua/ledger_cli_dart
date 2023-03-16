import '../../core/core.dart';
import '../inverted_posting.dart';
import 'query_result.dart';

class PostingFilterResult implements QueryResult {
  List<InvertedPosting> matches;
  PostingFilterResult({required this.matches});

  @override
  String toString() => 'PostingFilterResult(${matches.map((invertedPosting) => '$invertedPosting').join('\n')})';

  @override
  bool operator ==(Object other) {
    if (other is! PostingFilterResult) return false;
    if (other.matches.length != matches.length) return false;
    for (int i= 0; i < matches.length; i += 1) {
      if (matches[i] != other.matches[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => matches.hashCode;
}
