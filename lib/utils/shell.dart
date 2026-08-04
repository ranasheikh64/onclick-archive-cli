import 'dart:io';

Future<void> runCommand(String executable, List<String> arguments, {String? workingDirectory}) async {
  print('➜ Running: $executable ${arguments.join(' ')}');
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    mode: ProcessStartMode.inheritStdio,
  );
  
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('Command failed with exit code $exitCode');
  }
}
