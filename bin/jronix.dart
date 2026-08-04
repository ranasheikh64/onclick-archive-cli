import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:jronix/commands/release_command.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner("jronix", "A powerful CLI tool for Flutter release automation.");

  runner.addCommand(ReleaseCommand());

  try {
    if (arguments.isEmpty) {
      runner.printUsage();
      return;
    }
    await runner.run(arguments);
  } catch (e) {
    if (e is UsageException) {
      print(e.message);
      print(e.usage);
      exit(64);
    } else {
      print("Error: $e");
      exit(1);
    }
  }
}
