import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:jronix/utils/pubspec_manager.dart';
import 'package:jronix/utils/shell.dart';
import 'package:jronix/utils/logger.dart';
import 'package:path/path.dart' as p;

class ReleaseCommand extends Command {
  @override
  final name = 'release';
  @override
  final description = 'Prepares the Flutter project for release (Clean, Pub Get, Pod Install, Open Xcode).';

  @override
  void run() async {
    final currentDir = Directory.current.path;
    final pubspecPath = p.join(currentDir, 'pubspec.yaml');
    final iosDir = p.join(currentDir, 'ios');

    logger.info(lightCyan.wrap('══════════════════════════════════════'));
    logger.info(lightCyan.wrap('🚀 Preparing iOS Release...'));
    logger.info(lightCyan.wrap('══════════════════════════════════════\n'));

    try {
      // 1. Increment Version
      final versionProgress = logger.progress('📦 Updating Version...');
      incrementVersion(pubspecPath);
      versionProgress.complete('📦 Version Updated Successfully');

      // 2. Flutter Clean
      await runCommand(
        'flutter', 
        ['clean'], 
        progressMessage: '🧹 Cleaning Flutter Project...',
      );

      // 3. Flutter Pub Get
      await runCommand(
        'flutter', 
        ['pub', 'get'], 
        progressMessage: '📦 Getting Flutter Packages...',
      );
      
      // 4. Flutter Precache IOS
      await runCommand(
        'flutter', 
        ['precache', '--ios'], 
        progressMessage: '🍏 Precaching iOS artifacts...',
      );

      // 5. Pod Install
      if (Directory(iosDir).existsSync()) {
        await runCommand(
          'pod', 
          ['install', '--repo-update'], 
          workingDirectory: iosDir,
          progressMessage: '🍎 Installing CocoaPods...',
        );
      } else {
        logger.warn('⚠️ iOS directory not found. Skipping pod install.');
      }

      // 6. Open Xcode
      final workspacePath = p.join(iosDir, 'Runner.xcworkspace');
      if (Directory(workspacePath).existsSync()) {
        await runCommand(
          'open', 
          [workspacePath],
          progressMessage: '🚀 Opening Xcode...',
        );
      } else {
        logger.warn('⚠️ Runner.xcworkspace not found. Skipping Xcode open.');
      }

      logger.success('\n✅ Project Ready! You can now Archive from Xcode.');
    } catch (e) {
      logger.err('\n❌ Error during release preparation: $e');
      exit(1);
    }
  }
}
