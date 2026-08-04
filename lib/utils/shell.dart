import 'dart:io';
import 'package:jronix/utils/logger.dart';

Future<void> runCommand(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  String? progressMessage,
}) async {
  final progress = progressMessage != null ? logger.progress(progressMessage) : null;
  
  try {
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      mode: ProcessStartMode.normal,
    );
    
    final stdoutBuffer = StringBuffer();
    final stderrBuffer = StringBuffer();
    
    process.stdout.listen((data) => stdoutBuffer.write(String.fromCharCodes(data)));
    process.stderr.listen((data) => stderrBuffer.write(String.fromCharCodes(data)));
    
    final exitCode = await process.exitCode;
    
    if (exitCode != 0) {
      progress?.fail('Failed: $progressMessage');
      logger.err('Command failed: $executable ${arguments.join(' ')}');
      if (stdoutBuffer.isNotEmpty) logger.err(stdoutBuffer.toString());
      if (stderrBuffer.isNotEmpty) logger.err(stderrBuffer.toString());
      throw Exception('Command failed with exit code $exitCode');
    } else {
      progress?.complete('Completed: $progressMessage');
    }
  } catch (e) {
    progress?.fail('Error: $progressMessage');
    rethrow;
  }
}
