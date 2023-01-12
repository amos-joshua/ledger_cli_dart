
class CliWrapperException implements Exception {
  final String message;
  CliWrapperException(this.message);
  @override
  String toString() => "$runtimeType: $message";
}

class ExecutableDoesNotExistException extends CliWrapperException {
  ExecutableDoesNotExistException(super.message);
}

class PathIsNotExecutable extends CliWrapperException {
  PathIsNotExecutable(super.message);
}

class ExecutionFailed extends CliWrapperException {
  final int exitCode;
  final String stdErr;
  final String stdOut;
  ExecutionFailed(super.message, {required this.exitCode, required this.stdOut, required this.stdErr});

  @override toString() => "${super.toString()} (exit code $exitCode): $stdErr";
}