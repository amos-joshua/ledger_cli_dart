import 'dart:io';

import 'exceptions.dart';

class CliWrapper {
  final String executablePath;
  CliWrapper({required this.executablePath});

  Future<String> execute(List<String> args) async {
    await verifyBinaryExists();

    final result = await Process.run(executablePath, args);
    if (result.exitCode != 0) throw ExecutionFailed("Error executing '$executablePath'", exitCode:result.exitCode, stdOut:result.stdout, stdErr:result.stderr);
    return result.stdout;
  }

  Future<void> verifyBinaryExists() async {
    final fileType = await FileSystemEntity.type(executablePath);
    if (fileType == FileSystemEntityType.notFound) throw ExecutableDoesNotExistException("path '$executablePath' not found");
    if (fileType != FileSystemEntityType.file) throw PathIsNotExecutable("path '$executablePath' is not a file but a $fileType");
  }
}
