import 'package:ledger_cli/src/core/account.dart';

import '../core/core.dart';
import 'lines/ledger_line_parser.dart';


class LedgerLineProcessor {
  final AccountManager accountManager;

  LedgerLineProcessor({required this.accountManager});
}