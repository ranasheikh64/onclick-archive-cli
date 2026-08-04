import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:jronix/utils/pubspec_manager.dart';
import 'package:jronix/utils/shell.dart';
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

    print('══════════════════════════════════════');
    print('🚀 Preparing iOS Release...');
    print('══════════════════════════════════════\n');

    try {
      // 1. Increment Version
      print('📦 Updating Version...');
      incrementVersion(pubspecPath);

      // 2. Flutter Clean
      print('\n🧹 Cleaning Flutter Project...');
      await runCommand('flutter', ['clean']);

      // 3. Flutter Pub Get
      print('\n📦 Getting Flutter Packages...');
      await runCommand('flutter', ['pub', 'get']);
      
      // 4. Flutter Precache IOS (optional but helpful)
      print('\n🍏 Precaching iOS artifacts...');
      await runCommand('flutter', ['precache', '--ios']);

      // 5. Pod Install
      if (Directory(iosDir).existsSync()) {
        print('\n🍎 Installing CocoaPods...');
        await runCommand('pod', ['install', '--repo-update'], workingDirectory: iosDir);
      } else {
        print('\n⚠️ iOS directory not found. Skipping pod install.');
      }

      // 6. Open Xcode
      final workspacePath = p.join(iosDir, 'Runner.xcworkspace');
      if (Directory(workspacePath).existsSync()) {
        print('\n🚀 Opening Xcode...');
        await runCommand('open', [workspacePath]);
      } else {
        print('\n⚠️ Runner.xcworkspace not found. Skipping Xcode open.');
      }

      print('\n✅ Project Ready! You can now Archive from Xcode.');
    } catch (e) {
      print('\n❌ Error during release preparation: $e');
      exit(1);
    }
  }
}
