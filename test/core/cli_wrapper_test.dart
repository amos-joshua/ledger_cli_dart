import 'package:ledger_cli/ledger_cli.dart';
import 'package:test/test.dart';

void main() {
  group('cli wrapper', () {
    test('executing non-existent binary', () async {
      final cli = CliWrapper(executablePath: '/usr/not-bin/non-existent-binary-1234');
      expect(cli.verifyBinaryExists(), throwsA(isA<ExecutableDoesNotExistException>()));
    });

    test('executing a non-executable path', () async {
      final cli = CliWrapper(executablePath: '/tmp');
      expect(cli.verifyBinaryExists(), throwsA(isA<PathIsNotExecutable>()));
    });

    test('successful execution', () async {
      final cli = CliWrapper(executablePath: '/usr/bin/echo');
      expect(cli.execute(['hello']), completion('hello\n'));
    });

    test('failed execution', () async {
      final cli = CliWrapper(executablePath: '/usr/bin/ls');
      expect(cli.execute(['/tmp/non-existent-path.2138488781njdjshfkds/314159/']), throwsA(isA<ExecutionFailed>()));
    });
  });
}
