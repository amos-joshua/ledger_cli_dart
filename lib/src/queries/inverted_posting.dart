
import '../core/core.dart';

class InvertedPosting {
  final Posting posting;
  final Entry parent;
  InvertedPosting({required this.posting, required this.parent});

  @override
  String toString() => "InvertedPosting($posting |:| $parent)";

  @override
  bool operator ==(Object other) => (other is InvertedPosting) && (parent == other.parent) && (posting == other.posting);

  @override
  int get hashCode => Object.hash(posting, parent);
}