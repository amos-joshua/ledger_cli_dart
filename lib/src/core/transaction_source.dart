
import 'entry.dart';
import 'query.dart';

abstract class EntrySource {
  Future<Stream<Entry>> query(Query query);
}

