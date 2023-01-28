import 'parser/line_to_edit_transformer_test.dart' as line_to_edit_transformer_test;
import 'parser/edit_applier_test.dart' as edit_applier_test;
import 'parser/query_executor_test.dart' as query_executor_test;
import 'parser/string_parser_test.dart' as string_parser_test;

void main() {
  line_to_edit_transformer_test.main();
  edit_applier_test.main();
  query_executor_test.main();
  string_parser_test.main();
}